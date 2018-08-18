# INTRODUCTION
  ## ggplot2 implements the Grammar of Graphics, a coherent system for describing and building graphs.
  ## with ggplot2, you can do more faster by learning one system and applying it in many places.
  ## to learn more about the theoretical underpinnings of ggplot2, read "A Layered Grammar of Graphics" (http://vita.had.co.nz/papers/layered-grammar.pdf)

# loading the tidyverse
#install.packages("tidyverse")

library("tidyverse")

# to be explicit about where a function or a dataset comes from, use the form "package::function()"

# FIRST STEPS
  ## let's use or first graph to answer a question: do cars with big engines use more fuel than cars with small engines?
  ## what does the relationship between engine size and fuel efficiency look like? Is it positive? Negative? Linear? Nonlinear?

# THE MPG DATA FRAME
  ## a data frame is a rectangular collection of variables(in the columns) and observations (in the rows)
  ## mpg contains observations on 38 models of cars

ggplot2::mpg

  ## among the variables in mpg, are:
  ## "displ": a car's engine size, in liters; 
  ## "hwy": a car's fuel efficiency on the highway, in miles per gallon (mpg)
  ## a car with a low fuel efficiency consumes more fuel than a car with a high FE when they travel the same distance

  ## to learn more about mpg, run:
?mpg

# CREATING A GGPLOT
  ## let's plot mpg, putting "displ" on the x-axis and "hwy" on the y-axis:

ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))

  ## the plot shows a negative relationship between engine size (displ) and fuel efficiency (hwy).
  ## in other words, cars with big engines use more fuel.

  ## with ggplot2, you begin a plot with the function ggplot().
  ## ggplot() creats a coordinate system that you can add layers to.
  ## the first argument of ggplot() is the dataset to use in the graph, for example ggplot(data=mpg).

  ## you complete your graph by adding one or more layers to ggplot().
  ## the function geom_point() adds a layers of points to your plot, which creates a scatterplot.
  ## ggplot2 comes with many geom functions that each add a different type of layer to a plot.

  ## each geom function in ggplot2 takes a mapping argument.
  ## this defines how variables in your dataset are mapped to visual properties.
  ## the mapping argument is always paired with aes().
  ## the x and y arguments specify which variables to map to the x and y-axes.


# A GRAPHING TEMPLATE
  ## to make a graph, replace the bracketed sections in the following code with a dataset, a geom function, or a collection of mappings:

  ## ggplot(data = <DATA> ) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

  ## the rest of this chapter will show how to complete and extend this template to make different types of graphs.
  ## we will begin with the <MAPPING> component.

# EXERCISES
  ## 1. run ggplot(data=mpg). what do you see?
ggplot(data=mpg)
    ### I don't see anything. I specified my dataset but not the geom function either the variables to be plotted

  ## 2. how many rows are in mtcars? how many columns?
mpg
    ### there are 234 rows and 11 columns in the mtcars dataset.

  ## 3. what does the drv variable describe?
?mpg
    ### the drv variable describes the type of "wheels": front-wheel, rear-wheel or 4wd.

  ## 4. make a scatterplot of hwy versus cyl
ggplot(data=mpg)+
  geom_point(mapping = aes(x=hwy, y=cyl))

  ## 5. what happens if you make a scatterplot of class verus drv? why is the plot not useful?
ggplot(data=mpg)+
  geom_point(mapping = aes(x=class, y=drv))
    ### it doesn't show any correlation, because the class is a qualitative variable. the plot is not useful because just shows the types of drv each class has.

# AESTHETIC MAPPINGS
  ## You can add a third variable, like mpg$class, to a two-dimensional scatterplot by mapping it to an aesthetic.
  ## An aesthetic is a visual property of the objects in your plot.
  ## Aesthetics include things like the size, the shape or the colour of your points.
  ## You can convey (carry to a place) information about your data by mapping the aesthetics in your plot to the variables in your dataset.

  ## for example, you can map the colours of your points to the "class" variable to reveal the class of each car:
ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour=class))

  ## to map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable inside aes()
  ## ggplot2 will automatically assign (allocate/attribute) a unique leve of the aesthetic (like colour) to each unique value of the variable, a process known as scaling.
  ## ggplot2 will also add a legend that explains which levels correspond to which values
  
  ## Types of aesthetics and its arguments (at least for scatterplots):
    ### by colour:                          colour=... (or color)
    ### by size of the points:              size=...
    ### by the transparency of the points:  alpha=...
    ### by the shape of the points:         shape=...  (maximum 6 shapes)

  ## the aes() function gathers together each of the aesthetic mappings used by a layer and passes them to the layer's mapping argument.
  ## Once you map an aesthetic, ggplot2 takes care of the rest.
  ## You can also se the aesthetic properties of your geom manually. 
  ## For example, make all the points in the plot blue (just changing the appearance of the plot):
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy), colour="blue")

  ## to set an aesthetic manually, set it by name as an argument of your geom function, i.e., it goes outside of aes()
  ## You'll need to pick a value that makes sense for that aesthetic:
    ### the name of a colour as a character string
    ### the size of a point in mm
    ### the shape of a point as a number (it goes from 0 to 24)
      #### (0-14) to hollow shapes; (15-20) to solid shapes; (21-24) to filled shapes


# EXERCISES
  ## 1. What's gone wrong with this code? Why are the points not blue?
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour="blue"))
    ### the points are not blue because the aesthetic should be outside the aes(). the aesthetic is an argument for the geom function.

  ## 2. Which variables in mpg are categorical? Which are continuos? How can you see this information when you run mpg?
?mpg
summary(mpg)
    ### is possible to check the types of the variables by running the dataset or summary(dataset)
    ### categoricals: manufacturer, model, trans, drv, fl, class
    ### continuous: displ, year, cyl, cty, hwy

  ## 3. Map a continuous variable to color, size and shape. How do these aesthetics behave differently for categorical versus continuous variables?
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour=year))
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, size=year))
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, shape=year))
      ### a continuous variable can not be mapped to shape

  ## 4. What happens if you map the same variable to multiple aesthetics?
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour=year, size=year))
    ### both of the aesthetics appears, but doesn't looks correct

  ## 5. What does the stroke aesthetic do? What shapes does it work with?
?geom_point
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=cty, stroke=year))
    ### ??

  ## 6. What happens if you map an aesthetic to something other than a variable name, like aes(color=displ<5) ?
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy, colour=displ<5))
    ### VERY INTERESTING! the aesthetics categorize the variable by the condition you made!


# FACETS
  ## Another way to add additional variables is to split your plot into facets, subplots that each display one subset of the data
  ## this is very useful for categorical variables.
  ## To facet your plot by a single variable, use the function facet_wrap()
  ## the first argument should be a formula (a data structure in R, not a synonym for "equation"), which you create with ~ followed by a variable name.
  ## the variable that you pass to facet_wrap should be discrete:

ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_wrap(~ class, nrow=2)

  ## To facet your plot on the combination of two variables, use the function facet_grid()
  ## The first argument of facet_grid() is also a formula, this formula should contain two variables names separated by a ~

ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(drv ~ cyl)

  ## If you prefer to not facet in the rows or columns dimension, use a . instead of a variable name

ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(. ~ cyl)


# EXERCISES
  ## 1. What happens if you facet on a continuous variable?#
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_wrap(~ cty)
    ### The plot becomes too large or impossible to reach

  ## 2. What do the empty cells in a plot with facet_grid(drv~cyl) mean? How do they relate to this plot?
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(drv~cyl)
    ### It means there is no observations for those specific conditions (ex: drv=4 and cyl=r)

  ## 3. What plot does the following code make? What does . do?
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(drv ~ .)

ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(. ~ cyl)
    ### they split the plot into one single variable, without using rows/columns dimensions.

  ## 4. Take the first faceted plot in this section.
ggplot(mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_wrap(~class, nrow=2)
  ## What are the advantages to using faceting instead of the color aesthetic?
    ### Is better to see how is the behaviour of each category in particular
  ## What are the disadvantages?
    ### We can't see the whole data plotted in one single plot
  ## How might the balance change if you had a larger dataset?
    ### with a large dataset, the faceting can be useful for comparison use between the categories, but at the same time, could have too many categories and the plot would be confusing.

  ## 5. Read ?facet_wrap
?facet_wrap
  ## What does nrow and ncol do?
    ### those arguments are made to set how many rows/columns the plots are divided
  ## What other options control the layout of the individual panels?
    ### ? 
  ## Why doesn't facet_grid() have nrow and ncol?
    ### because facet_grid shows a rectangular display

  ## 6. When using facet_grid() you should usually put the variable with more unique levels in the columns? Why?
    ### I think is better to have more columns than rows when we're looking to a plot.


# GEOMETRIC OBJECTS
  ## A geom is the geometrical object that a plot uses to represent data. 
  ## for example, bar charts use bar geoms, line charts use line geoms, ecc. Scatterplots break the trend; they use the point geom.
  ## As we saw, we can use different geoms to plot the same data
  ## To change the geom in your plot, change the geom function that you add to ggplot()
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(x=displ, y=hwy))
  ## Every geom function in ggplot2 takes a mapping argument. However, not every aesthetic works with every geom
  ## For example, for geom_point you can set the shape of the points, while on the geom_smooth you set the linetype of the line
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y=hwy, linetype=drv, colour=drv))

  ## ggplot2 provides over 30 geoms, and extension packages provide even more (see https://www.ggplot2-exts.org for a sampling)
  ## To get a comprehensive overview is the ggplot2 cheatsheet: http://rstudio.com/cheatsheets
  ## to learn more about any single geom, use help ?geom_typeofgeom

  ## many geoms, like geom_smooth, use a single geometric object to display multiple rows of data.
  ## for these geoms, you can set the GROUP aesthetic to a categorical variable to draw multiple objects.
  ## the group aesthetic by itself does not add a legend or distinguishing features to the geoms
ggplot(mpg)+
  geom_smooth(mapping=aes(x=displ, y= hwy, group=drv))

  ## To display multiple geoms in the same plot, add multiple geom functions to ggplot():
ggplot(mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))+
  geom_smooth(mapping=aes(x=displ, y= hwy))
  ## this, however, introduces some duplication in our code.
  ## you can avoid the type of repetition by passing a set of mappings as an argument to ggplot()
  ## ggplot2 will treat these mappings as global mappings that apply to each geom in the graph.
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point()+
  geom_smooth()
  ## if you place mappings in a geom function, ggplot2 will treat them as local mappings for the layer
  ## it will use these mappings to extend or overwrite the global mappings for that layer only.
  ## this makes it possible to display different aesthetics in different layers:
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(color=class))+
  geom_smooth()
  ## above, the colouring layer was applied only for the scatterplot

  ## you can use the same idea to specify different data for each layer.
  ## below, our smooth line displays just a subset of the mpg dataset, the subcompact cars
  ## the local data argument in geom_smooth() overrides the global data argument in ggplot() for that layer only:
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(color=class))+
  geom_smooth(data=filter(mpg, class == "subcompact"), se = FALSE)

  ## We'll learn how filter() works in the next chapter; for now, just know that this command selects only the subcompact cars.


# EXERCISES
  ## 1. 
    ### A histogram chart
  ## 2. 
ggplot(data=mpg, mapping=aes(x=displ, y=hwy, color=drv))+
  geom_point()+
  geom_smooth(se = F)

  ## 3. 
    ### show.legend=FALSE removes the legend on the right side of the chart. If you remove it, the legend must appears.

  ## 4. 
    ### shows that "area" around the line

  ## 5. 
    ### They look the same, because the aesthetic arguments are the same. The difference is that on the first one, the arguments are global, while the second graph, the arguments are local for each geom.

  ## 6.
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point()+
  geom_smooth(se=FALSE)

ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point()+
  geom_smooth(mapping=aes(group=drv),se=FALSE)

ggplot(data=mpg, mapping=aes(x=displ, y=hwy, group=drv, colour=drv))+
  geom_point()+
  geom_smooth(se=FALSE)

ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(group=drv, colour=drv))+
  geom_smooth(se=FALSE)

ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(group=drv, colour=drv))+
  geom_smooth(mapping=aes(linetype=drv),se=FALSE)

ggplot(data=mpg, mapping=aes(x=displ, y=hwy, colour=drv))+
  geom_point()

# STATISTICAL TRANSFORMATIONS
  ## dataset:
diamonds
summary(diamonds)

  ## Let's take a look at the bar chart with the function geom_bar()

ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut))
  ## on the x-axis we have our variable "cut", but on the y-axis we have "count", that is not a variable!
  ## where does "count" come from? because some graphs, like bar charts, automatically calculate new values to a plot.

  ## Role of the graphs:
    ### Bar charts, histograms, and frequency polygons bin your data and then plot bin counts, the number of points that fall in each bin.
    ### Smoothers fit a model to your data and then plot predictions from the model.
    ### Boxplots compute a robust summary of the distribution and display a specially formatted box.

  ## The algorithm used to calculate new values for a graph is called a stat, short for statistical transformation.
  ## You can learn which stat a geom uses by inspecting the default value for the stat argument.
  ## for example, ?geom_bar shows the default value for stat is "count",  which meand that geom_bar() uses stat_count().
?geom_bar ## you can also nothe that if you scroll down, you can find a section called "computed variables". that tells that it computes two new variables: count and prop.
?stat_count
  
  ## you can generally use geoms and stats interchangeably:
ggplot(data=diamonds)+
  stat_count(mapping=aes(x=cut))

  ## This works because every geom has a default stat, and every stat has a default geom.
  ## So you can use geoms without worrying about the underlying statistical transformation.
  ## But there are three reasons you might need to use a stat explicitly:

    ### 1. You might want to override the default stat.
    ### for example, change the stat of geom_bar from count to identity
demo <- tribble(~a, ~b, "bar_1", 20, "bar_2", 30, "bar_3", 40)   ### soon we'll see the "tribble()" function
ggplot(data=demo)+
  geom_bar(mapping = aes(x=a, y=b), stat="identity")

    ### 2. You might want to override the default mapping from transformed variables to aesthetics.
    ### for example, you might want to display a bar chart of proportion, rather than count:
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, y= ..prop.., group=1)) ### to find the variables computed by the stat, look for the help section titled "Computed variables".

    ### 3. You might want to draw greater attention to the statistical transformation in your code.
    ### for example, use stat_summary(), which summarizes the y values for each unique x value, to draw attention to the summary that you're computing:

ggplot(data=diamonds)+
  stat_summary(mapping = aes(x=cut, y=depth), fun.ymin = min, fun.ymax = max, fun.y=median)

  ## ggplot2 provides over 20 stats for you to use.
  ## each stat is a function, so you can get help in the usual way, e.g., ?stat_bin
  ## to see a complete list of stats, try the ggplot2 cheatsheet.


# EXERCISES

  ## 1. 
?stat_summary
    ### ?

  ## 2. 
?geom_col
ggplot(diamonds)+
  geom_col(mapping = aes(x=cut, y=depth))
    ### I think that geom_col uses as y-axis, the frequency of an another variable.

  ## 3. 
    ### ?

  ## 4. 
    ### ?

  ## 5. 
    ### 


# POSITION ADJUSTMENTS

  ## There's one more piece of magic associated with bar charts.
  ## You can color a bar chart using either the color aesthetic, or more usefully, fill.
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, color=cut))
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, fill=cut))

  ## If you map the fill aesthetics to another variable, the bars are automatically stacked:
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, fill=clarity)) ## each colored rectangle represents a combination of cut and clarity

  ## the stacking is perfomed automatically by the "position adjustment" specified by the "position" argument
  ## If you don't want a stacked bar chart, you can use one of three options: "identity", "dodge" or "fill":
    ### position = "identity" will place each object exactly where it falls in the context of the graph
ggplot(data=diamonds, mapping = aes(x=cut, fill=clarity))+
  geom_bar(position="identity", alpha=0.20) ### the alpha argument makes the bars slightly transparent

ggplot(data=diamonds, mapping=aes(x=cut, color=clarity))+
  geom_bar(position="identity", fill=NA) ### the fill argument makes the bars "empty"

      #### the identity position is more useful for 2d geoms, like points, where it is the default.

    ### position = "fill" works like stacking, but makes each set of stacked bars the same height
    ### this makes it easier to compare proportions across groups
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, fill=clarity), position="fill")

    ### position = "dodge" places overlapping objects beside one another. 
    ### this makes it easier to compare individual values
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, fill=clarity), position="dodge")


  ## There's one other type of adjustment that can be very useful for scatterplots.
  ## Let's recall our first scatterplot:
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))
  ## this plot displays only 126 points, even though there are 234 observations in the dataset
  ## this happens to avoid the overplotting problem (when the values of the variables are rounded so the points appear on a grid and many points overlap each other)
  ## but this arrangement makes it hard to see where the mass of the data is
    ### are the data points spread equally throughout the graph, or is there one special combination of the variables that contais 109 values?

  ## you can avoid this gridding by setting the position adjustment to "jitter"
  ## position="jitter" adds a small amount of random noise to each point.
  ## this spreads the points out because no two points are likely to receive the same amount of random noise.

ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy), position="jitter")
  ## adding randomness makes your graph less accurate at small scales, but makes your graph more revealing at large scales.

  ## to learn more about a position adjustment:
?position_dodge
?position_fill
?position_identity
?position_jitter
?position_stack

# EXERCISES

  ## 1.
    ggplot(data=mpg, mapping=aes(x=cty, y=hwy))+
      geom_point()
    ### It is not very clear. adding the "jitter" position may helps:
    ggplot(data=mpg, mapping=aes(x=cty, y=hwy))+
      geom_point(position="jitter")

  ## 2.
?geom_jitter()
    ### width and height

  ## 3. 
    ### ?
    
  ## 4.
ggplot(data=mpg, mapping=aes(x=class, y=displ))+
  geom_boxplot()
?geom_boxplot    
    ### ?


# COORDINATE SYSTEMS
  ## The default coordinate system is the Cartesian coordinate system, where x and y position act independently to find the location of each point.
  ## There are other coordinate systems that are occasionally helpful:

  ## coord_flip() switches the x and y axes.
  ## this is useful, for example, if you want horizontal bloxplots.
  ## it's also useful for long labels (those who overlaps on the x-axis)

ggplot(data=mpg, mapping=aes(x=class, y=displ))+
  geom_boxplot()

ggplot(data=mpg, mapping=aes(x=class, y=displ))+
  geom_boxplot()+
  coord_flip()

ggplot(data=diamonds, mapping=aes(x=cut))+
  geom_bar()+
  coord_flip()

  ## coord_quickmap() sets the aspect ratio correctly for maps
  ## this is very important if you're plotting spatial data with ggplot2
install.packages("maps")
library(maps)
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group=group))+
  geom_polygon(fill="white", color="black")

ggplot(nz, aes(long, lat, group=group))+
  geom_polygon(fill="white", color="black")+
  coord_quickmap()

  ## coord_polar() uses polar coordinates.
  ## It reveals an interesting connection between a bar chart and a Coxcomb chart:

bar <- ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, fill=cut), show.legend = F, width=1)+
  theme(aspect.ratio = 1)+
  labs(x=NULL, y=NULL)

bar
bar + coord_flip()
bar + coord_polar()

# EXERCISES

  ## 1.
ggplot(data=diamonds, mapping=aes(x=cut, fill=cut))+
  geom_bar()+
  coord_polar()
    ### ???

  ## 2.
?labs()
    ### it modifies axis, legend and plot labels

  ## 3.
    ### ?

  ## 4. 
    ### ?


# THE LAYERED GRAMMAR OF GRAPHICS
  ## Below there's a code template which carries the foundations to make any type of plot in ggplot2:

## ggplot(data=<DATA>)+
##  <GEOM_FUNCTION>(mapping=aes(<MAPPINGS>), stat = <STAT>, position = <POSITION>)+
##  <COORDINATE_FUNCTION)+
##  <FACET_FUNCTION>

  ## In practice, you rarely need to supply all these seven parameters
  ## but the data, the mappings and the geom function are always needed.