### FUNCTIONS ###

# One of the best ways to improve your reach as a data scientist is to write functions.
# Functions allow you to automate common tasks in a more powerful and general way than copying and pasting.
# Writing a function has three big advantages over using copy-and-paste:

  ## You can give a function an evocative name that makes your code easier to understand.
  ## As requirements change, you only need to update code in one place, instead of many.
  ## You eliminate the chance of making incidental mistakes when you copy and paste.

# The goal of this chapter is to get you started with some pragmatic advice that you can apply immediately.
# As well as practical advice for writing functions, this chapter also gives you some suggestions 
# for how to style your code.




# WHEN SHOULD YOU WRITE A FUNCTION? ---------------------------------------

  ## You should consider writing a function whenever you've copied and pasted a block of code more than twice.
  ## For example, take a look at this code:

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10))
  
df$a <- (df$a - min(df$a, na.rm = TRUE)) / (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

  ## This rescales each column have a range from 0 to 1.

  ## To write a function you need to first analyze the code.
  ## How many inputs does it have?

(df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

  ## This code only has one input: df$a.
  ## To make the inputs more clear, it's good idea to rewrite the code using temporary variables with general names.
  ## Here this code only requires a single numeric vector, so I'll call it x:

x <- df$a
(x <- min(x, na.rm = TRUE)) /
  (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

  ## There is some duplication in this code. We're computing the range of the data three times, but it makes sense
  ## to do it in one step:

rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])

  ## Pulling out intermediate calculations into named variables is a good practice because it makes it more clear
  ## what the code is doing.
  ## Now that we simplified the code, and checked that it still works, we can turn it into a function:

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(df)


  ## There are three key steps to creating a new function:

    ### 1. You need to pick a name for the function. Here I've used 'rescale01' because this function rescales a 
      #### vector to lie between 0 and 1.

    ### 2. You list the inputs, or arguments, to the function inside 'function'. Here we have just one argument.
      #### If we had more the call would look like function(x, y, z).

    ### 3. You place the code you have developed in the body of the function,
      #### { a block that immediately follows function(...) }.


  ## I only made the function after I'd figured out how to make it work with a simple input.
  ## It's easier to start with working code and turn it into a function;
  ## It's harder to create a function and then try to make it work.

  ## At this point it's a good idea to check your function with a few different inputs:

rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))


  ## As you write more and more functions you'll eventually want to convert these informal, interactive tests into
  ## formal, automated tests.
  ## That process is called unit testing. 
  ## Unfortunately, it's beyond the scope of this book but you can learn about it: http://r-pkgs.had.co.nz/tests.html

  ## We can simplify the original example now that we have a function:

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

  ## There is still quite a bit of duplication since we're doing the same thing to multiple columns.
  ## We'll learn how to eliminate that duplication in Chapter 17, 
  ## once you've learned more about R's data structures in Chapter 16.

  ## Another advantage of functions is taht if our requirements chage, we only need to make the change in one place.
  ## For example, we might discover that some of our variables include infinite values, and rescale01 fails:

x <- c(1:10, Inf)
rescale01(x)


  ## Because we've extracted the code into a function, we only need to make the fix in one place:

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(x)


  ## This is an important part of the "do not repeat yourself" (or DRY) principle.
  ## The more repetition you have in your code, the more places you need to remember to update when things change, 
  ## and the more likely you are to create bugs over time.


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.

  ## 6.

  ## 7.



# FUNCTIONS ARE FOR HUMANS AND COMPUTERS ----------------------------------

  ## R doesn't care what your function is called, or what comments it contains, but these are important for humans.
  ## This section discusses some things that you should bear in mind when writing functions that humans can understand

  ## The name of a function is important.
  ## Generally, function names should be verbs, and arguments should be nouns.
  ## A good sign that a noun might be a better hoice is if you're using a very broad verb like "get", "compute", 
  ## "calculate", or "determine". Use your best judgement and don't be afraid to rename a function if you figure
  ## out a better name later:

f() # too short

my_awesome_function() # not a verb, or descriptive

impute_missing()
collapse_years() # Long, but clear

  ## If you have a family of functions that do similar things, make sure they have consistent names and arguments.
  ## Use a common prefix to indicate that they are connected.
  ## That's better than a common suffix because autocomplete allows you to type the prefix and see all the members:

input_select()
input_checkbox()
input_text() # Good


select_input()
checkbox_input()
text_input() # Not so good


  ## Use comments to explain the "why" of your code. 
  ## You generally should avoid comments that explain the "what" or "how".
  ## Another important use of comments is to break up your file into easily readable chunks.
  ## Use long lines of - or = to make it easy to spot the breaks:
    ### Load data -----------------------------------------

  ## R-Studio provides a keyboard shortcut to create these headers (Ctrl-Shift-R), and will display them in the code
  ## navigation drop-down at the bottom-left of the editor.


# EXERCISES

  ## 1. 

  ## 2.

  ## 3.

  ## 4.



# CONDITIONAL EXECUTION ---------------------------------------------------

  ## An IF statement allows you to conditionally execute code. It looks like this:

if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}

  ## Here's a simple function that uses an 'if' statement. The goal of this function is to return a logical vector
  ## describing whether or not each element of a vector is names:

has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)){
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}



# CONDITIONS ---------------------------------------------------------------

  ## The condition must evaluate to either TRUE or FALSE.
  ## Don't use a vector or NA.

  ## You can use || (or) and && (and) to combine multiple logical expressions.

  ## Be careful when testing for equality. == is vectorized, which means that it's easy to get more than one output.
  ## Either check the length is already 1, collapse with all() or any(), or use the nonvectorized identical().

identical(0L, 0) #double with an integer

  ## You also need to be wary of floating-point numbers:

x <- sqrt(2) ^ 2
x
x == 2
x - 2

  ## Instead, use dplyr::near() for comparisons.


# MULTIPLE CONDITIONS -----------------------------------------------------

  ## You can chain multiple if statements together:

if (this) {
    # do that
} else if (that) {
    # do something else
} else {
    #
}



# CODE STYLE --------------------------------------------------------------

  ## Both if and function should (almost) always be followed by squiggly brackets ({}).
  ## It's OK to drop the curly braces if you have a very short if statement that can fit on one line.

# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.

  ## 6.



# FUNCTION ARGUMENTS ------------------------------------------------------

  ## The arguments to a function typically fall into two broad sets:
  ## one set supplies the data compute on, 
  ## and the other supplies arguments that control the details of the computation.

  ## Generally, data arguments shoudl come first.
  ## Detail arguments should go on the end, and usually should have default values.
  ## You specify a default value in the same way you call a function with a named argument:

mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

x <- runif(100)
mean_ci(x)
mean_ci(x, conf = 0.99)


  ## The default value should almost always be the most common value.
  ## The few exceptions to this rule have to do with safety.
  ## For example, it makes sense for na.rm to default fto FALSE because missing values are important.

  ## When you call a function, you tipically omit the names of the data arguments, because they are used so commonly.
  ## If you override the default value of a detail argument, you should use the full name.



# CHOOSING NAMES ----------------------------------------------------------

  ## The names of the arguments are also important. 
  ## Gnerally you should prefer longer, more descriptive names, but there are a handful of very common and short names
  ## It's worth memorizing these:

    ### x, y, z: vectors
    ### w: a vector of weights
    ### df: a data frame
    ### i, j: numeric indices (typically rows and colums)
    ### n: length, or number of rows
    ### p: number of colums.

  ## Otherwise, consider matching names of arguments in existing R functions.
  ## For example, use na.rm to determine if missing values should be removed.



# CHECKING VALUES ---------------------------------------------------------

  ## As you start to write more functions, you'll eventually get to the point where you don't remember exactly
  ## how your function works.
  ## At this point it's easy to call your function with invalid inputs.
  ## To avoid this problem, it's often useful to make constraints explicit.

  ## It's good practice to check important preconditions, and throw an error (with stop()) if they're not true:

wt_mean <- function(x, w) {
  if (length(x) != length(w)){
    stop("`x` and `w` must be the same length", call. = FALSE)
  }
  sum(w*x) / sum(x)
}


  ## Be careful not to to take this too far.
  ## There's a trade-off between how much time you spend making your function robust, 
  ## versus how long you spend writing it.

  ## A useful compromise is the built-in 'stopifnot()'
  ## it checks that each argument is TRUE, and produces a generic error message if not:

wt_mean <- function(x, w, na.rm = FALSE) {
  stopifnot(is.logical(na.rm), length(na.rm) == 1)
  stopifnot(length(x) == length(w))
  sum(w*x) / sum(x)
}

  ## Note that when using stopifnot() you assert what should be true rather than checking for what might be wrong.



# DOT-DOT-DOT(...) --------------------------------------------------------

  ## Many functions ir R take an arbitrary number of inputs:

sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
stringr::str_c("a", "b", "c", "d", "e", "f")

  ## How do these functions work? They rely on a special argument: ...
  ## This special argument captures any number of arguments that aren't otherwise matched.

  ## It's useful because you can then send those ... on to another function.
  ## This is a useful catch-all if your function primarily wraps another function. For example:

commas <- function(...) {stringr::str_c(..., collapse = ", ")}
commas(letters[1:10])



# LAZY EVALUATION ---------------------------------------------------------

  ## Arguments in R are lazily evaluated: they're not computed until they're needed.
  ## That means if they're never used, they're never called.

# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.



# RETURN VALUES -----------------------------------------------------------

  ## Figuring out what your function should return is usually straightforward:
  ## it's why you creathe the function in the first place!
  ## There are two things you should consider when returning a value:

    ### Does returning early make your function easier to read?
    ### Can you make your function pipeable?

# EXPLICIT RETURN STATEMENTS

  ## The value returned by the function is usually the last statement it evaluates, bt you can choose to return
  ## early by using return().

  ## I think it's best to save the use of return() to signal that you can return early with a simpler solution.
  ## A common reason to do this is because the inputs are empty:

complicated_function <- function(x, y, z) {
  if (length(x) == 0 || length(y) == 0) {
    return(0)
  }
  # Complicated code here
}


  ## Another reason is because you have an 'if' statement with one complex block and one simple block.
  ## But if the first block is very long, by the time you get to the else, you've forgotten the 'condition'.


# WRITING PIPEABLE FUNCTIONS

  ## If you want to write your own pipeable functions, thinking about the return value is important.
  ## There are two main types of pipeable functions: transformation and side-effect.

  ## In 'transformation' functions, there's a clear primary object that is passed in as the first argument,
  ## and a modified version is returned by the function.
  ## If you can identify what the object type is for your domain, 
  ## you'll find that your functions just work with the pipe.

  ## 'Side-effect' functions are primarily called to perform an action, like drawing a plot or saving a file,
  ## not transforming an object.
  ## These functions should 'invisibly' return the first argument, so they're not printed by default, but can still
  ## be used in a pipeline.


show_missings <- function(df) {
  n <- sum(is.na(df))
  cat("Missing values: ", n, "\n", sep = "")
  
  invisible(df)
}

show_missings(mtcars)

mtcars %>% 
  show_missings() %>% 
  mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>% 
  show_missings()




# ENVIRONMENT -------------------------------------------------------------

  ## The environment of a function controls how R finds the value associated with a name.
  ## For example, take this function:

f <- function(x) {
  x + y
}

  ## In many programming languages, this would be an error, because y is not defined inside the function.
  ## In R, this is valid code because R uses rules called 'lexical scoping' to find the value associated with a name.
  ## Since y is not defined inside the function, R will look in the environment where the function was defined:

y <- 100
f(10)

y <- 1000
f(10)

  ## Learning how to make the best use of this flexibility is beyond the scope of this book, but you can read about
  ## it in 'Advanced R': http://adv-r.had.co.nz

