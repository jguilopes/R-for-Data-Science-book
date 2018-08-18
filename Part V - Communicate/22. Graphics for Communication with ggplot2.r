### GRAPHICS FOR COMMUNICATION WITH GGPLOT2 ###

# This chapter focuses on the tools you need to create good graphics.
# We'll focus once again on ggplot2. We'll also use a little dplyr for data manipulation, and a few ggplot2 
  ## extension packages, including 'ggrepel' and 'viridis'.

library(tidyverse)
library(ggrepel)
library(viridis)

# LABEL


  ## The easiest place to start when turning an exploratory graphic into an expository graphic is with good labels.
  ## You add labels with th elabs() function.

  ## This example adds a plot title:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_smooth(se = F)+
  labs(title = paste("Full efficiency generally decreases with", "engine size"))

  ## The purpose of a plot title is to summarize the main finding.
  ## Avoid titles that just describe what the plot is, e.g., "A scatterplot of engine displacement vs fuel economy".

  ## If you need to add more text, there are two other useful labels that you can use in ggplot2:
  ## 'subtitle'
  ## 'caption'

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_smooth(se = F)+
  labs(title = paste("Full efficiency generally decreases with", "engine size"), 
       subtitle = paste("Two seaters (sports cars) an exception", "because of their light weight"),
       caption = "Data from fueleconomy.gov")


  ## You can also use labs() to replace the axis and legend titles.
  ## It's usually a good idea to replace short var names with more detailed descriptions, and to include the units:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_smooth(se = F)+
  labs(x = "Engine displacement (L)", 
       y = "Highway fuel economy (mpg)",
       colour = "Car type")


  ## It's possible to use mathematical equations instead of text strings.
  ## Just switch "" out for 'quote()' and read about the available options in '?plotmath' :

?plotmath


df <- tibble(x = runif(10), y = runif(10))

ggplot(df, aes(x, y))+
  geom_point()+
  labs(x = quote(sum(x[i] ^ 2, i == 1, n)),
       y = quote(alpha + beta + frac(delta, theta)))



# EXERCISES

  ## 1. 

  ## 2.

  ## 3.


# ANNOTATIONS

  ## In addition to labeling major components of your plot, it's often useful to label individual observations
    ### or groups of observations.
  ## The first tool you have at your disposal is geom_text().

  ## geom_text() is similar to geom_point(), but it has an additional aesthetic: label.
  ## This makes it possible to add textual labels to your plots.

  ## There are two possible sources of labels.
  ## First, you might have a tibble that provides labels.
  ## The following plot isn't terribly useful, but it illustrates a useful approach,
    ### pull out the most efficient car in each class with dplyr, and the label it on the plot:

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)


ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_text(aes(label = model), data = best_in_class)


  ## This is hard to read because the labels overlap with each other, and with the points.
  ## We can make things a little better by switching to geom_label(),
    ### which draws a rectangle behing the text.
  ## We also use the 'nudge_y' parameter to move the labels slightly above the corresponding points:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5)


  ## That helps a bit, but there are two labels practically on top of each other.
  ## Instead, we can use the 'ggrepel' package.
  ## This useful package will automatically adjust labelsso that they don't overlap:


ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_point(size = 3, shape = 1, data = best_in_class)+
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class)

      ### Note that I added a second layer of points to highlight the points that I've labeled.

  ## You can sometimes use the same idea to replace the legend with labels placed directly on the plot.
  ## It's not wonderful for this plot, but it isn't too bad.
    ### (theme(legend.position = "none")) turns the legend off

class_avg <- mpg %>%
  group_by(class) %>%
  summarize(displ = median(displ),
            hwy = median(hwy))

ggplot(mpg, aes(displ, hwy, color = class))+
  ggrepel::geom_label_repel(aes(label = class), data = class_avg, size = 6,
                            label.size = 0, segment.colour = NA)+
  geom_point()+
  theme(legend.position = "none")


  ## Alternatively, you might just want to add a single label to the plot,
    ### but you'll still need to create a data frame.
  ## Often, you want the label in the corner of the plot, so it's convenient to create a new data frame using
    ### summarize() to compute the maximum values of x and y:


label <- mpg %>%
  summarize(displ = max(displ),
            hwy = max(hwy),
            label = paste("Increasing engine size is \nrelated to", "decreasing fuel economy."))

ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")


  ## If you want to place the text exactly on the border of the plot, you can use '+Inf' and '-Inf' .
  ## Since we're no longer computing the positions from mpg, we can use tibble() to create the data frame:

label <- tibble(displ = Inf, hwy = Inf, 
                label = paste("Increasing engine size is \nrelated to", "decreasing fuel economy."))

ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  geom_text(aes(label = label), data = label, vjust = "top", hjust = "right")


  ## In these examples, I manually broke the label up into lines using "\n".
  ## Another approach is to use stringr::str_wrap() to automatically add line breaks, given the number of characters
    ## you want per line:

"Increasing engine size is related to decreasing fuel economy." %>%
  stringr::str_wrap(width = 40) %>%
  writeLines()


  ## In addition to geom_text(), you have many other geoms in ggplot2 available to help annotate your plot.
    ### Use 'geom_hline()" and 'geom_vline()' to add reference lines.
    ### Use 'geom_rect()" to draw a rectangle around points of interest.
    ### Use 'geom_segment()" with the 'arrow' argument to draw attention to a point with an arrow.
  
  ## The only limit is your imagination (and your patience with positioning annotation to be aesthetically pleasing).


# EXERCISES

  ## 1.

  ## 2. 

  ## 3.

  ## 4.

  ## 5.


# SCALES

  ## Scales control the mapping from data values to things that you can perceive.
  ## Normally, ggplot2 automatically adds scales for you. 
  ## For example, this plot:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))

  ## has default scales behind the scenes:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  scale_x_continuous()+
  scale_y_continuous()+
  scale_color_discrete()

  ## The naming scheme for scales is:
    ### 'scale_' followed by the name of the aesthetic, then '_' then the name of the scale.
  ## The default scales are named according to the type of a variable they align with:
    ### continuous, discrete, datetime, or date.
  ## But there are lots of nondefault scales, which you'll learn about next.

  ## You might want to override the default scales for two reasons:
    ### You might want to tweak some of the parameters of the default scale.
      #### This allows you to do things like change the breaks on the axes, or the key labels on the legend.
    ### You might want to replace the scale altogether, and use a completely different algorithm.
      #### Often you can do better than the default because you know more about the data.


# AXIS TICKS AND LEGEND KEYS

  ## There are two primary arguments that affect the appearence of the ticks on the axes and the keys on the legend:
    ### 'breaks' and 'labels'.

  ## 'breaks' controls the position of the ticks, or the values associated with the keys.
  ## 'labels' controls the text label associated with each tick/key.

  ## The most common use of 'breaks' is to override the default choice:

ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  scale_y_continuous(breaks = seq(15, 40, by = 5))

  ## You can use 'labels' in the same way, but you can set it to NULL to suppress the labels altogether.
  ## This is useful for maps, or for publishing plots where you can't share the absolute numbers.

ggplot(mpg, aes(displ, hwy))+
  geom_point()+
  scale_x_continuous(labels = NULL)+
  scale_y_continuous(labels = NULL)

  ## You can also use 'breaks' and 'labels' to control the appearance of legends.
  ## Collectively axes and legends are called GUIDES.
  ## Axes are used for the x and y aesthetics; legends are used for everything else.

  ## Another use of 'breaks' is when you have relatively few data points and want to highlight exactly where the
    ### observations occur.
  ## For example, take this plot that shows when each US president started and ended their term:

presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id)) +
  geom_point() + 
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(NULL, breaks = presidential$start, date_labels = "%y")

  ## Note that the specification of breaks and labels for date and datetime scales is a little different:
    ### 'date_labels' takes a format specification, in the same form as 'parse_datetime()'.
    ### 'date_breaks' takes a string like "2 days" or "1 month".


# LEGEND LAYOUT

  ## To control the overall position of the legend, you need to use a 'theme()' setting.
  ## We'll come back to themes at the end of the chapter, but in brief, they control the nondata parts of the plot.
  ## The theme setting 'legend.position' controls where the legend is drawn:

base <- ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))


base + theme(legend.position = "left")
base + theme(legend.position = "top")
base + theme(legend.position = "bottom")
base + theme(legend.position = "right") # the default


  ## You can also use legend.position = "none" to suppress the display of the legend altogether.

  ## To control the display of individual legends, use 'guides()' along with guide_legend() or guide_colorbar().
  ## The following example shows two important settings:
    ### controlling the number of rows the legend uses with 'nrow', 
    ### and overriding one of the aesthetics to make the points bigger.
  ## This is particularly useful if you have used a low 'alpha' to display many points on a plot:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_smooth(se = F)+
  theme(legend.position = "bottom")+
  guides(color = guide_legend(nrow = 1, override.aes = list(size = 4)))



# REPLACING A SCALE

  ## Instead of just tweaking the details a little, you can replace the scale altogether.
  ## There are two types of scales you're most likely to want to switch out:
    ### continuous position scales and color scales.
  
  ## Foe example, let's log-transform 'carat' and 'price' to see a precise relationship between them:

ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

ggplot(diamonds, aes(log10(carat), log10(price))) + 
  geom_bin2d()


  ## However, the disadvantage of this transformation is that the axes are now labeled with the transformed values,
  ## making it hard to interpret the plot.
  ## So instead of doing the transformation in the aesthetic mapping, we can instead do it with the scale.
  ## This is visually identical, except the axes are labeled on the original data scale:

ggplot(diamonds, aes(carat, price))+
  geom_bin2d()+
  scale_x_log10()+
  scale_y_log10()


  ## Another scale that is frequently customized is color.
  ## The default categorical scale picks colors that are evenly spaced around the color wheel.
  ## The following two plots look similar, but there is enough difference in the shades of red and green that the
    ### dots on the second plot can be distinguished even by people with red-green color blindness:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = drv))+
  scale_color_brewer(palette = "Set1")


  ## Don't forget simple techniques. If there are just a few colors, you can add a redundant shape mapping.
  ## This will also help ensure your plot is interpretable in black and white:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = drv, shape = drv))+
  scale_color_brewer(palette = "Set1")

  ## The ColorBrewer scales are documented online at http://colorbrewer2.org 
  ## and made available in R via the 'RColorBrewer' package.

  ## When you have a predefined mapping between values and colors, use 'scale_color_manual()'.
  ## For example, if we map presidential party to color, we want to use the standart mapping of 
    ### red for Republicans and blue for Democrats:

presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, color = party))+
  geom_point()+
  geom_segment(aes(xend = end, yend = id))+
  scale_colour_manual(values = c(Republican = "red", Democratic = "blue"))

  ## For continuous color, you can use the built-in 'scale_colour_gradient()' or 'scale_fill_gradient'.
  ## If you have a diverging scale, you can use 'scale_color_gradient2()'.
  ## That allows you to give, for example, positive and negative values differente colors.
  ## That's sometimes also useful if you want to distinguish points above or below the mean.

  ## Another option is 'scale_color_viridis()' provided by the 'viridis' package.
  ## It's a continuous analog of the categorical ColorBrewer scales.
  ## Here's an example from the viridis vignette:

df <- tibble(x = rnorm(10000), y = rnorm(10000))

ggplot(df, aes(x, y))+
  geom_hex()+
  coord_fixed()

ggplot(df, aes(x, y))+
  geom_hex()+
  viridis::scale_fill_viridis()+
  coord_fixed()

  ## Note that all color scales come in two varieties: 'scale_color_x()' and 'scale_fill_x()' 
    ### for the 'color' and 'fill' aesthetics, respectively.


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.



# ZOOMING

  ## There are three ways to control the plot limits:
    ### Adjusting what data is plotted;
    ### Setting the limits in each scale;
    ### Setting 'xlim' and 'ylim' in 'coord_cartesian()'.

  ## To zoom in on a region of the plot, it's generally best to use 'coord_cartesian()'. Compare the following plots:

ggplot(mpg, aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_smooth()+
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

mpg %>%
  filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy))+
  geom_point(aes(color = class))+
  geom_smooth()


  ## You can also set the limits on individual scales.
  ## Reducing the limits is basically equivalent to subsetting the data.
  ## It is generally more useful if you want expand the limits, for example, to match scales across different plots.
  ## For example, if we extract two classes of cars and plot them separately, it's difficult to compare the plots
    ### because all three scales (x, y and color) have different ranges:

suv <- mpg %>% filter(class == "suv")
compact <- mpg %>% filter(class == "compact")

ggplot(suv, aes(displ, hwy, color = drv))+
  geom_point()

ggplot(compact, aes(displ, hwy, color = drv))+
  geom_point()

  ## One way to overcome this problem is to share scales across multiple plots, 
    ### training the scales with the 'limits' of the full data:

x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

ggplot(suv, aes(displ, hwy, color = drv))+
  geom_point()+
  x_scale+
  y_scale+
  col_scale

ggplot(compact, aes(displ, hwy, color = drv))+
  geom_point()+
  x_scale+
  y_scale+
  col_scale

  ## In this particular case, you could have simply used faceting, but this technique is useful more generally if,
    ### for instance, you want to spread plots over multiple pages of a report.


# THEMES

  ## ggplot2 includes eight themes by default:
    ### theme_bw()
    ### theme_light()
    ### theme_classic()
    ### theme_linedraw()
    ### theme_dark()
    ### theme_minimal()
    ### theme_gray()
    ### theme_void()

  ## Many more are included in add-on packages like 'ggthemes'.

  ## It's also possible to control individuals components of each theme, 
    ### like the size and color of the font used for the y-axis.
  ## Read the ggplot2 book (http://ggplot2.org/book/)  for the full details.
  ## You can also create your own themes, if you are trying to match a particular corporate or journal style.



# SAVING YOUR PLOTS

  ## There are two main ways to get your plots out of R and into your final write-up:
    ### 'ggsave()' and 'knitr'. 
  ## 'ggsave()' will save the most recent plot to disk:

ggplot(mpg, aes(displ, hwy)) + geom_point()

ggsave("my-plot.pdf")

  ## Generally, however, I think you should be assembling your final reports using R Markdown, 
  ## so focus on the important code chunk options that you should know about for graphics.


# FIGURE SIZING

  ## The biggest challenge of graphics in R Markdown is getting your figures the right size and shape.
  ## There are five main options that control figure sizing:
    ### fig.width
    ### fig.height
    ### fig.asp
    ### out.width
    ### out.height

  ## Tips:

  ## Set fig.width = 6 (6") and fig.asp = 0.618 (the golden ratio) in the defaults.
    ### Then in individual chunks, only ajust fig.asp.

  ## Control the output size with out.width and set it to a percentage of the line width.
    ### Like, out.width = "70%" and fig.align = "center".

  ## To put multiple plots in a single row, set the out.width = "50%" for two plots, "33%" for three plots,
    ### or "25%' to four plots, and set fig.align = "default"


# LEARNING MORE

  ## A great resource is the ggplot2 extensions guide (http://www.ggplot2-exts.org/).
  ## This site lists many of the packages that extend ggplot2 with new geoms and scales.