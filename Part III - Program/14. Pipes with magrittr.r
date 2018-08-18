# PART III - PROGRAM

  ## Programming produces code, and code is a tool of communication.
  ## Obviously code tells the computer what you want it to do. But it also communicates meaning to other humans.
  ## Writing clear code is important so that others (like future-you) can understand why you 
    ### tackled an analysis in the way you did.
  ## That means getting better at programming also involves getting better at communicating.
  ## Over time, you want your code to become not just easier to write, but easier for others to read.

  ## Once you've mastered the material in this book, 
    ### I strongly believe you should invest further in your programming skills.
  
  ## To learn more you need to study R as a programming language, not just an interactive environment for data science
  ## We have written two books that will help you do so:
    ### 'Hands-on Programming with R', by Garrett Grolemund.
    ### 'Advanced R', by Hadley Wickham. 
      #### This is a great place to start if you have existing programming experience.
      #### It's also a great next step once you've internalized the ideas in these chapters.
      #### You can read it online at http://adv-r.had.co.nz

### PIPES WITH magrittr ###

# Pipes are a powerful tool for clearly expressing a sequence of multiple operations.
# In this chapter, it's time to explore the pipe in more detail.

# The pipe, %>%, comes from the magrittr package, that is already inside tidyverse.

library(magrittr)


mtcars %$%
  cor(disp, mpg)

# For assgnment, magrittr provides the %<>% operator, which allows you to replace code like:
mtcars <- mtcars %>%
  transform(cyl = cyl * 2)
# with:
mtcars %<>% transform(cyl = cyl * 2)
