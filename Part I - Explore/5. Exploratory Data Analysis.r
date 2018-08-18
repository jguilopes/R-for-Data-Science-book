library(tidyverse)

# This chapter will show you how to use visualization and transformation to explore your data in a systematic way
# A task that statisticians call Exploratory Data Analysis, or EDA for short.
# EDA is an iterative cycle. You:
  ## 1. Generate questions about your data.
  ## 2. Search for answers by visualizing, transforming and modeling your data.
  ## 3. Use what you learn to refine your questions and/or generate new questions.

# EDA is not a formal process with a strict set of rules. More than anything, EDA is a state of mind.
# During the initial phases of EDA you should feel free to investigate every idea that occurs to you.
# Some of these ideas will pan out, and some will be dead ends.

# EDA is an important part of any data analysis, even if the questions are handed to you on a platter, because you always need to investigate the quality of your data.
# Data cleaning is just one application of EDA:
  ## you ask questions about wheter or not your data meets your expectations.
# To do data cleaning, you'll need to deploy all the tools of EDA:
  ## visualization, transformation and modeling.

# In this chapter we'll combine dplyr and ggplot2 to interactively ask questions, answer them with data and then ask new questions.

# QUESTIONS

  ## "There are no routine statistical questions, only questionable statistical routines." 
    ### Sir David Cox
  ## "Far better an approximate answer to the right question, which is often vague, than an exact answer to the wrong question, which can always be made precise."
    ### John Tukey

  ## Your goal during EDA is to develop an unerstanding of your data.
  ## The easiest way to do this is to use questions as tools to guide your investigation.
  ## When you ask a question, the question focuses your attention on a specific part of your dataset and helps you decide which graphs, models, or transformations to make.

  ## EDA is fundamentally a creative process. 
  ## And like most creative processes, the key to asking quality questions is to generate a large quantity of questions.
  ## It is difficult to ask revealing questions at the start of your analysis because you don't know what insights are contained in your dataset.
  ## On the other hand, each new question that you ask will expose you to a new aspect of your data and increase your chance of making a discovery.
  ## You can quickly drill down into the most interesting parts of your data if you follow up each question with a new question based on what you find.

  ## There is no rule about which questions you should ask to guide your research.
  ## However, two types of questions will always be useful for making discoveries within your data.
  ## You can loosely word these questions as:
    ### 1. What type of variation occurs within my variables?
    ### 2. What type of covariation occurs between my variables?
  ## The rest of this chapter will look at these two questions.
  ## To make the discussion easier, let's define some terms:
    ### A variable is a quantity, quality, or property that you can measure.
    ### A value is the state of a variable when you measure it. The value of a variable may change from measurement to measurement.
    ### An observation, or a case, is a set of measurements made under similar conditions.
    ### Tabular data is a set of values, each associated with a variable and an observation. 
      #### Tabular data is tidy if each value is placed in its own "cell", each variable in its own column, and each observation in its own row.

  ## In real life, most data isn't tidy, so we'll come back to these ideas again in Chapter 9.

# VARIATION

  ## Variation is the tendency of the values of a variable to change from measurement to measurement.
  ## Every variable has its own pattern of variation, which can reveal interesting information.
  ## The best way to understand that pattern is to visualize the distribution of variables' values.

# VISUALIZING DISTRIBUTIONS

  ## How you visualize the distribution of a variable will depend on wheter the variable is categorical or continuous.
  ## A variable is categorical if it can only take one of a small set of values.
  ## In R, categorical variables are usually saved as factors or character vectors.
  ## To examine, the distribution of a categorical variable, use a bar chart.

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

  ## The height of the bars displays how many observations occured with each x value.
  ## You can compute these values manually with dplyr::count():
diamonds %>%
  count(cut)

  ## A variable is continuous if it can take any of an infinite set of ordered values.
  ## Numbers and date-times are two examples of continuous variables.
  ## To examine the distribution of a continuous variable, use a histogram:

ggplot(diamonds, aes(x = carat))+
  geom_histogram(binwidth = 0.5)

  ## You can compute this by hand by computing dplyr::count() and ggplot2::cut_width():
diamonds %>%
  count(cut_width(carat, 0.5))

  ## You should always explore a variety of binwidths when working with histograms, as different binwidths can reveal different patterns.
  ## For example, here is how the preceding graph looks when we zoom into just the diamonds with a size of less than three carats and choose a smaller binwidth:

smaller <- diamonds %>%
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)

  ## If you wish to overlay multiple histograms in the same plot, I recommend using geom_freqpoly() instead of geom_histogram().
  ## geom_freqpoly() performs the same calculation as geom_histogram(), but instead of bars, uses lines.
  ## It's much easier to understand overlapping lines than bars:

ggplot(smaller, aes(x = carat, color = cut))+
  geom_freqpoly(binwidth = 0.1)

  ## There are a few challenges with this type of plot, which we'll come back soon.

# TYPICAL VALUES

  ## In both bar charts and histograms, tall bars show the common values of a variable, and shorter bars show less-common values.
  ## To turn this information into useful questions, look for anything unexpected:
    ### Which values are the most common? Why?
    ### Which values are rare? Why? Does that match your expectations?
    ### Can you see any unusual patterns? What might explain them?

  ## As an example, the following histogram suggests several interesting questions:
    ### Why are there more diamonds at whole carats and common fractions of carats?
    ### Why are there more diamonds slightly to the right of each peak than there slightly to the left of each peak?
    ### Why are there no diamonds bigger than 3 carats?
ggplot(smaller, aes(x = carat))+
  geom_histogram(binwidth = 0.01)

  ## In general, clusters of similar values suggest that subgroups exist in your data.
  ## To understand the subgroups, ask:
    ### How are the observations within each cluster similar to each other?
    ### How are the observations in separate clusters different from each other?
    ### How can you explain or describe the clusters?
    ### Why might the appearance of clusters be misleading?

  ## The following histogram shows the lenght (in minutes) of 272 eruptions of a volcano.
  ## Eruptions times appear to be clustered into two groups: 
    ### Short eruptions (of around 2 minutes)
    ### Long eruptions (4 -5 minutes)
    ### and a little in between:
ggplot(faithful, aes(x = eruptions))+
  geom_histogram(binwidth = 0.25)

  ## Many of the preceding questions will prompt you to explore a relationship between variables
  ## for example, to see if the values of one variable can explain the behavior of another variable.
  ## We'll get to that shortly.

# UNUSUAL VALUES (OUTLIERS)

  ## Outliers are observations that are unusual; data points that don't seem to fit the pattern.
  ## Sometimes outliers are data entry erros; other times outliers suggest important new science.
  ## When you have a lot of data, outliers are sometimes difficult to see in a histogram.

  ## For example, on the next graph, the only evidence of outliers is the unusually wide limits on the y-axis:
ggplot(diamonds, aes(x = y))+
  geom_histogram(binwidth = 0.5)

  ## To make it easy to se the unsual values, we need to zoom in to small values of the y-axis with coord_cartesian():
ggplot(diamonds, aes(x = y))+
  geom_histogram(binwidth = 0.5)+
  coord_cartesian(ylim = c(0,50))
    
    ### coord_cartesian() also has an xlim() argument for when you need to zoom into the x-axis.
    ### ggplot2 also has xlim() and ylim() functions that work slightly differently:
      #### they throw away the data outside the limits.

  ## This allows us to see that there are three unsual values (0, ~30 and ~60).
  ## We pluck them out with dplyr:

unusual <- diamonds %>%
  filter(y < 3 | y > 20) %>%
  arrange(y)
unusual

  ## It's good practice to repeat your analysis with and without the outliers.
  ## If they have minimal effect on the results, and you can't figure out why they're there, it's reasonable to replace them with NA and move on.
  ## However, if they have a substantial effect on your results, you shouldn't drop them without justification.
  ## You'll need to figure out what caused them and disclose that you removed them in your write-up.

# EXERCISES

  ## 1 .
diamonds
diamonds %>%
  ggplot(aes(x = x))+
  geom_histogram()

diamonds %>%
  ggplot(aes(x = y))+
  geom_histogram()

diamonds %>%
  ggplot(aes(x = z))+
  geom_histogram()

  ## 2. 

diamonds %>%
  ggplot(aes(x=price))+
  geom_histogram(binwidth = 1000)

  ## 3.

diamonds %>%
  filter(carat == 0.99)
    ### 23 diamonds are 0.99 carat
diamonds %>%
  filter(carat == 1)
    ### 1558 diamonds are 1 carat

  ## 4.


# MISSING VALUES

  ## If you've encountered unsual values in your dataset, and simply want to move on to the rest of your analysis, you have two options:
  
  ## Drop the entire row with the strange values:
diamonds2 <- diamonds %>%
  filter(between(y, 3, 20))
    ### I don't recommend this option as just because one measurement is invalid, doesn't mean all the measurements are.
    ### Additionally, if you have low-quality data, by time that you've applied this to everything you'll end without any data left.

  ## Replace the unsual values with missing values (Recommended)
    ### The easiest way to do this is to use mutate() to replace the variable with a modified copy.
    ### You can use the ifelse() function to replace unusual values with NA:
diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

  ## ifelse() has three arguments. 
    ### The first argument test should be a logical vector.
    ### if the logical is true, it'll return the second argument;
    ### if the logical is false, it'll return the third argument.

  ## ggplot2 doesn't include missing values in the plot, but it does warn that they've been removed:
ggplot(diamonds2, aes(x = x, y = y))+
  geom_point()

  ## To suppress that warning, set na.rm = TRUE:
ggplot(diamonds2, aes(x = x, y = y))+
  geom_point(na.rm = TRUE)

  ## Other times you want to understand what makes observations with NA different from observations with recorded values.
  ## For example, in "flights", NA values in the dep_time variable indicate that the flight was cancelled.
  ## So you might want to compare the schedule departure times for cancelled and noncancelled times.
  ## You can do this by making a new variable with is.na():
library(nycflights13)

flights %>%
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_min = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_min / 60) %>%
  ggplot(aes(sched_dep_time))+
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

  ## However, this plot isn't great because there are many more noncancelled flights than cancelled flights.
  ## In the next section we'll explore some techniques for improving this comparison.

# EXERCISES

  ## 1. 

  ## 2.
mean(diamonds$y)
mean(diamonds2$y, na.rm = T)
sum(diamonds$y)
sum(diamonds2$y, na.rm = TRUE)

# COVARIATION

  ## If variation describes the behavior within a variable, covariation describes the behavior between variables.
  ## Covariation is the tendency for the values of two or more variables to vary together in a related way.
  ## The best way to spot covariation is to visualize the relationship between two or more variables.
  ## How you do that should again depend on the type of variables involved.

# A CATEGORICAL AND CONTINUOUS VARIABLE

  ## It's common to want to explore the distribution of a continuous variable broken down by a categorical variable, as in the previous frequency polygon.
  ## The default appearence of geom_frequpoly() is not that useful for that sort of comparison because the height is given by the count.
  ## That means if one of the groups is much smaller than others, it's hard to see the differences in shape.
  ## For example, let's explore how the price of a diamond varies with its quality:

ggplot(diamonds, aes(x = price))+
  geom_freqpoly(aes(colour = cut), binwidth = 500)

  ## It's hard to see the difference in distribution because the overall counts differ so much:

ggplot(diamonds)+
  geom_bar(aes(x = cut))

  ## To make the comparison easier we need to swap what is displayed on the y-axis.
  ## Instead of displaying count, we'll display density, which is the count standardized so that the area under each frequency polygon is one:

ggplot(diamonds, aes(x = price, y = ..density..))+
  geom_freqpoly(aes(colour=cut), binwidth = 500)

  ## Another alternative to display the distribution of a continuous variable broken down by a categorical variable is the boxplot.
  ## On the boxplot we have the three lines (IQR 25, median (IQR 50) and IQR 75)
  ## These three lines give you a sense of the spread of the distribution and wheter or not the distribution is symmetric about the median or skewed to one side.
  ## Boxplots also has visual points that display observations that fall more than 1.5 the IQR from either edge of the box.
    ### These outlying points are unusual, so they are plotted individually.
  ## Boxplots also has a line (or whisker) that extends from each end of the box and goes to the farthest nonoutlier point in the distribution.

  ## Let's take a look at the distribution of price by cut using boxplot:
ggplot(diamonds, aes(x = cut, y = price))+
  geom_boxplot()

  ## Many categorical variables don't have an intrinsic order.
  ## So you might want to reorder them to make a more informative display.
  ## One way to do that is with the reorder() function.

  ## For example, take the class variable in the mpg dataset.
  ## You might be interested to know how highway mileages varies across classes:

ggplot(mpg, aes(x = class, y = hwy))+
  geom_boxplot()

  ## To make the trend easier to see, we can reorder class based on the median value of hwy:

ggplot(mpg)+
  geom_boxplot(aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ))

  ## If you have long variable names, you can flip it to 90º using coord_flip():

ggplot(mpg)+
  geom_boxplot(aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ))+
  coord_flip()

# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.
    
  ## 5.

  ## 6.


# TWO CATEGORICAL VARIABLES

  ## To visualize the covariation between categorical variables, you'll need to count the number of observations for each combination.
  ## One way to do that is to rely on the built-in geom_count():

ggplot(diamonds) +
  geom_count(aes(x = cut, y = color))

  ## The size of each circle in the plot displays how many observations occurred at each combination of values.
  ## Covariations will appear as a strong correlation between specific x values and specific y values.

  ## Another approach is to compute the count with dplyr:

diamonds %>%
  count(color, cut)

  ## Then visualize with geom_tile() and the fill aesthetic:

diamonds %>%
  count(color, cut) %>%
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

  ## If the categorical variables are unordered, you might want to use the seriation package to simultaneously reorder the rows and colums in order to more clearly reveal interesting patterns.
  ## For larger plots, you might want to try the d3heatmap or heatmaply packages, which create interactive plots.

# EXERCISES

  ## 1.

  ## 2.

  ## 3.


# TWO CONTINUOUS VARIABLES

  ## As we already seen, scatterplot (geom_point()) is a great way to visualize covariation between two continuous variables.
  ## You can see covariation as a pattern in the points.
  ## For example, you can see an exponential relationship between the carat size and price of a diamond:

ggplot(diamonds)+
  geom_point(aes(x = carat, y = price))

  ## Scatterplots become less useful as the size of your dataset grows,
  ## because points begin to overplot, and pile up into areas of uniform black (as in the preceding plot).
  ## You've already seen one way to fix the problem, using the alpha aesthetic to add transparecy:

ggplot(diamonds)+
  geom_point(aes(x = carat, y = price), alpha = 0.01)

  ## But using transparency can be challenging for very large datasets.
  ## Another solution is to use bin.
  ## Previously you used geom_histogram() and geom_freqpoly() to bin in one dimension.
  ## Now you'll learn how to use geom_bin2d() and geom_hex() to bin in two dimensions.

  ## geom_bin2d() and geom_hex() divide the coordinate plan into 2D bins and then use a fill color to display how many points fall into each bin.
  ## geom_bins2d() creates rectangular bins, geom_hex() creates hexagonal bins.
  ## You'll need to install the hexbin package to use geom_hex().
    ### install.packages("hexbin")

ggplot(smaller)+
  geom_bin2d(aes(x = carat, y = price))

ggplot(smaller)+
  geom_hex(aes(x = carat, y = price))

  ## Another options is to bin one continuous variable so it acts like a categorical variable.
  ## Then you can use one of the techniques for visualizing the combination of a categorical and a continuous variable that you learned about.
  ## For example, you could bin carat and then for each group, display a boxplot:

ggplot(smaller, aes(x = carat, y = price))+
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

  ## cut_width(x, width), as used here, divides x into bins of width width.
  ## By default, boxplots look roughly the same (apart from the number of outliers) regardless of how many observations there are,
  ## so it's difficult to tell that each boxplot summarizes a different number of points.
  ## One way to show that is to make the width of the boxplot proportional to the number of points with varwidth = TRUE.

  ## Another approach is to display approximately the same number of points in each bin.
  ## That's the job of cut_number():

ggplot(smaller, aes(x = carat, y = price))+
  geom_boxplot(aes(group = cut_number(carat, 20)))

# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.


# PATTERNS AND MODELS

  ## Patterns in your data provide clues about relationships.
  ## If a systematic relationship exists between two variables it will appear as a pattern in the data.
  ## If you spot a pattern, ask yourself:
    ### Could this pattern be due to coincidence (i.e., random chance)?
    ### How can you describe the relationship implied by the pattern?
    ### How strong is the relationship implied by the pattern?
    ### What other variables might affect the relationship?
    ### Does the relationship change if you look at individual subgroups of the data?

  ## A scatterplot of Old Faithful eruption lenghts versus the wait time between eruptions shows a pattern:
    ### longer wait times are associated with longer eruptions. 
  ## The scatterplot also displays the two clusters that we noticed earlier:
ggplot(faithful)+
  geom_point(aes(x = eruptions, y = waiting))


  ## Patterns provide one of the most useful tools for data scientists because they reveal covariation.
  ## If you think of variation as a phenomenon that creates uncertainty, covariation is a phenomenon that reduces it.
  ## If two variables covary, you can use the values of one variable to make better predictions about the values of the second.
  ## If the covariation is due to a casual relationship (a special case), then you can use the value of one variable to control the value of the second.

  ## Models are a tool for extracting patterns out of data.
  ## For example, consider the diamonds data.
  ## It's hard to understand the relationship between cut and price, because cut and carat, and carat and price, are tightly related.
  ## It's possible to use a model to remove the very strong relationship between price and carat so we can explore the subtleties that remain.
  ## The following code fits a model that predicts price from carat and then computes the residuals (the difference between the predicted value and the actual value).
  ## The residuals give us a view of the price of the diamond, once the effect of carat has been removed:

library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>%
  add_residuals(mod) %>%
  mutate(resid = exp(resid))

ggplot(diamonds2)+
  geom_point(aes(x = carat, y = resid))

  ## Once you've removed the strong relationship between carat and price, you can see what you expect in the relationship between cut and price
    ### relative to their size, better quality diamonds are more expensive:

ggplot(diamonds2)+
  geom_boxplot(aes(x = cut, y = resid))

  ## You'll learn how models, and the modelr package, work in the final part of the book, part IV.
  ## We're saving modeling for later because understanding what models are and how they work is easiest once you have the tools of data wrangling and programming in hand.

