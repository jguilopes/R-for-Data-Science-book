### FACTORS WITH forcats ###

  ## In R, factors are used to work with categorical variables, 
  ##variables that have a fixed and known set of possible values.
  ## They are also useful when you want to display character vectors in a non-alphabetic order.

  ## For more historical context on factors, I recommend 'stringsAsFactors: An unauthorized biography"
    ### http://bit.ly/stringsfactorsbio
  ## And 'strinsAsFactors = <sigh>
    ### http://bit.ly/stringsfactorsigh

  ## To work with factors, we'll use the 'forcats' package, which provides tools for dealing with categorical variable
    ### and it's an anagram of factors.
  ## It provides a wide range of helpers for working with factors.
  ## 'forcats' is not part of the core tidyverse, so we need to load it explicitly.

library(tidyverse)
library(forcats)


# CREATING FACTORS

  ## Imagine that you have a variable that records month:

x1 <- c("Dec", "Apr", "Jan", "Mar")

  ## Using a string to record this variable has two problems:
    ### 1. There are only twelve possible months, and there's nothing saving you from typos:
x2 <- c("Dec", "Apr", "Jam", "Mar")

    ### 2. It doesn't sort in a useful way:
sort(x1)

  ## You can fix both of these problems with a factor.
  ## To create a factor you must start by creating a list of the valid levels:

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

  ## Now you can create a factor:

y1 <- factor(x1, levels = month_levels)
y1

  ## And any values not in the set will be silently converted to NA:

y2 <- factor(x2, levels = month_levels)
y2


  ## If you want an error, you can use readr::parse_factor():

y2 <- parse_factor(x2, levels = month_levels)

  ## If you omit the levels, they'll be taken from the data in alphabetical order:

factor(x1)

  ## Sometimes you'd prefer that the order of the levels match the order of the first appearence in the data.
  ## You can do that when creating the factor by setting levels to unique(),
  ## or after the fact, with fct_inorder():

f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>%
  factor() %>%
  fct_inorder()

  ## If you ever need to access the set of valid levels directly, you can do so with levels():

levels(f2)


# GENERAL SOCIAL SURVEY

  ## For the rest of this chapter, we're going to focus on forcats::gss_cat.
  ## It's a sample of data from the General Social Survey
  ## The survey has thousands of questions, so in gss_cat I've selected a handful that will illustrate some 
  ## common challenges you'll encounter when working with factors:

head(forcats::gss_cat)
?gss_cat

  ## You can see the levels of a factor with count() or with a bar chart:

gss_cat %>%
  count(race)

ggplot(gss_cat, aes(x = race))+
  geom_bar()


  ## By default, ggplot2 will drop levels that don't have any values.
  ## You can force them to display with:

ggplot(gss_cat, aes(race))+
  geom_bar()+
  scale_x_discrete(drop = FALSE)

  ## When working with factors, the two most common operations are changing the order of the levels,
  ## and changing the values of the levels. Those operations are described in the following sections.


# EXERCISES

  ## 1. 

  ## 2. 

  ## 3.


# MODIFYING FACTOR ORDER

  ## It's often useful to change the order of the factor levels in a visualization.
  ## For example, imagine you want to explore the average number of hours spent watching TV per day acrrss religions:

relig <- gss_cat %>%
  group_by(relig) %>%
  summarize(age = mean(age, na.rm = TRUE), tvhours = mean(tvhours, na.rm = TRUE), n = n())

ggplot(relig, aes(tvhours, relig)) + geom_point()

  ## It's difficult to interpret this plot because there's no overall pattern.
  ## We can improve it by reordering the levels of relig using fct_reorder().
  ## fct_reorder() takes three arguments:
    ### f, the factor whose levels you want to modify.
    ### x, a numeric vector that you want to use to reorder the levels.
    ### Optionally, fun, a function that's used if there're multiple values of x for each value of f.
      #### The default value is median

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours)))+
  geom_point()


  ## As you start making more complicated transformations.
  ## I'd recommend moving them out of aes() and into a separate mutate() step.
  ## For example, you could rewrite the preceding plot as:

relig %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig))+
  geom_point()

  ## What if we create a similar plot looking at how average age varies across reported income level?

rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarize( age = mean(age, na.rm = TRUE), tvhours = mean(tvhours, na.rm = TRUE), n = n())

ggplot(rincome, aes(age, fct_reorder(rincome, age))) + geom_point()

  ## Here, arbitrarily reordering the levels isn't a good idea.
  ## That's because rincome already has a principled order that we shouldn't mess with.
  ## Reserve fct_reorder() for factors whose levels are arbitrarily ordered.

  ## However, it does make sense to pull "Not applicable" to the front with the other special levels.
  ## You can use fct_relevel().
  ## It takes a factor, f, and then any number of levels that you want to move to the front of the line:

ggplot(rincome, aes(age, fct_relevel(rincome, "Not applicable")))+
  geom_point()

  ## Another type of reordering is useful when you're coloring the lines on a plot.
  ## fct_reorder2() reorders the factor by the y values associated with the largest x values.
  ## This makes the plot easier to read because the line colors line up with the legend:

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  group_by(age, marital) %>%
  count() %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, color = marital))+
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, color = fct_reorder2(marital, age, prop))) +
  geom_line()+
  labs(color = "marital")

  ## Finally, for bar plots, you can use fct_infreq() to order levels in increasing frequency:
  ## this is the simplest type of reordering because it doesn't need any extra variables.
  ## You may want to combine with fct_rev():

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital))+
  geom_bar()


# EXERCISES

  ## 1. 

  ## 2.

  ## 3.


# MODIFYING FACTOR LEVELS

  ## More powerful than changing the orders of the levels is changing their values.
  ## This allows you to clarify labels for pubblication, and collapse levels for high-levels displays.

  ## The most general and powerful tool is fct_recode(). 
  ## It allows you to recode, or change, the value of each level.
  ## For example, take gss_cat$partyid:

gss_cat %>%
  count(partyid)

  ## The level are terse and inconsistent. Let's tweak them to be longer and use a parallel construction:

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind, near rep",
                              "Independent, near dem" = "Ind, near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat")) %>%
  count(partyid)

  ## fct_recode() will leave levels that aren't explicitly mentioned as is, and will warn you if you accidentally
  ## refer to a level that doesn't exist.

  ## To combine groups, you can assign multiple old levels to the same new level:

gss_cat %>%
  mutate(partyid = fct_recode(partyid, 
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind, near rep",
                              "Independent, near dem" = "Ind, near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat",
                              "Other" = "No answer",
                              "Other" = "Don't know",
                              "Other" = "Other party")) %>%
  count(partyid)

  ## You must use this technique with care: if you group together categories that are truly different you will end up
  ## with misleading results.

  ## If you want to collapse a lot of levels, fct_collapse() is a useful variant of fct_recode().
  ## For each new variable, you can provide a vector of old levels:

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong Republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind, near dem"),
                                dem = c("Not str democrat", "Strong democrat"))) %>%
  count(partyid)

  ## Sometimes you just want to lump together all the small groups to make a plot or table simples.
  ## That's the job of fct_lump():

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

  ## The default behavior is to progressively lump together the smallest groups, ensuring that the aggregate is 
  ## still the smallest group.
  ## In this case it's not very helpful: it is true that the majority of Americans in this survey are Protestant,
  ## but we've probably overcollapsed.

  ## Instead, we can use the n parameter to specify how many groups (excluding other) we want to keep:

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)

# EXERCISES

  ## 1.

  ## 2.