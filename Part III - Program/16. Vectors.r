### Vectors ###

library(tidyverse)


# Vector Basics -----------------------------------------------------------

# There are two types of vectors:

  ## Atomic vectors, of which there are six types:
    ### logical, integer, double, character, complex and raw.
  ## Lists, which are sometimes called recursive vectors because lists can contain other lists.

# The chief difference between atomic vectors and lists is that atomic vectors are homogeneous,
# while lists can be heterogeneous.

# Every vector has two key properties:
  ## Its type:
typeof(letters)
typeof(1:10)
  ## Its length
x <- list("a", "b", 1:10)
length(x)

# Vectors can also contain arbitrary additional metadata in the form of attributes.
# These attributes are used to create augmented vectors. There are four important types of augmented vector:

  ## Factors are built on top of integer vectors.
  ## Dates and date-times are built on top of numeric vectors.
  ## Data frames and tibbles are built on top of lists.

# This chapter will introduce you to these important vectors from simplest to most complicated.
# You'll start with atomic vectors, then build up lists, and finish off with augmented vectors.


# Important Types of Atomic Vector ----------------------------------------

# Logical

  ## Can take only three possible values: FALSE, TRUE, and NA.

1:10 %% 3 == 0

# Numeric

  ## In R, numbers are doubles by default.
  ## To make an integer, place a L after the number.

typeof(1)
typeof(1L)
1.5L

  ## Doubles are approximations. Doubles represent floating-point numbers that cannot always be precisely represented
  ## with a fixed amount of memory.
  ## This means that you should consider all doubles to be approximations.

x <- sqrt(2) ^ 2
x
x-2

  ## Integers have one special value, NA, while doubles have four, NA, NaN, Inf, and -Inf.

# Character


# Using Atomic Vectors ----------------------------------------------------

# Some important tools for working with Atomic Vectors are:

  ## How to convert from one type to another, and when that happens automatically.
  ## How to tell if an object is a specific type of vector.
  ## What happens when you work with vectors of different lengths.
  ## How to name the elements of a vector.
  ## How to pull out elements of interest.

# Coercion (Convertion)

  ## Explicit coercion happens when you call a function like:
  ## as.logical(), as.integer(), as.double, or as.character().

  ## When you try to create a vector containing multiple types with c(), the most complex type always wins:

typeof(c(TRUE, 1L)) # integer
typeof(c(1L, 1.5))  # double 
typeof(c(1.5, "a")) # character

  ## If you need to mix multiple types in the same vector, you should use a list.


# Test Functions


# Scalars and Recycling Rules

# Naming Vectors

  ## You can name vectors during creation with c():

c(x = 1, y = 2, z = 4)
purrr::set_names(1:3, c("a", "b", "c"))

  ## Named vectors are most useful for subsetting, described next.


# Subsetting

  ## [ ] is the subsetting function, and is called like x[a].
  ## There are four types of things that you can subset a vector with:

  ## A numeric vector containing only integers:

x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]
x[c(1, 1, 5, 5, 5, 2)]

x[c(-1, -3, -5)] # drop values


  ## Subsetting with a logical vector keeps all values corresponding to a TRUE value:

x <- c(10, 3, NA, 5, 8, 1, NA)
x[!is.na(x)]
x[x %% 2 == 0]


  ## If you have a named vector, you can subset it with a character vector:

x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]

  ## The simplest type of subsetting is nothing, x[], which returns the complete x



# Recursive Vectors (Lists) -----------------------------------------------

  ## You create a list with list():

x <- list(1, 2, 3)
x

  ## str() is very useful because it focuses on the structure, not the contents:

str(x)


x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

  ## Unlike atomic vectors, lists() can contain a mix of objects and even other lists:

y <- list("a", 1L, 1.5, TRUE)
str(y)

z <- list(list(1, 2), list(3, 4))
str(z)


# Subsetting

  ## There are three ways to subset a list, which I'll illustrate with 'a'

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))

  ## [ ] extracts a sublist. The result will always be a list:

str(a[1:2])
str(a[4])
    
    ### Like with vectors, you can subset with a logical, integer, or character vector.

  ## [[ ]] extracts a single component from a list. It removes a level of hierarchy from the list:

str(y[[1]])

str(y[[4]])

  ## $ is a shorthand for extracting named elements of a list. 
  ## It works similarly to [[ ]] except that you don't need to use quotes

a$a

a[["a"]]


  ## The distinction between [ ] and [[ ]] is really important for lists, because [[ ]] drills down into the list
  ## while [ ] returns a new, smaller list. 



# Attributes --------------------------------------------------------------

# Any vector can contain arbitrary additional metadata through its attributes.
# You can think of attributes as a named list of vectors that can be attached to any object.
# You can get and set individual attribute values with attr() or see them all at once with attributes():

x <- 1:10

attr(x, "greeting")

attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"

attributes(x)

# There are three very important attributes that are used to implement fundamental parts of R:

  ## 'Names' are used to name the elements of a vector.
  ## 'Dimensions' (dims, for short) make a vector behave like a matrix or array.
  ## 'Class' is used to implement the S3 object-oriented system.



# Augmented Vectors -------------------------------------------------------

# Augmented vectors are vectors with additional attributes, including class.
# Because they have a class, they behave differently to the atomic vector on which they are built.
# In this book, we make use of four important augmented vectors:
  ## Factors
  ## Date-times and times
  ## Tibble

# Factors

  ## Factors are designed to represent categorical data that can take a fixed set of possible values.
  ## Factors are built on top of integers, and have a levels attribute.

x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
attributes(x)


# Dates and Date-times

  ## Dates in R are numeric vectors that represent the number of days since 1 January 1970:

x <- as.Date("1971-01-01")
unclass(x)

typeof(x)
attributes(x)

  ## Date-times are numeric vectors with class POSIXct that represent the number of seconds since 1 January 1970.

x <- lubridate::ymd_hm("1970-01-01 01:00")
unclass(x)
typeof(x)
attributes(x)


# Tibbles

  ## Tibbles are augmented lists. 
  ## They have three classses: tbl_df, tbl, and data.frame.
  ## They have two attributes: names and row.names.

tb <- tibble::tibble(x = 1:5, y = 5:1)

typeof(tb)
attributes(tb)

  ## Traditional data.frames have a very similar structure:

df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
attributes(df)

  ## The main difference is the class.