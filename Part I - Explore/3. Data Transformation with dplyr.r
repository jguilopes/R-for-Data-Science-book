# INTRODUCTION
  ## It is rare that you get the data in exactly the right form you need.
  ## Often you'll need to create some new variables or summaries, 
  ## or maybe you just want to rename the variables or reorder the observations in order to make the data a little easier to work with.

  ## In this chapter we'll learn how to transform data using the dplyr package
  ## We'll illustrate the key ideas using data from the nycflights13 package, and ggplot2 to help us understand the data.

library("nycflights13")
library("tidyverse")
  ## note the conflict message on the Console
  ## dplyr has the filter() and lag() functions. if you want to use the base version, do stats::filter() and stats::lag()

# NYCFLIGHTS13

?flights
flights
View(flights) ## to see the whole dataset

  ## when we execute the dataset name, notice that on the console appears a row of letter abbreviations under the column names
  ## these describe the type of each variable:
    ### INT stands for integers;
    ### DBL stands for doubls, or real numbers;
    ### CHR stands for character vectors, or strings;
    ### DTTM stands for date-times (a date + a time);
    ### LGL stands for logical, vectors that contain only TRUE or FALSE;
    ### FCTR stands for factors, which R uses to represent categorical variables with fixed possible values;
    ### DATE stands for dates;

# DPLYR BASICS

  ## The five key dplyr functions that allow you to solve the majority of your data-manipulation are:
    ### pick observations by their values: filter()
    ### reorder the rows: arrange()
    ### pick variables by their names: select()
    ### create new variables with functions of existing variables: mutate()
    ### collapse many values down to a single summary: summarize()

  ## These can all be used in conjunction with group_by(),
  ## which changes the scope of each function from operating on the entire dataset to operating on it group-by-group.
  ## These six functions provide the verbs for a language of data manipulation.

  ## All verbs work similarly:
    ### 1. The first argument is a data frame;
    ### 2. The subsequent argument describe what to do with the dataframe, using the variable names (without quotes);
    ### 3. The result is a new data frame.

  ## Together these properties make it easy to chain together multiple simple steps to achieve a complex result.

# FILTER ROWS WITH FILTER()

  ## filter() allows you to subset observations based on their values.
  ## For example, we can select all flights on January 1st with:
filter(flights, month == 1, day == 1) ### just returns a new data frame, doesn't modify their inputs.

  ## If you want to save the result, use the assignment operator:
jan1 <- filter(flights, month == 1, day == 1)
  ## Or you can save and print at the same time, wrapping the assignment in parentheses:
(dec25 <- filter(flights, month == 12, day == 25))

  ## COMPARISONS
  ## To use filtering effectively, you use the comparison operators:
    ### >
    ### >=
    ### <
    ### <=
    ### != (not equal)
    ### == (equal)
      #### the easiest mistake to make is to use = instead of ==
  
  ## Important: another common problem when using == is because of floating-point numbers.
sqrt(2)^2 == 2 ### it results as FALSE!
1/49 * 49 == 1 ### it results as FALSE!

  ## Computers use finite precision arithmetic, so remember that every number you see is an approximation.
  ## So instead of relying on ==, use near():
near(sqrt(2)^2, 2)
near(1/49 * 49, 1)

  ## LOGICAL OPERATORS
  ## Multiple arguments to filter() are combined with "and":
  ## every expression must be true in order for a row to be included in the output.
  ## For other types of combinations, you'll need to use Boolean operators yourself:
    ### & stands for "and"
    ### | stands for "or"
    ### ! stands for "not"
  
  ## the following code finds all flights that departed in November OR December:
filter(flights, month == 11 | month == 12)
    ### you cant't write "month == 11 | 12"
    ### a useful shorthand for this problem is x %in% y
    ### this will select every row where x is one of the values in y:
nov_dec <- filter(flights, month %in% c(11,12))

  ## Sometimes you can simplify complicated subsetting by remembering De Morgan's law:
    ### !(x & y) is the same as !x | !y
    ### !(x | y) is the same as !x & !y
  ## for example, if you wanted to find flights that weren't delayed (on arrival or departure) by more than two hours:
  ## you could use either of the following two filters:
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120 & dep_delay <= 120)

  ## R also has && and ||. Don't use them here!
  ## You'll learn when you should use them in "Conditional Execution" (page 276)

  ## MISSING VALUES
  ## One important feature of R that can make comparison tricky is missing values, or NA ("not availables")
  ## NA represents an unknown value so missing values are "contagious"
  ## almost any operation involving an unknown value will also be unknown:
NA > 5
NA + 10
NA / 2
  ## a bit of context to understand:
    ### let x be Mary's age. we don't know how old she is
x <- NA
    ### let y be John's age. we don't know how old he is
y <- NA
    ### are John and Mary the same age?
x == y
    ### we don't know!

  ## If you want to determine if a value is missing, use is.na()
is.na(x)

  ## filter() only includes rows where the condition is TRUE; it excludes both FALSE and NA values.
  ## If you want to preserve missing values, ask for them explicitly:
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1) # results just the 3
filter(df, is.na(x) | x > 1) # results the NA and the 3

# EXERCISES

  ## 1. 
  ## 1.a) 
filter(flights, arr_delay >= 120)
  ## 1.b)
filter(flights, dest == "IAH" | dest == "HOU")
  ## 1.c)
?flights
airlines
filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL")
  ## 1.d)
filter(flights, month== 7 | month == 8 | month == 9)
  ## 1.e)
filter(flights, arr_delay > 120 & dep_delay <= 0)
  ## 1.f) 
    ### "made up over 30 minutes" ?
  ## 1.g)
filter(flights, dep_time %in% c(0000: 0600))

  ## 2.
?between()
    ### ?
  
  ## 3.
filter(flights, is.na(dep_time))
    ### 8,255 flights has a missing dep_time
    ### dep_delay, arr_time, arr_delay
    ### Might represents flights that has been cancelled

  ## 4. 
NA ^ 0 ### cause any ^ 0  = 1
NA | TRUE ### ?
FALSE & NA ### ? 


# ARRANGE ROWS WITH arrange()

  ## arrange works similarly to filter() except that instead of selecting rows, it changes their order.
  ## it takes a data frame and a set of column names (or expressions) ot order by.
  ## If you provide more than one column name, each additional column will be used to break ties in the values of preceding columns:
arrange(flights, year, month, day)

  ## use desc() to reorder by a column in descending order:
arrange(flights, desc(arr_delay))

  ## missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# EXERCISES

  ## 1. 
arrange(df, desc(is.na(x)))

  ## 2.
arrange(flights, desc(arr_delay, dep_delay))
arrange(flights, dep_time)

  ## 3. 
arrange(flights, dep_time, arr_time)

  ## 4. 
arrange(flights, dep_time, desc(arr_time))
    ### ?

# SELECT COLUMNS WITH select()

  ## select() allows you to rapidly zoom in on a subset of the data frame using operations based on the names of the variables

  ## on the flight data we just have 19 variables, but let's use it just for example the general idea:

  ## select columns by name:
select(flights, year, month, day)

  ## select all columns between year and day (inclusive):
select(flights, year:day)

  ## select all columns excepth those from year to day (inclusive):
select(flights, -(year:day))

  ## Some useful functions you can use within select():
    ### starts_with("abc"): matches names that begin with "abc"
    ### ends_with("xyz"): matches names that end with "xyz"
    ### contains("ijk"): matches names that contain "ijk'
    ### matches("(.)\\1"): selects variables that match a regular expression
      #### this one matches any variables that contain repeated characters
      #### we'll see more in 11th chapter
    ### num_range("x", 1:3): matches x1, x2 and x3

  ## see ?select for more details

  ## select() can be used to rename variables, but it's rarely useful
  ## instead, use rename(), which is a variant of select() that keeps all the variables that aren't explicitly mentioned:
rename(flights, tail_num = tailnum)

  ## Another option is to use select() in conjunction with the everything() helper.
  ## this is useful if you have a handful of variables you'd like to move to the start of the data frame:
select(flights, time_hour, air_time, everything())

# EXERCISES

  ## 1.
select(flights, dep_time, dep_delay, arr_time, arr_delay)

  ## 2.
select(flights, dep_time, dep_time)
    ### nothing
  
  ## 3. 
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

  ## 4. 
select(flights, contains("TIME"))


# ADD NEW VARIABLES WITH mutate()

  ## It's often useful to add new columns that are functions of existing columns.
  ## That's the job of mutate()

  ## mutate() always adds new columns at the end of your dataset so we'll start by creating a narrower dataset so we can see the new variables.

flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
View(flights_sml)

mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time*60)

# Note that you can refer to columns that you've just created:
mutate(flights_sml, gain = arr_delay - dep_delay, hours = air_time*60, gain_per_hour = gain/hours)

# If you only want to keep the new variables, use transmute():
transmute(flights, gain = arr_delay - dep_delay, hours = air_time*60, gain_per_hour = gain/hours)

  ## USEFUL CREATION FUNCTIONS

  ## There are many functions for creating new variables that you can use with mutate()
  ## The key property is that the function must be vectorized:
    ### it takes a vector of values as input, and return a vector with the same number of values as output.

  ## There's no way to list every possible function that you might use, but here's a selections of functions that are frequently useful:

  ## Arithmetic Operators: +, -, *, /, ^

  ## Modular arithmetic:
    ### %/% for integer divison
    ### %% for remainder
transmute(flights, dep_time, hour = dep_time %/% 100, minute = dep_time %% 100)

  ## Logarithms: log(), log2() and log10()
    ### Logs are an useful transformation for dealing with data that ranges across multiple orders of magnitude.
    ### They also convert multiplicative relationships to additive (We'll see more in Part IV)
    ### The author recommends using log2() because it's easy to interpret.

  ## Offsets
    ### lead() and lag()

  ## Cumulative and rolling aggregates
    ### cumsum(), cumprod(), cummin(), cummax() are from R base; cummean() is from dplyr.
x <- 1:10
x
cumsum(x)
cummean(x)
cumprod(x)
cummin(x)
cummax(x)


  ## Logical comparisons: <, <=, >, >=, !=
    ### It can be useful create a variable for checking if any operations is going right.

  ## Ranking
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)


# EXERCISES

  ## 1.
flights$dep_time %/% 100
transmute(flights, dep_time = (dep_time %/% 100 *60) + (dep_time %% 100), sched_dep_time = (sched_dep_time %/% 100 *60) + (sched_dep_time %% 100))

  ## 2. 
transmute(flights, air_time, flying = arr_time - dep_time)

  ## 3.

  ## 4.

  ## 5. 

1:3 + 1:10

  ## 6.


# GROUPED SUMMARIES WITH summarize()

  ## The function summarize() collapses a data frame to a single row.
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

  ## summarize() is very useful when we pair it with group_by()

by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

  ## Together group_by() and summarize() provide on of the tools that you'll use most commonly when working with dplyr: grouped summaries.

  ## But before we go any further with this, we need to introduce a powerful new idea: the pipe.


# COMBINING MULTIPLE OPERATIONS WITH THE PIPE %>%

  ## Imagine that we want to explore the relationship between the distance and average delay for each location.
  ## From what we learned until now, we would write code like this:

by_dest <- group_by(flights, dest)
delay <- summarize(by_dest, count = n(), dist = mean(distance, na.rm = T), delay = mean(arr_delay, na.rm = T))
delay <- filter(delay, count > 20, dest != "HNL")
delay

  ## ?n()

ggplot(delay, aes(x = dist, y = delay))+
  geom_point(aes(size = count))+
  geom_smooth(se = F)

  ## Notice that we had to do three steps to prepare the data:
    ### 1. Group flights by destination
    ### 2. Summarize to compute distance, average delay and number of flights.
    ### 3. Filter to remove noisy points and Honolulu airport, which is very far.

  ## There's another way to tackle the same problem with the pipe: %>%
delays <- flights %>%
  group_by(dest) %>%
  summarize(count = n(), dist = mean(distance, na.rm = T), delay = mean(arr_delay, na.rm = T)) %>%
  filter(count > 20, dest != "HNL")

  ## This focuses on the transformation, not what's being transformed, which makes the code easier to read.
  ## You can read it as a series of imperative statements: group, then summarize, then filter.


# MISSING VALUES

  ## Let's see what happens if we don't use the na.rm argument:
flights %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))
  ## We get a lot of missing values! 
  ## That's because aggregation functions obey the usual rule of missing values: if there's any NA in the input, the output will be a NA. 
  ## Fortunately, all aggregation functions have an na.rm argument, which removes the NA prior to computation:
flights %>%
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay, na.rm = T))

  ## In this case, where NA represent cancelled flights, we could also tackle the problem by first removing the cancelled flights.
  ## We'll save this dataset so we can reuse it in the next few examples.

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))


# COUNTS

  ## Whenever you do any aggregation, it's always a good idea to include either a count (n()), or a count of nonmissing values (sum(!is.na(x))).
  ## That way you can check that you're not drawing conclusions based on very small amounts of data.
  
  ## For example, let's look at the planes (identified by their tail number) that have the highest average delays:

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay = mean(arr_delay))

ggplot(data=delays, mapping = aes(x=delay))+
  geom_freqpoly(binwidth = 10)

  ## We can get more insight if we draw a scatterplot of number of flights versus average delay:

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay = mean(arr_delay, na.rm = T), n = n())

ggplot(delays, aes(x = n, y = delay))+
  geom_point(alpha = 0.5)

  ## When looking at this sort of plot, it's often useful to filter out the groups with the smallest number of observations,
  ## so you can see more of the pattern and less of the extreme  variation in the smallest groups.

delays %>%
  filter(n > 25) %>%
  ggplot(aes(x = n, y = delay))+
  geom_point(alpha = 0.5)

    ### see page 65

# USEFUL SUMMARY FUNCTIONS

  ## Just using means, counts, and sum can get you a long way, but R provides many other useful summary functions:

  ## Measures of location
    ### mean(x) is the sum divided by the length;
    ### median(x) is a value where 50% of the data is above it, and 50% is below it.

  ## It's sometimes useful to combine aggregation with logical subsetting:

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]))

  ## Measures of spread
    ### sd(x) for standart deviation
    ### IQR(x) for interquantile range
    ### mad(x) for median absolute deviation
    ### those functions can be very useful if you have outliers.

    ### Why is distance to some destinations more variable than to others?

not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

  ## Measures of rank
    ### min(x)
    ### quantile(x, 0.25)
    ### max(x)
  
    ### when do the first and last flights leave each day?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(first = min(dep_time), last = max(dep_time))

  ## Measures of position
    ### first(x)
    ### nth(x, 2)
    ### last(x)
    
    ### these works similarly to x[1], x[2], ... but let you set a default value if that position doesn't exist.
    ### for example, we can find the first and last departure for each day:

not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(first_dep = first(dep_time), last_dep = last(dep_time))

    ### These functions are complementary to filtering on ranks.
    ### Filtering gives you all variables, with each observation in a separate row:

not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))


  ## Counts
    ### You've seen n(), which takes no arguments, and returns the size of the current group.
    ### To count the number of non-missing values, use sum(!is.na(x)).
    ### To count the number of distinct (unique) values, use n_distinct(x):

    ### which destinations have the most carriers?

not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

    ### Counts are so useful that dplyr provides a simple helper if all you want is a count:
not_cancelled %>%
  count(dest)

    ### You can optionally provide a weight variable. 
    ### For example, you could use this to "count" (sum) the total number of miles a plan flew:

not_cancelled %>%
  count(tailnum, wt = distance)


  ## Counts and proportions of logical values; sum(x > 10), mean(y == 0)
    ### When used with numeric functions, TRUE is converted to 1 and FALSE to 0.
    ### This makes sum() and mean() very useful:
    ### sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion:

    ### how many flights left before 5am?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

    ### what proportion of flights are delayed by more than an hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))


# GROUPING BY MULTIPLE VARIABLES

  ## When you group by multiple variables, each summary peels off one level of the grouping.
  ## That makes it easy to progressively roll up a dataset:

daily <- flights %>% group_by(year, month, day)
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))

# UNGROUPING

  ## If you need to remove grouping, and return to operations on ungrouped data, use ungroup():
daily %>%
  ungroup() %>%
  summarize(flights = n())


# EXERCISES

  ## 1. 

  ## 2. 

  ## 3. 

  ## 4. 
  
  ## 5. 

  ## 6. 

  ## 7.


# GROUPED MUTATES (AND FILTERS)

  ## Grouping is most useful in conjunction with summarize(),
  ## but you can also do convenient operations with mutate() and filter():

    ### Find the worst members of each group:
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

    ### Find all groups bigger than a threshold:
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)
popular_dests

    ### Standardize to compute per group metrics:
popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)

# EXERCISES

  ## 1. 

  ## 2.

  ## 3.

  ## 4.
    
  ## 5.

  ## 6.

  ## 7.