# TIBBLES WITH tibble

# Introduction

  ## Tibbles are data frames, but they tweak some older behaviors to make life a little easier.
  ## It's difficult to change base R without breaking existing code, so most innovation occurs in packages.
  ## Here we'll describe the "tibble" package, which provides opinionated data frames that make working in the tidyverse a little easier.
  ## I'll use the terms tibble and data frame interchangeably; when I want to draw particular attention to R's built-in data frame, I'll call them data.frames.

  ## If this chapter leaves you wanting to learn more about tibbles, you might enjoy:
vignette("tibble")

  ## The tibble package is part of the core tidyverse:
library(tidyverse)

# CREATING TIBBLES

  ## Almost all of the function that you'll use in this book produce tibbles, as tibbles are one of the unifying features of the tidyverse.
  ## Most other R packages, use regular data frames, so you might want to coerce a data frame to a tibble.
  ## You can do that with as_tibble():

as_tibble(iris)

  ## You can create a new tibble from individual vectors with tibble().
  ## tibble() will automatically recycle inputs of length 1, and allows you to refer to variables that you just created, as shown here:

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)

  ## tibble() never changes the type of the inputs, it never changes the names of variables and it never creates row names.

  ## It's possible for a tibble to have column names that are not valid R variable names, aka nonsyntatic names.
  ## For example, not start with a letter or contain unusual characters like a space.
  ## To refers to these variables, you need to surround them with backticks ' :
tb <- tibble(
  ':)' = "smile",
  ' ' = "space",
  '2000' = "number"
)

tb

  ## You'll also need the bacticks when working with these variables in other packages, like ggplot2, dplyr and tidyr.

  ## Another way to create a tibble is with tribble(), short for transposed tibble.
  ## tribble() is customized for data entry in code:
    ### column headings are defined by formulas (i.e., they start with ~),
    ### and entries are separated by commas.
  ## This makes it possible to lay out small amounts of data in easy-to-read form:

tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5
)
    ### I ofter add a comment (line 56) to make it really clear where the header is.

# TIBBLES VERSUS DATA.FRAME

  ## There are two main differences in the usage of a tibble versus a classic data.frame: printing and subsetting.

  ## PRINTING
    ### Tibbles shows only the first 10 rows, and all the columns that fit on screen.
    ### This makes it much easier to work with large data.
    ### In addition to its name, each column reports its type, a nice feature borrowed from str():
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

    ### If you want to see more of the dataset, you can explicitly print() the data frame and control the number of rows(n),
    ### and the width of the display. width = Inf will display all columns:

nycflights13::flights %>%
  print(n = 5, width = Inf)

    ### You can also control the default print behavior by setting options:
      #### options(tibble.print_max = n, tibble.print_min = m):
      #### if more than m rows, print only n rows.
      #### Use options(dplyr.print_min = Inf) to always show all rows.
    
      #### Use options(tibble.width = Inf) to always print all columns, regardless of the width of the screen.


  ## SUBSETTING
    ### If you want to pull out a single variable, you need some new tools, $ and [[.
    ### [[ can extract by name or position; $ only extracts by name but is a little less typing:

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

      #### Extract by name:
df$x
df[["x"]]
      
      #### Extract by position
df[[1]]

    ### To use these in a pipe, you'll need to use the special placeholder . :
df %>%
  .$x

df %>%
  .[["x"]]


# INTERACTING WITH OLDER CODE
  
  ## Some older functions don't work with tibbles.
  ## If you encounter one of these functions, use as.data.frame() to turn a tibble back to a data.frame:
class(as.data.frame(tb))


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.

  ## 6.