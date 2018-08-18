### R MARKDOWN WORKFLOW ### 

# R Markdown brings together the console and the script editor, burring the lines between interactive exploration and 
# long-term code capture.

# You can rapidly iterate within a chunk, editing and re-executing with Ctrl-Shift-Enter.
# When you're happy, you move on and start a new chunk.

# R Markdown is also important because it so tightly integrates prose and code.
# This makes it a great analysis notebook because it lets you develop code and record your thoughts.
# An analysis notebook shares many of the same goals as a classic lab notebook in the physical sciences. It:

  ## Records what you did and why you did it.
  ## Supports rigorous thinking.
  ## Helps others understand your work.

# Much of the good advice about using lab notebooks effectivelly can also be translated to analysis notebooks.
# Through this link (http://colinpurrington.com/tips/lab-notebooks) you can see tips like:

  ## Ensure each notebook has a descriptive title, an evocative filename, and a first paragraph that briefly describes
    ### the aims of the analysis.

  ## Use the YAML header date field to record the date you started working on the notebook.
    ### Use ISO8601 YYYY-MM-DD format so that's there no ambiguity.

  ## If you spend a lot of time on an analysis idea and it turns out to be a dead end, don't delete it!
    ### Write up a brief note about why it failed and leave it in the notebook. 
    ### That will help you avoid going down the same dead end when you come back to the analysis in the future.

  ## Generally, you're better off doing data entry outside of R.
    ### But if you do need to record a small snippet of data, clearly lay it out using tibble::tribble()

  ## If you discover an error in a data file, never modify it directly, but instead write code to correct the value.
    ### Explain why you made the fix.

  ## Before you finish for the day, make sure you can knit the notebook.
    ### That will let you fix any problems while the code is still fresh in your mind.

  ## If you want your code to reproducible in the long run, you'll need to track the versions of the packages that
    ### your code uses. A rigorous approach is to use 'packrat', which stores packages in your project directory,
    ### or 'checkpoint', which will reinstall packages available on a specified date. 

  ## You are going to create many, many, many analysis notebooks over the course of your career.
    ### To organize them, I recommend storing in individual projects, and coming up with a good naming scheme.