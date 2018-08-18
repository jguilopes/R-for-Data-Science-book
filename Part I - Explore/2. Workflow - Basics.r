# CODING BASICS

  ## You can use R as a calculator:
1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

  ## You can create new objects with <- :
x <- 3 * 4

  ## All R statements where you create objects, assignment statements, have the same form:
    ### objectname <- value
  ## keyboard shorcut for <- is: Alt - 

  ## Code is miserable to read on a good day, so giveyoureyesabreak and use spaces.


# WHAT'S IN A NAME?

  ## Object names must start with a letter, and can only contain letters, numbers, _, and .

  ## To keep your objects names descriptive, use a convention for multiple words:
i_use_snake_case
otherPeopleUseCamelCase
some.people.use.periods
  ## We recommend snake_case, where you separate lowercase words with _

  ## You can inspect an object by typing its name:
x

  ## RStudio's completion facility: type the beginning of the object (or function,...), press Tab and then Return (enter):
this_is_a_really_long_name <- 2.5
this # and Tab

  ## In R language, you must be precise in your instructions. Typos matter. Case matters:
r_rocks <- 2*3
r_rock #error
R_rocks #error
r_rocks #correct!


# CALLING FUNCTIONS

  ## Quotations marks and parenthesis must always come in a pair.
seq(1, 10)
x <- "hello world"

  ## if you make an assignment surrounded by parenthesis, it will causes the assignment and print to screen
(y <- 10)

## To see the Keyboard Shortcut Reference, type: Alt Shift K