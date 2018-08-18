### MODEL BASICS WITH MODELR ###

# The goal of a model is to provide a simple low-dimensional summary of a dataset.
# In the context of this book we're going to use models to partition data into patterns and residuals.
# Strong patterns will hide subtler trends, 
# so we'll use models to help peel back layers of structure as we explore a dataset.

# Before we can start using models on interesting, real datasets, you need to understand the basics of how models work.
# For that reason, this chapter of the book is unique because it uses only simulated datasets.
# These datasets are very simple, and not at all interesting, but they will help you understand the essence of 
# modelling before you apply the same techniques to real data in the next chapter.

# There are two parts to a model:

# 1. First, you define a family of models that express a precise, but generic, pattern that you want to capture.
  ## For example, the pattern might be a straight line, or a quadratic curve.
  ## You will express the model family as an equation like y = a_1 * x + a_2.
  ## Here, x and y are known variables from your data, 
  ## and a_1 and a_2 are parameters that can vary to capture different patterns.


# 2. Next, you generate a fitted model by finding the model from the family that is the closest to your data.
  ## This takes the generic model family and makes it specific, like y = 3 * x + 7

# It's important to understand that a fitted model is just the closest model from a family of models.
# That implies that you have the "best" model (according to some criteria); it doesn't imply that you have a good 
# model and it certainly doesn't imply that the model is "true". 

# "All models are wrong, but some are useful", George Box.

# The goal of a model is not to uncover truth, but to discover a simple approximation that is still useful.


# Prerequisites -----------------------------------------------------------

  ## The 'modelr' package wraps around base R's modeling functions to make them work naturally in a pipe.

library(tidyverse)
library(modelr)
options(na.action = na.warn)


# A Simple Model ----------------------------------------------------------


