### TIDY DATA WITH tidyr ###

# This chapter will give you a practical introduction to tidy data and the accompanying tools in the tidyr package.
# If you'd like to learn more about the underlying story, you might enjoy the "Tidy Data paper", published in the Journal of Statistical Software:
  ## http://www.jstatsoft.org/v59/i10/paper

# We'll focus on tidyr, a package that provides a bunch of tools to help tidy up your messy datasets. tidyr is a member of the core tidyverse.

library(tidyverse)

# TIDY DATA

  ## You can represent the same underlying data in multiple ways.
    ## The following exaple shows the same data organized in four different ways.

table1
table2
table3

  ## Spread across two tibbles:

table4a # cases
table4b # population

  ## These are all representations of the same underlying data, but they are not equally easy to use.
  ## One dataset, the tidy dataset, will be much easier to work with inside the tidyverse.

  ## There are three interrelated rules which make a dataset tidy:
    ### 1. Each variable must have its own column
    ### 2. Each observation must have its own row
    ### 3. Each value must have its own cell

  ## These three rules are interrelated because it's impossible to only satisfy two of the three.
  ## That interrelationship leads to an even simpler set of practical instructions:
    ### 1. Put each dataset in a tibble
    ### 2. Put each variable in a column

  ## In this example, only table1 is tidy.

  ## dplyr, ggplot2, and all the other packages in the tidyverse are designed to work with tidy data.
  ## Here are a couple of small examples showing how you might work with table1:

    ### compute cases per 10,000
table1 %>%
  mutate(rate = cases / population * 10000)

    ### compute cases per year
table1 %>%
  count(year, wt = cases)

    ### visualize changes over time
table1 %>%
  ggplot(aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") + 
  geom_point(aes(color = country))


# EXERCISES

  ## 1.

  ## 2.

  ## 3.


# SPREADING AND GATHERING

  ## For most real analyses you'll need to do some tidying.
  ## The first step is to figure out what the variables and observations are.
  ## Sometimes this is easy; other times you'll need to consult with the people who originally generated the data.
  ## The second step is to resolve one of two common problems:
    ### one variable might be spread across multiple columns.
    ### one observation might be scattered across multiple rows.
  ## To fix these problems, you'll need the two most important functions in tidyr: gather() and spread()

# GATHERING

  ## A common problem is a dataset where some of the column names aren't names of variables, but values of a variable.
  ## Take table4a; the column names 1999 and 2000 represent values of the year variable, and each row represents two observations, not one:
table4a

  ## To tidy a dataset like this, we need to 'gather' those columns into a new pair of variables.
  ## To describe that operation we need three parameters:
    ### the set of columns that represent values, not variables. In this example, the columns 1999 and 2000
    ### the name of the variable whose values form the column names. I call that the 'key', and here it is year
    ### the name of the variable whose values are spread over the cells. I call that 'value', and here it's the number of cases

  ## Together those parameters generate the call to gather():
table4a %>%
  gather('1999', '2000', key = "year", value = "cases")

  ## The columns to gather are specified with dplyr::select() style notation.

  ## In the final result, the gathered columns are dropped, and we get new 'key' and 'values' columns.
  
  ## We can use gather() to tidy table4b in a similar fashion:
table4b %>%
  gather('1999', '2000', key = "year", value = "population")

  ## To combine the tidied versions of table4a and table4b into a single tibble,
  ## we need to use dplyr::left_join(), which you'll learn about in Chapter 10:

tidy4a <- table4a %>%
  gather('1999', '2000', key = "year", value = "cases")

tidy4b <- table4b %>%
  gather('1999', '2000', key = "year", value = "population")

left_join(tidy4a, tidy4b)


# SPREADING

  ## Spreading is the opposite of gathering.
  ## You use it when an observation is scattered across multiple rows.

  ## For example, take table2:
    ### an observation is a country in a year, but each observation is spread across two rows:

table2

  ## To tidy this up, we first analyze the representation in a similar way to gather().
  ## This time, however, we only need two parameters:
    ### The column that contains variable names, the key column. Here, it's 'type'
    ### The column that contains values forms multiple variables, the value column. Here, it's 'count'
  ## Once we've figured that out, we can use spread():

table2 %>%
  spread(key = type, value = count)

  ## spread() and gather() are complements:
    ### gather() makes wide tables narrower and longer
    ### spread() makes long tables shorter and wider.


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.


# SEPARATING AND PULL

  ## table3 has a different problem: one column (rate) contains two variables (cases and population).
  ## To fix this problem, we'll need the separate() function.
  ## You'll also learn about the complement of separate(): unite(),
    ### which you use if a single variable is spread across multiple columns.

# SEPARATE

  ## separate() pulls apart one column into multiple columns, 
  ## by splitting wherever a separator character appears. Take table3:
table3

  ## the rate column contains both 'cases' and 'population' variables,
  ## and we need to split it into two variables.
  ## separate() takes the name of the column to separate, and the names of the columns to separate into:

table3 %>%
  separate(rate, into = c("cases", "population"))

  ## By default, separate() will split values wherever it sees a non-alphanumeric character (number or letter)
  ## In the example, separate() split the values of 'rate' at the forward slash characters.
  
  ## If you wish to use a specific character to separate a column, 
  ## you can pass the character to the sep argument of separate().
  ## For example, we could rewrite the preceding code as:

table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/")

  ## Notice that 'cases' and 'population' are character columns.
  ## This is the default behavior is separate():
    ### it leaves the type of the column as is.
  ## Here, however, it's not very useful as those really are number.
  ## We can ask separate() to try and convert to better types using convert = TRUE:

table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)

  ## You can also pass a vector of integers to sep.
  ## separate() will interpret the integers as positions to split at.
  ## positive values start at 1 on the far left of the strings
  ## negative values start at -1 on the far right of the strings.
  ## When using integer to separate strings, the length of sep should be one less than the number of names in into.
  ## For examples:

table3 %>%
  separate(year, c("century", "year"), sep = 2)


# UNITE

  ## unite() is the inverse of separate():
  ## it combines multiple columns into a single column.
  ## You'll need it much less frequently than separate(), but it's still a useful tool to know.

  ## unite() takes a data frame, the name of the new variable to create, and a set of columns to combine.

table5

table5 %>%
  unite(new, century, year)

  ## In this case we also need to use the sep argument.
  ## The default will place an underscore (_) between the values from different columns.
  ## Here we don't want any separator so we use "":

table5 %>%
  unite(new, century, year, sep = "")


# EXERCISES

  ## 1.

  ## 2. 

  ## 3.


# MISSING VALUES

  ## Changing the representation of a dataset brings up an important subtlety of missing values.
  ## Suprisingly, a value can be missing in one of two possible ways:
    ### Explicitly, i.e., flagged with NA
    ### Implicitly, i.e., simply not present in the data.

  ## Let's illustrate this idea with a very simple dataset:

stocks <- tibble(
  year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr = c(1, 2, 3, 4, 2, 3, 4),
  return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)

  ## There are two missing values in this dataset:
    ### the return for the fourth quarter of 2015, explicitly marked as NA
    ### the return for the first quarter of 2016 is implicitly missing, it does not appear in the dataset.

  ## The difference is like:
    ### an explicitly missing value is the presence of an absence
    ### an implicitly missing value is the absence of a presence.

  ## The way that a dataset is represented can make implicit values explicit.
  ## For example, we can make the implicit missing value explicit by putting years in the columns:

stocks %>%
  spread(year, return)

  ## Because these explicit missing values may not be important in other representations of the data,
  ## you can set na.rm = TRUE in gather() to turn explicit missing values implicit:

stocks %>%
  spread(year, return) %>%
  gather(year, return, `2015`:`2016`, na.rm = TRUE)

  ## Another important tool for making missing values explicit in tidy data is complete():

stocks %>%
  complete(year, qtr)

  ## complete() takes a set of columns, and finds all unique combinations.
  ## It then ensures the original dataset contains all those values, filling in explicit NAs where necessary.

  ## There's one other important tool that you should know for working with missing values.
  ## Sometimes when a data source has primarily been used for data entry, 
  ## missing values indicate that the previous value should be carried forward:

treatment <- tribble(
  ~person, ~treatment, ~response,
  "Derrick Whitmore", 1, 7,
  NA, 2, 10,
  NA, 3, 9,
  "Katherine Burke", 1, 4,
  NA, 8, 12
)

treatment

  ## You can fill in these missing values with fill().
  ## It takes a set of columns where you want missing values to replaced by the most recent nonmissing values
    ### sometimes called last observation carried forward

treatment %>%
  fill(person)



# EXERCISES

  ## 1.

  ## 2.


# CASE STUDY

  ## To finish off the chapter, let's pull together everything you've learned to tackle a realistic data tidying problem.
  ## The tidyr::who dataset contains tuberculosis (TB) cases broken down by year, country, age, gender, and diagnosis method.
  ## There's a wealth of epidemiological information in this dataset,
  ## but it's challenging to work with the data in the form that it's provided:

who

  ## This is a very typical real-life dataset.
  ## It contains redundant columns, odd variable codes, and many missing values.
  ## In short, 'who' is messy, and we'll need multiple steps to tidy it.

  ## Like dplyr, tidyr is designed so that each function does one thing well.
  ## That means in real-life situations you'll usually need to string together multiple verbs into a pipeline.

  ## The best place to start is almost always to gather together the columns that are not variables.
  
  ## Let's have a look at what we've got:
    ### it looks like 'country', 'iso2' and 'iso3' are three variables that redundantly specify the country.
    ### 'year' is clearly also a variable.
    ### We don't know what all the other columns are yet,
      #### but given the structure in the variable names, these are likely to be values, not variables.

  ## So we need to gather together all the columns from new_sp_m014 to newrel_f65.
  ## We don't know what those values represent yet, so we'll give them the generic name 'key'.
  ## We know the cells represent the count of cases, so we'll use the variable 'cases'.

  ## There are a lot of missing values in the current representation, 
  ## so for now we'll use na.rm just so we can focus on the values that are present:

who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key = "key",
         value = "cases",
         na.rm = TRUE)

who1


  ## We can get some hint of the structure of the values in the new 'key' column by counting them:

who1 %>%
  count(key)

  ## The data dictionary tells:
    ### the first three letters of each column denote wheter the column contains new or old cases of TB. In this dataset, each column contains new cases.
    ### The next two letter describe the type of TB
      ### rel, ep, sn, and sp
    ### The sixth letter gives the sex of TB patients. The dataset groups cases by males(m) and females(f)
    ### The remaining numbers give the age group
      ### for example, 1524 = 15-24 years old.

  ## We need to make a minor fix to the format of the column names
  ## unfortunately the name are slightly inconsistent because instead of new_rel we have newrel.
  ## You'll learn about str_replace() in Chapter 11, but the basic idea is pretty simple:
    ### replace the characters "newrel" with "new_rel". 
  ## This makes all variable names consistent:

who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))

who2

  ## We can separate the values in each code with two passes of separate().
  ## The first pass will split the codes at each underscore:

who3 <- who2 %>%
  separate(key, c("new", "type", "sexage"), sep = "_")

who3

  ## Then we might as well drop the 'new' column because it's constant
  ## and also drop the 'iso2' and 'iso3' columns since they're redundant:

who3 %>%
  count(new)

who4 <- who3 %>%
  select(-new, -iso2, -iso3)

who4

  ## Next we'll separate 'sexage' into 'sex' and 'age' by splitting after the first character:

who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep = 1)

who5

  ## The who dataset is now tidy!

  ## Here's all the code built up in a complex pipe:

who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>%
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
  separate(code, c("new", "var", "sexage")) %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep = 1)


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

# NONTIDY DATA

  ## Tidy data is not the only way
  ## There are lots of useful and well-founded data structures that are not tidy data
  ## If you'd like to learn more about nontidy data:
    ### http://simplystatistics.org/2016/02/17/non-tidy-data/