### RELATIONAL DATA WITH dplyr ###

# INTRODUCTION

# It's rare that a data analysis involves only a single table of data.
# Typically you have many tables of data, and you must combine them to answer the questions that you're interested in.
# Collectively, multiple tables of data are called 'relational data' beause it is the relations, not just the individual datasets, that are important.

# Relations are always defined between a pair of tables.
# All other relations are built up from this simple idea:
  ## the relations of three or more tables are always a property of the relations between each pair.
# Sometimes both elements of a pair can be the same table!
# This is needed if, for example, you have a table of people, and each person has a reference to their parents.

# To work with relational data you need verbs that work with pairs of tables.
# There are three families of verbs designed to work with relational data:

# Mutating joins,
  ## which add new variables to one data frame from matching observations in another.

# Filtering joins,
  ## which filter observations from one data frame based on whether or not they match an observation in the other table.

# Set operation, 
  ## which treat observations as if they were set elements.

# The most common place to find relational data is in a relational database management system (RDBMS), a term that encompasses almost all modern databases.
# If you've used a database before, you've almost certainly used SQL.
# If so, you should find the concepts in this chapter familiar, althought their expression in dplyr is a little different.
# Generally, dplyr is a little easier to use than SQL because dplyr is specialized to do data analysis.



# PREREQUISITES

  ## We'll explore relational data from nycflights13 using the two-table verbs from dplyr.
library(tidyverse)
library(nycflights13)

# NYCFLIGHTS13

  ## We'll use the nycflights13 package to learn about relational data.
  ## nycflights13 contains four tibbles that are related to the 'flights' table that you used in Chapter 3:

  ## 'airlines' lets you look up the full carrier name from its abbreviated code:
airlines

  ## 'airports' gives information about each airport, identified by the 'faa' airport code:
airports

  ## 'planes' gives information about each plane, identified by its tailnum:
planes

  ## 'weather' gives the weather at each NYC airport for each hour:
weather


  ## For 'nycflights13':
    ### 'flights' connects to 'planes' via a single variable, 'tailnum'
    ### 'flights' connects to 'airlines' through the 'carrier' variable'
    ### 'flights' connects to 'airports' in two ways: via the 'origin' and 'dest' variables
    ###'flights' connects to 'weather' via 'origin' (the location), and 'year','month','day', and 'hour' (the time)

# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.


# KEYS

  ## The variables used to connect each pair of tables are called keys.
  ## A key is a variable (or set of variables) that uniquely identifies an observation.
  ## In simple cases, a single variable is sufficient to identify an observation.
    ### For example, each plane is uniquely identified by its 'tailnum'.
  ## In other cases, multiple variables may be need.
    ### For example, to identify an observation in 'weather' you need five variables: year, month, day, hour and origin.

  ## There are two types of keys:
    ### A 'primary key' uniquely identifies an observation in its own table.
      #### For example, planes$tailnum is a primary key because it uniquely identifies each plane in the planes table.
    ### A 'foreign key' uniquely identifies an observation in another table.
      #### For example, flights$tailnum is a foreign key because it appears in the flights table where it matches each flight to a unique plane.

  ## A variable can be both a primary key and a foreign key.
    ### For example, 'origin' is part of the 'weather' primary key, and is also a foreign key for the 'airport' table.

  ## Once you've identified the primary keys in your tables, it's good practice to verify that they do indeed uniquely identify each observation.
  ## One way to do that is to count() the primary keys and look for entries where n is greater than one:
planes %>%
  count(tailnum)%>%
  filter(n>1)

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)

  ## Sometimes a table doesn't have an explicit primary key:
  ## ech row is an observation, but no combination of variables reliably identifies it.
  ## For example, what's the primary key in the 'flights' table?
  ## You might think it would be the date plus the flight or tail number, but neither of those are unique:

flights %>%
  count(year, month, day, flight)%>%
  filter(n > 1)

flights %>%
  count(year, month, day, tailnum)%>%
  filter(n > 1)

  ## When starting to work with this data, I had naively assumed that each flight number would be only used once per day:
    ### that would make it much easier to communicate problems with a specific flight.
  ## Unfortunately that is not the case! 
  ## If a table lacks a primary key, it's sometimes useful to add one with mutate() and row_number().
  ## That makes it easier to match observations if you've done some filtering and want to check back in with the original data.
  ## This is called a 'surrogate key'.

  ## A primary key and the corresponding foreign key in another table form a 'relation'.
  ## Relations are typically one-to-many.
  ## For example, each flight has one plane, but each plane has many flights.
  ## In other data, you'll occasionally see a 1-to-1 relationship.
  ## You can think of this as a special case of 1-to-many.
  ## You can model many-to-many relations with a many-to-1 relation plus a 1-to-many relation.
  ## For example, in this data there's a many-to-many relationship between airlines and airports:
    ### each airline flies to many airports; each airport hosts many airlines.


# EXERCISES

  ## 1.

  ## 2.

  ## 3.


# MUTATING JOINS

  ## A mutating join allows you to combine variables from two tables.
  ## It first matches observations by their keys, then copies across variables from one table to the other.

  ## Like mutate(), the join functions add variables to the right,
    ### so if you have a lot of variables already, the new variables won't get printed out.
  ## For these examples, we'll make it easier to see what's going on in the example by creating a narrower dataset:

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

  ## Imagine you want to add the full airline name to the 'flights2' data.
  ## You can combine the 'airlines' and 'flights2' data frames with left_join():

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")

  ## The result of joining airlines to 'flights2' is an additional variable: name.
  ## This is why I call this type of join a mutating join.
  ## In this case, you could have got to the same place using mutate() and R's base subsetting:

flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

  ## But this is hard to generalize when you need to match multiple variables, and takes close reading to figure out the overall intent.

  ## The following sections explain, in detail, how mutating joins work.
  ## We'll explain to the four mutating join functions: the inner join, and the three outer joins.
  ## When working with real data, keys don't always uniquely identify observations, 
    ### so next we'll talk about what happens when there isn't a unique match.
  ## Finally, you'll learn how to tell 'dplyr' which variables are the keys for a given join.


# UNDERSTANDING JOINS

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2", 
  3, "x3")

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2", 
  4, "y3")

  ## The 'key' variable is used to match the rows between the tabbles.
  ## In these examples I'll show a single key variable and single value variable, 
    ### but the idea generalizes in a straightforward way to multiple keys and multiple values.

  ## A join is a way of connecting each row in 'x' to zero, one, or more rows in 'y'.


# INNER JOIN

  ## The simplest type of join is the 'inner join'.
  ## An inner join matches pairs of observations whenever their keys are equal:

  ## The output of an inner join is a new data frame that contains the key, the x values, and the y values.
  ## We use 'by' to tell dplyr which variable is the key:

x %>%
  inner_join(y, by = "key")

  ## The most important property of an inner join is that unmatched rows are not included in the result.
  ## This means that generally inner joins are usually not appropiate for use in analysis because it's too easy to lose observations.


# OUTER JOINS

  ## An inner join keeps observations that appear in both tables.
  ## An 'outer join' keeps observations that appear in at least one of the tables.
  ## There are three types of outer joins:
    ### A 'left join' keeps all observations in x
    ### A 'right join' keeps all observations in y
    ### A 'full join' keeps all observations in x and y.

  ## These joins work by adding an additional "virtual" observation to each table.
  ## This observation has a key that always matches (if no other key matches), and a value filled with NA.

x %>%
  left_join(y, by = "key")

x %>%
  right_join(y, by = "key")

x %>%
  full_join(y, by = "key")

  ## The most commonly used join is the left join:
    ### you use this whenever you look up additional data from another table, 
    ### because it preserves the original observations even when there isn't a match.
  ## The left join should be your default join:
    ### use it unless you have a strong reason to prefer one of the others.


# DUPLICATE KEYS

  ## This section explains what happens when the keys are not unique.
  ## There are two possibilities:
   
     ### One table has duplicate keys. 
      #### This is useful when you want to add in additional information as there is typically a one-to-many relationship:

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4")

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2")

left_join(x, y, by = "key") #note that the key is a primary key in y and a foreign key in x

    ### Both tables have duplicate keys.
      #### This is usually an error because in neither table do the keys uniquely identify an observation.
      #### When you join duplicated keys, you get all possible combinations, the Cartesian product:

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4")

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4")

left_join(x, y, by = "key")


# DEFINING THE KEY COLUMNS

  ## You can use other values for 'by' to connect the tables in other ways:

  ## The default, by = NULL, uses all variables that appear in both tables, the so-called natural join.
   ### For example, the flights and weather tables match on their commong variables: year, month, day, hour, and origin:

flights2 %>%
  left_join(weather)

  ## A character vector, by = "x". 
    ### This is like a natural join, but uses only some of the common variables.
    ### For example, 'flights' and 'planes' have 'year' variables, but they mean different things so we only want to join by tailnum:

flights2 %>%
  left_join(planes, by = "tailnum")
    ### note that the 'year' variables are disambiguated in the output with a suffix.

  ## A named character vector: by = c("a" = "b").
    ### This will match variable 'a' in table x to variable 'b' in table y.
    ### The variables from x will be used in the output.

    ### For example, if we want to draw a map we need to combine the flights data with the airports data, which contains the location of each airport.
    ### Each flight has an origin and destination airport, so we need to specify which one we want to join to:

flights2 %>%
  left_join(airports, c("dest" = "faa"))

flights2 %>%
  left_join(airports, c("origin" = "faa"))


# EXERCISES

  ## 1. 

  ## 2.

  ## 3.

  ## 4.

  ## 5.


# OTHER IMPLEMENTATIONS

  ## base::merge() can perform all four types of mutating join:

    ### inner_join(x, y)  -> merge(x, y)
    ### left_join(x, y) -> merge(x, y, all.x = TRUE)
    ### right_join(x, y) -> merge(x, y, all.y = TRUE)
    ### full_join(x, y) -> merge(x, y, all.x = TRUE, all.y = TRUE)

  ## SQL is the inspiration for dplyr's conventions, so the translation is straightforward:

    ### inner_join(x, y, by = "z")
      #### SELECT * FROM x INNER JOIN y USING (z)

    ### left_join(x, y, by = "z")
      #### SELECT * FROM x LEFT OUTER JOIN y USING (z)

    ### right_join(x, y, by = "z")
      #### SELECT * FROM x RIGHT OUTER JOIN y USING (z)

    ### full_join(x, y, by = "z")
      #### SELECT * FROM x FULL OUTER JOIN y USING (z)

  ## Note that "INNER" and "OUTTER" are optional, and often omitted.


# FILTERING JOINS

  ## Filtering joins match observations in the same way as mutating joins, but affect the observations, not the variables.
  ## There are two types:

    ### semi_join(x, y) keeps all observations in x that have a match in y.
    ### anti_join(x, y) drops all observations in x that have a match in y.

  ## Semi joins are useful for matching filtered summary tables back to the original rows.
  ## For example, imagine you've found the top-10 most popular destinations:

top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)

top_dest

  ## Now you want to find each flight that went to one of those destinations.
  ## You could construct a filter yourself:

flights %>%
  filter(dest %in% top_dest$dest)

  ## But it's difficult to extend that approach to multiple variables.
  ## For example, imagine that you'd found the 10 days with the highest average delays.
  ## How would you construct the filter statement that used 'year', 'month', and 'day' to match it back to flights?

  ## Instead you can use a semi-join, which connects the two tables like a mutating join,
  ## but instead of adding new columns, only keeps the rows in x that have a match in y:

flights %>%
  semi_join(top_dest)


  ## Anti-joins are useful for diagnosing join mismatches.
  ## For example, when connecting 'flights' and 'planes', you might be interested to know that there are many flights that don't have a match in planes:

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = T)


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.

  ## 6.


# JOIN PROBLEMS

  ## Things that you should do with your own data to make your joins go smoothly:

  ## 1. Start by identifying the variables that form the primary key in each table.
  ## You should usually do this based on your understanding of the data, not empirically by looking for a combination of variables that give a unique identifier.
  ## If you just look for variables without think about what they mean, you might get (un)lucky and find a combination that's unique in your current data but the relationship might not be tru in genereal.
  ## For example, the altitude and longitude uniquely identify each airport, but they're not good identifiers!

airports %>%
  count(alt, lon) %>%
  filter(n > 1)

  ## 2. Check that none of the variables in the primary key are missing. 
  ## If a values is missing then it can't identify an observation!

  ## 3. Check that your foreign keys match primary keys in another table.
  ## The best way to do this is with an anti_join(). 
  ## It's common for keys not to match because of data entry errors.
  ## Fixing these is often a lot of work.



# SET OPERATIONS

  ## The final type of two-table verb are the set operations.
  ## Generally, I use these the least frequently, but they are occasionally useful when you want to break a single complex filter into simpler pieces.
  ## All these operations work with a complete row, comparing the values of every variable.
  ## These expect the x and y inputs to have the same variables, and treat the observations like sets:

intersect(x, y) # Return only observations in both x and y.

union(x, y) # Return unique observations in x and y.

setdiff(x, y) # Return observations in x, but not in y.

  ## Given this simple data:
df1 <- tribble(
  ~x, ~y,
  1, 1, 
  2, 1)

df2 <- tribble(
  ~x, ~y,
  1, 1, 
  1, 2)

  ## The four possibilites are:

intersect(df1, df2)

union(df1, df2)

setdiff(df1, df2)

setdiff(df2, df1)

