### DATES AND TIMES WITH lubridate ###

  ## This chapter will show you how to work with dates and times in R.
  ## We'll focus n the 'lubridate' package, which makes it easier to work with dates and times in R.
  ## 'lubridate' is not part of the core tidyverse.
  ## We'll also need 'nycflights13' for practice data.

library(tidyverse)
library(lubridate)
library(nycflights13)


# CREATING DATE/TIMES

  ## There are three types of date/time data that refer to an instant in time:
  
  ## A date. Tibbles print this as <date>
  ## A time within a day. Tibbles print this as <time>
  ## A date-time is a date plus a time: it uniquely identifies an instant in time. Tibbles print this as <dttm>.
    ### Elsewhere in T these are called POSIXct.

  ## In this chapter we are only going to focus on dates and date-times as R doesn't have a native class for storing times.
  ## If you need one, you can use the 'hms' package.

  ## Date-times are substantially more complicated because of the need to handle time zones.

  ## To get the current date or date-time you can use today() or now():

today()

now()

  ## Otherwise, there are three ways you're likely to create a date/time:

    ### From a string;
    ### From individual date-time components;
    ### From an existing date/time object.

  ## They work as follows:


# FROM STRINGS

  ## Date/time data often comes as strings.
  ## You've seen one approach to parsing strings into date-times.
  ## Another approach is to use the helpers provided by lubridate.
  ## They automatically work out the format once you specify the order of the component.
  ## To use them, identify the order in which year, month, and day appear in your dates,
  ## then arrange "y", "m", and "d" in the same order.
  ## That gives you the name of the lubridate function that will parse your date.
  ## For example:

ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

  ## These functions also take unquoted numbers.
  ## This is the most concise way to create a single date/time object, 
  ## as you might need when filtering date/time data. 
  ## ymd() is short and unambiguous:

ymd(20170131)

  ## ymd() and friends create dates. 
  ## To create a date-time, add an underscore and one or more of "h", "m", and "s" to the name of the parsing function:

ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

  ## You can also force the creation of a date-time from a date by supplying a time zone:

ymd(20170131, tz = "UTC")



# FROM INDIVIDUAL COMPONENTS

  ## Instead of a single string, 
    ### sometimes you'll have the individual components of the date-time spread across multiple columns.
  ## This is what we have in the flights data:

flights %>%
  select(year, month, day, hour, minute)

  ## To create a date/time from this sort of input, use make_date() for dates,
    ### or make_datetime() for date-times:

flights %>%
  select(year, month, day, hour, minute)%>%
  mutate(departure = make_datetime(year, month, day, hour, minute))

  ## Let's do the same thing for each of the four time columns in 'flights'.
  ## The times are represented in a slightly odd format, so we use modulus arithmetic to pull out the hour and minutes.
  ## Once I've created the date-time variables, I focus in on the variables we'll explore in the rest of the chapter:

make_datetime_100 <- function(year, month, day, time){
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt


  ## With this data, I can visualize the distribution of departure times across the year:

flights_dt %>%
  ggplot(aes(dep_time))+
  geom_freqpoly(binwidth = 86400) #86400 seconds = 1 day

  ## Or within a single day:

flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot(aes(dep_time))+
  geom_freqpoly(binwidth = 600) # 600s = 10 minutes

  ## Note that when you use date-times in a numeric context (like in a histogram), 1 means 1 second, 
  ## so a binwidth of 86400 means one day. For dates, 1 means 1 day.


# FROM OTHER TYPES

  ## You may want to switch between a date-time and a date.
  ## That's the job of as_datetime() and as_date():

as_datetime(today())
as_date(now())

  ## Sometimes you'll get date/times as numeric offsets from the "Unix Epoch", 1970-01-01.
  ## If the offset is in seconds, use as_datetime();
  ## is it's in days, use as_date():

as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)


# EXERCISES

  ## 1. 

  ## 2. 

  ## 3.


# DATE-TIME COMPONENTS

  ## Now let's explore what you can do with date-time data.
  ## This section will focus on the accessor functions that let you get and set individual components.
  ## The next section will look at how arithmetic works with date-times.

# GETTING COMPONENTS

  ## You can pull out individual parts of the date with the accessor functions:
  ## year(), month(), mday() (day of the month), yday() (day of the year), wday() (day of the week), hour(),
  ## minute(), and second().

datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)
month(datetime)
mday(datetime)
yday(datetime)
wday(datetime)

  ## For month() and wday() you can set label = TRUE to return the abbreviated name of the month or day of the week.
  ## Set abbr = FALSE to return the full name:

month(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)

  ## We can use wday() to see that more flights depart during the week than on the weekend:

flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>%
  ggplot(aes(x = wday))+
  geom_bar()

  ## There's an interesting pattern if we look at the average departure delay by minute within the hour.
  ## It looks like flights leaving in minutes 20-30 and 50-60 have much lower delays than the rest of the hour!

flights_dt %>%
  mutate(minute = minute(dep_time)) %>%
  group_by(minute) %>%
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>%
  ggplot(aes(minute, avg_delay))+
  geom_line()

  ## Interestingly, if we look at the scheduled departure time we don't see such a strong pattern:

sched_dep <- flights_dt %>%
  mutate(minute = minute(sched_dep_time)) %>%
  group_by(minute) %>%
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE), n = n())

ggplot(sched_dep, aes(minute, avg_delay))+
  geom_line()

  ## So why do we see that pattern with the actual departure times?
  ## Well, like much data collected by humans, there's a strong bias toward flights leaving at "nice" departure times.
  ## Always be alert for this sort of pattern whenever you work with data that involves human judgment!

ggplot(sched_dep, aes(minute, n))+
  geom_line()


# ROUNDING

  ## An alternative  approach to plotting individual components is to round the date to a nearby unit of time, 
  ## with floor_date(), round_date(), and ceiling_date(). 
  ## Each ceiling_date() function takes a vector of dates to adjust and then the name of the unit to round down (floor),
  ## round up (ceiling), or round to.
  ## This, for example, allows up to plot the number of flights per week:

flights_dt %>%
  count(week = floor_date(dep_time, "week")) %>%
  ggplot(aes(week, n)) +
  geom_line()

  ## Computing the difference between a rounded and unrounded date can be particularly useful.


# SETTING COMPONENTS

  ## You can also use each accessor function to set the components of a date/time:

(datetime <- ymd_hms("2016-07-08 12:34:56"))

year(datetime) <- 2020
month(datetime) <- 01
hour(datetime) <- hour(datetime) + 1

  ## Alternatively, rather than modifying in place, you can create a new date-time with update().
  ## This also allows you to set multiple values at once:

update(datetime, year = 2020, month = 2, mday = 2, hour = 2)

  ## If values are too big, they will roll over:

ymd("2015-02-01") %>%
  update(mday = 30)

ymd("2015-02-02") %>%
  update(hour = 400)

  ## You can use update() to show the distribution of flights across the course of the day for every day of the year:

flights_dt %>%
  mutate(dep_hour = update(dep_time, yday = 1)) %>%
  ggplot(aes(dep_hour))+
  geom_freqpoly(binwidth = 300)

  ## Setting larger components of a date to a constant is a powerful technique that allows you to explore patterns
  ## in the smaller components.


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.

  ## 6.

  ## 7.


# TIME SPANS

  ## Next you'll learn about how arithmetic with dates works, including subtraction, addition, and division.
  ## Along the way, you'll learn about three important clases that represent time spans:

  ## Durations, which represent an exact number of seconds.
  ## Periods, which represent human units like weeks and months.
  ## Intervals, which represent a starting and ending point.

# DURATIONS

  ## In R, when you subtract two dates, you get a difftime object:

h_age <- today() - ymd(19911130)
h_age

  ## A difftime class object records a time span of seconds, minutes, hours, days, or weeks.
  ## This ambiguity can make difftimes a little painful to work with, 
  ## so lubridate provides an alternative that always uses seconds - the duration:

as.duration(h_age)

  ## Durations come with a bunch of convenient constructors:

dseconds(15)
dminutes(10)
dhours(c(12,24))
ddays(0:5)
dweeks(3)
dyears(1)

  ## You can add and multiply durations:

2 * dyears(1)

dyears(1) + dweeks(12) + dhours(15)

  ## You can add and subtract durations to and from days:

tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

  ## However, because durations represent an exact number of seconds, sometimes you might get an unexpected result:

one_pm <- ymd_hms("2016-03-12 13:00:00", tz = "America/New_York")

one_pm
one_pm + ddays(1)

  ## Notice that the time zones have changed.
  ## Because of DST, March 12 only has 23 hours, so if we add a full day's worth of seconds we end up with a different time.


# PERIODS

  ## To solve this problem, lubridate provides periods.
  ## Periods are time spans but don't have a fixed length in seconds.
  ## Instead they work with "human" times, like days and months.
  ## That allows them to work in a more intuitive way:

one_pm

one_pm + days(1)


  ## Like durations, periods can be created with a number of friendly constructor functions:

seconds(15)
minutes(10)
hours(c(12, 24))
days(7)
months(1:6)
weeks(3)
years(1)

  ## You can add and multiply periods:

10 * months(6) + days(1)

days(50) + hours(25) + minutes(2)

  ## And of course, add them to dates.
  ## Compared to durations, periods are more likely to do what you expect:

ymd("2016-01-01") + dyears(1)
ymd("2016-01-01") + years(1)

one_pm + ddays(1)
one_pm + days(1)


  ## Let's use periods to fix an oddity related to our flight dates.
  ## Some planes appear to have arrived at their destination before they departed from New York City:

flights_dt %>%
  filter(arr_time < dep_time)

  ## These are overnight flights.
  ## We used the same date information for both the departure and the arrival times, but these flights arrived on 
  ## the following day.
  ## We can fix this by adding days(1) to the arrival time of each overnight flight:

flights_dt <- flights_dt %>%
  mutate(overnight = arr_time < dep_time, 
         arr_time = arr_time + days(overnight * 1),
         sched_arr_time = sched_arr_time + days(overnight * 1))

  ## Now all of our flights obey the laws of physics:

flights_dt %>%
  filter(overnight, arr_time < dep_time)


# INTERVALS

  ## It's obvious what dyears(1) / ddays(365) should return: one.
  ## But what should years(1) / days(1) return?
  ## Well, if the year was 2015 it should return 365, but if it was 2016, it should return 366.

  ## lubridate gives a single clear answer: an estimate, with a warning:

years(1) / days(1)

  ## If you want a more accurate measurement, you'll have to use an interval.
  ## An interval is a duration with a starting point;
  ## That makes it precise so you can determine exactly how long it is:

next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)

  ## To find out how many periods fall into an interval, you need to use integer division:

(today() %--% next_year) %/% days(1)


# SUMMARY

  ## If you only care about physical time, use a duration;
  ## If you need to add human times, use a period;
  ## If you need to figure out how long a span is in human units, use an interval.

# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.


# TIME ZONES

  ## R uses the international standart IANA time zones.
  ## These use a consistent naming scheme with "/", typically in the form "<continent>/<city>.
  ## Read more in http://www.iana.org/time-zones

  ## You can find out what R thinks your current time zones is with Sys.timezone():

Sys.timezone()

  ## And see the complete list of all time zone names with OlsonNames():

length(OlsonNames())
head(OlsonNames())

  ## In R, the time zone is an attribute of the date-time that only controls printing.
  ## For example, these three objects represent the same instant in time:

(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
(x3 <- ymd_hms("2015-06-02 04:00:00", tz = "Pacific/Auckland"))

  ## You can verify that they're the same time using subtraction:
x1-x2
x1-x3

  ## Unless otherwise specified, lubridate always uses UTC.
  ## Operations that combine date-times, like c(), will often drop the time zone.
  ## In that case, the date-times will display in your local time zone:

x4 <- c(x1, x2, x3)
x4
  

  ## You can change the time zone in two ways:

  ## Keep the instant in time the same, and change how it's displayed. 
    ### Use this when the instant is correct, but you want a more natural display:
 
x4a <- with_tz(x4, tzone = "Australia/Lord_Howe")
x4a

x4a - x4

  ## Change the underlying instant in time.
    ### Use this when you have an instant that has been labeled with the incorrect time zone, and you need to fix it:

x4b <- force_tz(x4, tzone = "Australia/Lord_Howe")

x4b

x4b - x4