### DATA IMPORT WITH readr ###

library(tidyverse)
?readr

# GETTING STARTED

  ## Most of readr's functions are concerned with turning flat files into data frames:

  ## read_csv() reads comma-delimited files
  ## read_csv2() reads semicolon-separated files (common in countries where , is used at the decimal place)
  ## read_tsv() reads tab-delimited files
  ## read_delim() reads in files with any delimiter.

  ## read_fwf() reads fixed-width files
    ### You can specify fields either by their width with fwf_widths() or their position with fwf_positions()
  ## read_table() reads a common variation of fixed-width files where columns are separated by white space.

  ## read_log() reads Apache style log files (also check out the "webreadr" package)


  ## These functions all have similar syntax: once you've mastered one, you can use the others with ease.
  ## For this chapter we'll focus on read_csv(), 
    ### not only because csv are very common, but also because you apply the same knowledge for all other functions in readr.

  ## The first argument to read_csv() is the most important; it's the path to the file to read:

heights <- read_csv("C:\\Users\\lopes\\Dropbox\\datasets - Kaggle\\epldata_final.csv")

  ## When you run read_csv() it prints out a column specification that gives the name and type of each column.

  ## You can also supply an inline csv file. 
  ## This is useful for experimenting with readr and for creating reproducible examples to share with others:

read_csv("a,b,c
         1,2,3
       4,5,6")

  ## In both cases, read_csv() uses the first line of the data for the column names, which is a very common convention.
  ## There are two cases where you might want to tweak this behavior:

    ### Sometimes there are a few lines of metadata at the top of the file.
    ### You can use skip = n to skip the first n lines;
    ### or use comment = "#" to drop all lines that start with (e.g.) #:

read_csv("The first line of metadata
         The second line of metadata
         x,y,z
         1,2,3", skip = 2)
 
read_csv("# A comment I want to skip
         x,y,z
         1,2,3", comment = "#")

    ### The data might not have column names.
    ### You can use col_names = FALSE, so the columns will be labeled from X1 to Xn:

read_csv("1,2,3\n4,5,6", col_names = FALSE)

      #### "\n" is a convention shortcut for adding a new line. We'll see more in String basics.

    ### Alternatively you can pass col_names a character vector, which will be used as the column names:

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))


  ## Another option that commonly need tweaking is na.
  ## This specifies the value (or values) that are used to represent missing values in your file:

read_csv("a,b,c\n1,2,.", na = ".")

  ## This is all you need to know how to read ~75% of CSV files that you'll encounter in practice.
  ## You can adapt what you've learned to read tab-separated files with read_tsv() and fixed-width files with read_fwf().
  ## To read in more challenging files, you'll need to learn more about how readr parses each column, turning them into R vectors.

# COMPARED TO BASE R
  
  ## We can favor readr functions over the base R equivalents, because:
    ### they're much faster;
    ### they produce tibbles and don't convert character vectors to factors;
    ### they're more reproducible. 

# EXERCISES

  ## 1. 
read_delim("path", delim = "|")

  ## 2. 
?read_csv()
?read_tsv()

  ## 3.
?read_fwf()

  ## 4.

  ## 5.


# PARSING A VECTOR

  ## The parse_*() functions take a character vector and return a more specialized vector like a logical, integer, or date:

str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1970-10-14")))

  ## These functions are useful in their own right, but are also an important building block for readr.
  ## Like all functions in the tidyverse, the parse_*() functions are uniform;
    ### the first argument is a character vector do parse, and the na argument specifies which strings should be treated as missing:
parse_integer(c("1", "231", ".", "456"), na = ".")

  ## If parsing fails, you'll get a warning:
x <- parse_integer(c("123", "345", "abc", "123.45"))

  ## If there are many parsing failures, you'll need to use problems() to get the complete set.
    ### this returns a tibble, which you can then manipulate with dplyr:
problems(x)

  ## Using parsers is mostly a matter of understanding what's available and how they deal with different types of input.
  ## There are eight particularly important parsers:
    ### parse_logical() and parse_integer()
    ### parse_double() is a strict numeric parser, and parse_number() is a flexible numeric parser.
    ### parse_character()
    ### parse_factor() creaters factors, the data structure that R uses to represent categorical variables with fixed and known values.
    ### parse_datetime(), parse_date(), and parse_time() allow you to parse various date and time specifications.

  ## The following sections describe these parsers in more detail.

# NUMBERS

  ## Three problems can make tricky to parse a number:
    ### Some people use . and some use , to divide integer and fractional parts of a real number;
    ### Number are often surrounded by other characters, like "$1000" or "10%"
    ### Number often contain "grouping" characters to make them easier to read, like "1,000,000".

  ## To address the first problem, readr has the notion of a "locale", an object that specifies parsing options that differ from place to place.
  ## When parsing numbers, the most important option is the character you use for the decimal mark.
  ## The default value is . but you can override it by creating a new locale and setting the decimal_mark argument:

parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

  ## parse_number() addresses the second problem: it ignores non-numeric characters before and after the number.
  ## This is particularly useful for currencies and percentages, but also works to extract numbers embedded in text:

parse_number("R$100")
parse_number("20")
parse_number("It cost $123.45")
parse_number("It cost $123,45", locale = locale(decimal_mark = ","))

  ## The final problem is addressed by the combination of parse_number() and the locale as parse_number() will ignore the "grouping mark":

    ### Used in US:
parse_number("$123,456,789")
    ### Used in many parts of Europe:
parse_number("123.456.789", locale = locale(grouping_mark = "."))
    ### Used in Switzerland:
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

# STRINGS

  ## In R, we can get the underlying representation of a string using charToRaw():
charToRaw("Jose")

  ## Each hexadecimal number represents a byto of information: 4a is J, 6f is o, and so on.
  ## The mapping from hexadecimal number to character is called the encoding
    ### and in this case the encoding is called ASCII.
    ### ASCII: American Standart Code for Information Interchange.

  ## Today there is one standard that is supported almost everywhere: UTF-8.
  ## UTF-8 can encode just about every character used by hmans today, as well as many extra symbols (like emoji!).

  ## readr uses UTF-8 everywhere: it assumes your data is UTF-8 encoded when you read it, and always uses it when writing.
  ## This is a good default, but will fail for data produced by older systems that don't understand UTF-8.
  ## If this happens to you, your strings will look weird when you print them.

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

  ## To fix the problem you need to specify the encoding in parse_character():

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

  ## How do you find the correct encoding?
    ### If you're lucky, it'll be included somewhere in the data documentation.
    ### Otherwise, readr provides guess_encoding() to help you figure it out.
    ### It's not foolproof, and it works better when you have a lots of text, but it's a reasonable place to start.
    ### Expect to try a few different encodings before you find the right one:

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

  ## The first argumnet to guess_encoding() can either be a path to a file, or, as in this case, a raw vector (useful if the strings are already in R)
  ## If you'd like to learn more about encondings I'd recommend reading the detailed explanation at http://kunststube.net/encoding/


# FACTORS

  ## R uses factors to represent categorical variables that have a known set of possible values.
  ## Give parse_factor() a vector of known levels to generate a warning whenever an unexpected value is present:

fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

  ## But if you have many problematic entries, it's often easier to leave them as characters vectors and then use the tools from Chapters 11 and 12 to clean them up.


# DATES, DATE-TIMES, AND TIMES

  ## You pick between three parsers depending on wheter you want a date, a date-time, or a time.
  ## When called without any additional arguments:

  ## parse_datetime() expects an ISO8601 date-time. 
    ### ISO8601 is an international standart in which the components of a date are organized from biggest to smallest:
      #### year, month, day, hour, minute, second:
parse_datetime("2010-10-01T2010")

      #### if time is omitted, it will be set to midnight:
parse_datetime("20101010")

      #### This is the most important date/time standart.
      #### To read more about it: https://en.wikipedia.org/wiki/ISO_8601

  ## parse_date() expects a four-digit year, a - or /, the month, a - or /, then the day:
parse_date("2010-10-01")

  ## parse_time() expects the hour, :, minutes, optionally : and seconds, and an optional a.m./p.m. specifier:
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")

    ### Base R doesn't have a great built-in class for time data, so we use the one provided in the hms package.

  ## If these defaults don't work for your data you can supply your own date-time format, built up of the following pieces:
    
    ### Year
      #### %Y (4 digits)
      #### %Y (2 digits; 00-69 -> 2000-2069, 70-99 -> 1970-1999)
    
    ### Month
      #### %m (2 digits)
      #### %b (abbreviated name, like "Jan")
      #### %B (full name, like "January")

    ### Day
      #### %d (2 digits)
      #### %e (optional leading space)

    ### Time
      #### %H (0-23 hour format)
      #### %I (0-12, must be used with %p)
      #### %p (a.m./p.m. indicator)
      #### %M (minutes)
      #### $S (integer seconds)
      #### %OS (real seconds)
      #### %Z (time zone [a name, e.g., America/Chicago])
      #### %z (as offset from UTC, e.g., +0800)

    ### Nondigits
      #### %. (skips one nondigit character)
      #### %* (skips any number of nondigits)

  ## The best way to figure it out the correct format is to create a few examples in a character vector, and test with one of the parsing functions:

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

  ## If you're using %b or %B with non-English month names, you'll need to set the lang argument to locale().
  ## See the list of built-in languages in date_names_langs():
date_names_langs()
date_names_lang("pt")
    ### If your language is not already included, create your own with date_names().

parse_date("1 janeiro 2015", "%d %B %Y", locale = locale("pt"))


# EXERCISES

  ## 1. 

  ## 2.

  ## 3.

  ## 4.

  ## 5.
  
  ## 6.

  ## 7.


# PARSING A FILE

  ## Let's explore how readr parses a file. We'll learn:
    ### How readr automatically guesses the type of each column.
    ### How to override the default specification.

# STRATEGY
  
  ## readr reads the first 1000 rows and use some (moderately conservative) heuristics to figure out the type of each column.
  ## You can emulate this process with a character vector using:
    ### guess_parser(), which returns readr's best guess
    ### parser_guess(), which uses that guess to parse the column.

guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))

str(parse_guess("2010-10-10"))

  ## The heuristic tries each of the following types, stopping when it finds a match:
  
  ## logical
    ### contains only "F", "T", "FALSE", or "TRUE"
  ## integer
    ### contains only numeric characters (and -)
  ## double
    ### contains only valid doubles (including numbers like 4.5e-5)
  ## number
    ### contains valid doubles with the grouping mark inside
  ## time
    ### matches the default time_format
  ## date
    ### matches the default date_format
  ## date-time
    ### any ISO8601 date

  ## If none of these rules apply, then the column will stay as a vector of strings.


# PROBLEMS

  ## These defaults don't always work for larger files. There are two basic problems:
    ### the first thousand rows might be a special case, and readr guesses a type that is not sufficiently general.
    ### the column might contain a lot of missing values (readr will guess that it's a character vector).

  ## readr contains a challenging CSV that illustrates both of these problems:

challenge <- read_csv(readr_example("challenge.csv"))

  ## It's always a good idea to explicitly pull out the problems(), so you can explore them in more depth:
problems(challenge)

  ## A good strategy is to work column by column until there are no problems remaining.

  ## In the example, the x column has trailing characters after the integer values.
    ### That suggests we need to use a double parser instead.

  ## To fix the call, start by copying and pasting the column specification into your original call:

challenge <- read_csv(readr_example("challenge.csv"), 
                      col_types = cols(x = col_integer(), y = col_character()))

  ## Then you can tweak the type of the x column:

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(x = col_double(), y = col_character()))

  ## That fixes the first problem, but if we look at the last few rows, you'll see that they're date stored in a character vector:
tail(challenge)

  ## You can fix that by specifying that y is a date column:

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(x = col_double(), y = col_date()))

tail(challenge)

  ## Every parse_xyz() function has a corresponding col_xyz() function.
    ### You use parse_xyz() when the data is in a character vector in R already.
    ### You use col_xyz() when you want to tell readr how to load the data.

  ## I highly recommend always supplying col_types(), building up from the printout provided by readr.
  ## This ensures that you have a consisten and reproducible data import script.
  ## If you rely on the default guesses and your data changes, readr will continue to read it in.
  ## If you want to be really strict, use stop_for_problems():
    ### that will throw an error and stop your script if there are any parsing problems.


# OTHER STRATEGIES

  ## In the previous example, we just got unlucky:
    ### if we look at just one more row than the default, we can correctly parse in one shot:

challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)
challenge2

  ## Sometimes it's easier to diagnose problems if you just read in all the columns as character vectors:

challenge2 <- read_csv(readr_example("challenge.csv"), col_types = cols(.default = col_character()))

    ### This is particularly useful in conjunction with type_convert(), which applies the parsing heuristics to the character columns in a data frame:

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56")

df

type_convert(df)

  ## If you're reading a very large file, you might want to set n_max to a smallish number like 10,000.
    ### That will accelerate your iterations while you eliminate common problems.

  ## If you're having major parsing problems, sometimes it's easier to just read into a character vector of lines with read_lines(), or even a character vector of length 1 with read_file().
    ### Then you can you use the string parsing skill you'll learn later to parse more exotic formats.


# WRITING TO A FILE

  ## readr also comes with two useful functions for writing data back to disk: write_csv() and write_tsv().
  ## Both functions increase the chances of the output file being read back in correctly by:
    ### Always encoding strings in UTF-8.
    ### Saving dates and date-times in ISO8601 format so they are easily parsed elsewhere.

  ## If you want to export a CSV file to Excel, use write_excel_csv()
    ### this writes a special character (a "byte order mark") at the start of the file, which tells Excel that you're using the UTF-8 encoding.

  ## The most important arguments are x (the data frame to save) and path (the location to save it).
    ### You can also specify how missing values are written with "na", and if you want to "append" to an existing file:

write_csv(challenge, "challenge.csv")

  ## Note that the type of information is lost when you save to CSV:

challenge
write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

    ### This makes CSVs a little unreliable for caching interim results
      #### you need to re-create the column specifications every time you load in.
 
 ## There are two alternatives:

    ### write_rds() and read_rds() are uniform wrappers around the base functions readRDS() and saveRDS().
    ### These store data in R's custom binary format called RDS:

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

    ### The "feather" package implements a fast binary file format that can be shared across programming languages:

library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")

  ## feather tends to be faster than RDS and us usable outside of R.
  ## RDS supports list-columns (which you'll learn about in Chapter 20); feather currently does not.


# OTHER TYPES OF DATA

  ## For rectangular data:
    ### "haven" reads SPSS, Stata, and SAS files
    ### "readxl" reads Excel files (both .xls and .xlsx)
    ### "DBI", along with a database-specific backend (e.g., RMySQL, RSQLite, RPostgreSQL, etc.) allows you to run SQL queries against a database and return a data frame.

  ## For hierarchical data:
    ### "jsonlite" for JSON
    ### "xml2" for XML
      #### See excellent examples  at https://jennybc.github.io/purrr-tutorial

  ## For other file types, try the R data import/export manual
    ### https://cran.r-project.org/doc/manuals/r-release/R-data.html
  ## and the "rio" (https://github.com/leeper/rio) package.
