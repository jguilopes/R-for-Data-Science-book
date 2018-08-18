### STRINGS WITH stringr ###

# This chapter introduces you to string manipulation in R.
# You'll learn the basics of how strings work and how to create them by hand, 
# but the focus will be on regular expressions (regexps).
# Regular expressions are useful because strings usually contain unstructured or semi-structured data,
# and regexps are a concise language for describing patterns in strings.
# When you first look at a regexp, you'll think a cat walked accross your keyboard,
# but as your understanding improves they will soon start to make sense.

# This chapter will focus on the 'stringr' package for string manipulation.
# 'stringr' is not part of the core tidyverse because you don't always have textual data.

library(tidyverse)
library(stringr)


# STRINGS BASICS

  ## You can create strings with either single or double quotes.
  ## Unlike other languages, there is no difference in behavior.
  ## I recommend always using ", unless you want to create a string that contains multiple " :

string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

  ## To include a literal single or double quote in a string you can use \ :

double_quote <- " \" " # or ' " '
single_quote <- ' \' ' # or " ' "

  ## That means if you want to include a literal backslash, you'll need to double it up: " \\ " .

  ## Beware that the printed representation of a string is not the same as string itself,
  ## because the printed representation shows the escapes.
  ## To see the raw contents of the string, use writeLines():

x <- c("\"", "\\")
x

writeLines(x)


  ## There are a handful of other special characters.
  ## The most common are "\n", newline, and "\t", tab, but you can see the comple list by requesting ?'"' or ??"'".
  ## You'll also sometimes see strings like "\u00b5", which is a way of writing non-English characters:

x <- "\u00b5"
x

  ## Multiple strings are often stored in a character vector, which you can create with c():

c("one", "two", "three")



# STRING LENGTH

  ## 'stringr' functions all starts with str_ and are more consistent than base R functions.

str_length(c("a", "R for data science", NA))


# COMBINING STRINGS

  ## To combine two or more strings, use str_c():

str_c("x", "y")
str_c("x", "y", "z")

  ## Use the 'sep' argument to control how they're separated:

str_c("x", "y", sep = ", ")

  ## Like most other functions in R, missing valuesa are contagious. 
  ## If you want them to print as "NA", use str_replace_na():

x <- c("abc", NA)
str_c("|-", x, "-|")

str_c("|-", str_replace_na(x), "-|")

  ## As shown in the preceding code, str_c() is vectorized, 
  ## and it automatically recycles shorter vectors to the same length as the longest:

str_c("prefix-", c("a", "b", "c"), "-suffix")

  ## Objects of length 0 are silently dropped.
  ## This is particularly useful in conjunction with if:

name <- "Jose"
time_of_day <- "morning"
birthday <- FALSE

str_c("Good ", time_of_day, " ", name, if(birthday) " and HAPPY BIRTHDAY",".")

  ## To collapse a vector of strings into a single string, use 'collapse':

str_c(c("x", "y", "z"), collapse = ", ")



# SUBSETTING STRINGS

  ## You can extract parts of a string using str_sub().
  ## As well as the string, str_sub() takes 'start' and 'end' arguments that give the (inclusive) position of the substring:

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

str_sub(x, -3, -1)  # negative numbers count backwards from end

  ## Note that str_sub() won't fail if the string is too short;
  ## It will just return as much as possible:

str_sub("a", 1, 5)

  ## You can also use the assignment form of str_sub() to modify strings:

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
  ## You can also use:
    ### str_to_upper()
    ### str_to_title()



# LOCALES

  ## You can pick which set of rules to use by specifying a locale:

str_to_upper(c("i", "l"))

str_to_upper(c("i", "l"), locale = "tr")

  ## The locale is specified as an ISO639 language code. (http://bit.ly/ISO639-1)

  ## Another important operations that's affected by the locale is sorting.
  ## The base R order() and sort() functions sort strings using the current locale.
  ## If you want to robust behavior across different computers, you may want to use str_sort() and str_order(),
  ## which take an additional 'locale' argument:

x <- c("apple", "eggplant", "banana")

str_sort(x, locale = "en") # English

str_sort(x, locale = "haw") # Hawaiian


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.

  ## 6.


# MATCHING PATTERS WITH REGULAR EXPRESSIONS

  ## To learn regular expressions, we'll use str_view() and str_view_all(). 
  ## These functions take a character vector and a regular expression, and show you how they match.
  ## We'll start with very simple regular expressions and then gradually get more and more complicated.
  ## Once you've mastered pattern matching, you'll learn how to apply those ideas with various stringr functions.

# BASIC MATCHES

  ## The simplest patterns match exact match exact strings:

x <- c("apple", "banana", "pear")
str_view(x, "an")

  ## The next step up in complexity is ., which matches any character (except a newline):

str_view(x, ".a.")

  ## But if "." matches any character, how do you match the character "." ?
  ## You need to use an "escape" to tell the regular expression you want to match it exactly, not use its special behavior.
  ## Like strings, regexps use the backslash, \, to escape special behavior.
  ## So to match an ., you need the regexp \.
  ## But this creates a problem.
  ## We use strings to represent regexps, and \ is also used as an escape symbol in strings.
  ## So to create the regular expression \. we need the string "\\.":

dot <- "\\." # to create the regular expression, we need \\
writeLines(dot) # but the expression itself only contains one
str_view(c("abc", "a.c", "bef"), "a\\.c")

  ## How do we match a literal \ ?
  ## Creating a regular expression \\
  ## To match a literal \ you need to write "\\\\" !

x <- "a\\b"
writeLines(x)

str_view(x, "\\\\")

  ## In this book, I'll write regular expressions as \. 
  ## and strings that represent the regular expressions as "\\." 


# EXERCISES

  ## 1.

  ## 2.

  ## 3.


# ANCHORS

  ## By default, regular expressions will match any part of a string.
  ## It's often useful to 'anchor' the regular expressin so that it matches from the start or end of the string.
  ## You can use:
    ### ^ to match the start of the string
    ### $ to match the end of the string

x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$")


  ## tip for remember which is which:
    ### "if you begin with power (^), you end up with money ($).

  ## To force a regular expression to only match a complete string, achor it with both ^ and $:

x <- c("apple pie", "apple", "apple cake")

str_view(x, "apple")
str_view(x, "^apple$")



# EXERCISES

  ## 1.

  ## 2.


# CHARACTER CLASSES AND ALTERNATIVES

  ## There are a number of special patterns that match more than one character.
  ## You've already seen ., which matches any character apart from a newline.
  ## There are four other useful tools:

    ### \d matches any digit
    ### \s matches any whitespace (e.g., space, tab, newline)
    ### [abc] matches a, b, or c
    ### [^abc] matches anything except a, b, or c

  ## Remember, to create a regular expression containing \d or \s, you'll need to escape the \ for the string, 
  ## so you'll type "\\d" or "\\s".

  ## You can use alternation to pick between one or more alternative patterns.
  ## For example, abc|d..f will match eiter "abc", or "deaf".
  ## Note that the precedence for | is low, so that abc|xyz matches abc or xyz not abcyz or abxyz.

  ## Like mathematics, if precedence ever gets confusing, use parentheses to make it clear:

str_view(c("grey", "gray"), "gr(e|a)y")


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.

  ## 5.


# REPETITION

  ## The next step up in power involves controlling how many times a pattern matches:

    ### ?: 0 or 1
    ### +: 1 or more
    ### *: 0 or more

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, "C[LX]+")

  ## Note that the precedence of these operators is high, so you can write colou?r to match either American or British spellings.
  ## That means most uses will need parentheses, like bana(na)+

  ## You can also specify the number of matches precisely:

    ### {n}: exactly n
    ### {n, }: n or more
    ### {,m}: at most m
    ### {n,m}: between n and m

str_view(x, "C{2}")

str_view(x, "C{2,}")

str_view(x, "C{2,3}")

str_view(x, "C{2,3}?") # for matching the shortest string possible

str_view(x, "C[LX]+?")


# EXERCISES

  ## 1.

  ## 2.

  ## 3.

  ## 4.


# GROUPING AND BACKREFERENCES

  ## Earlier, you learned about parentheses as a way to disambiguate complex expressions.
  ## They also define "groups" that you can refer to with backreferences, like \1, \2, etc.
  ## For example, the following regular expression finds all fruits that have a repeated pair of letters:

str_view(fruit, "(..)\\1", match= TRUE)


# EXERCISES

  ## 1. 

  ## 2.



# TOOLS

  ## Now that you've learned the basics of regular expressions, it's time to learn how to apply them to real problems.
  ## In this section you'll learn a wide array of stringr functions that let you:
    ### Determine which strings match a pattern
    ### Find the positions of matches
    ### Extract the content of matches
    ### Replace matches with new values
    ### Split a string based on a match


  ## Caution: Instead of creating one complex regular expression, it's often easier to create a series of simpler regexps.
  ## If you get stuck trying to create a single regexp that solves your problem, take a step back and think if you could
  ## break the problem down into smaller pieces, solving each challenge before moving on to the next one.



# DETECT MATCHES

  ## To determine if a character vector matches a pattern, use str_detect().
  ## It returns a logical vector the same length as the input:

x <- c("apple", "banana", "pear")
str_detect(x, "e")

  ## As FALSE = 0 and TRUE = 1, 
  ## this makes sum() and mean() useful if you want to answer questions about matches across a larger vector:

sum(str_detect(words, "^t")) # how many common words start with t?

mean(str_detect(words, "[aeiou]$")) # what proportion of common words end with a vowel?

  ## When you have complex logical conditions, it's often easier to combine multiple str_detect() calls with logical operators,
  ## rather than trying to create a single regular expression.
  ## For example, here are two ways to find all words that don't contains any vowels:

no_vowels_1 <- !str_detect(words, "[aeiou]") # find all words containing at least one vowel, and negate

no_vowels_2 <- str_detect(words, "^[^aeiou]+$") # find all words consisting only of consonants (non-vowels)

identical(no_vowels_1, no_vowels_2)

  ## The results are identical, but I think the first approach is significantly easier to understand.
  
  ## If your regular expression gets overly complicated, try breaking it up into smaller pieces, 
  ## giving each piece a name, and then combining the pieces with logical operations.

  ## A common use of str_detect() is to select the elements that match a pattern.
  ## You can do this with logical subsetting, or the convenient str_subset() wrapper:

words[str_detect(words, "x$")]

str_subset(words, "x$")

  ## Typically, however, your strings will be one column of a data frame, and you'll want to use 'filter' instead:

df <- tibble(word = words, i = seq_along(word))

df %>%
  filter(str_detect(words, "x$"))


  ## A variation on str_detect() is str_count():
  ## rather than a simple yes or no, it tells you how many matches there are in a string:

x <- c("apple", "banana", "pear")
str_count(x, "a")

mean(str_count(words, "[aeiou]")) # On average, how many vowels per word?


  ## It's natural to use str_count() with mutate():

df %>%
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

  ## Note that matches never overlap.
  ## For example, in "abababa", how many times will the pattern "aba" match?
  ## Regular expressions say two, not three:

str_count("abababa", "aba")
str_view_all("abababa", "aba")

  ## Note the use of str_view_all().
  ## As you'll shortly learn, many stringr functions come in pairs:
  ## one function works with a single match, and the other works with all matches.
  ## The second function wll have the suffix _all.


# EXERCISES

  ## 1. 



# EXTRACT MATCHES

  ## To extract the actual text of a match, use str_extract().
  ## To show that off, we're going to need a more complicated example.

length(sentences)
head(sentences)

  ## Imagine we want to find all sentences that contain a color.
  ## We first create a vector of color names, and then turn it into a single regular expression:

colors <- c("red", "orange", "yellow", "green", "blue", "purple")

color_match <- str_c(colors, collapse = "|")
color_match

  ## Now we can select the sentences that contain a color, and then extract the color to figure out which one it is:

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

  ## Not that str_extract() only extracts the first match.
  ## We can see that most easily by first selecting all the sentences that have more than one match:

more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(more, color_match)

  ## This is a common pattern for stringr functions, 
  ## because working with a single match allows you to use much simpler data structures.
  ## To get all matches, use str_extract_all(). It returns a list:

str_extract_all(more, color_match)

  ## You'll learn more about lists in "Recursive Vectors (Lists)" in Chapter 17.

  ## If you use simplify = TRUE, str_extract_all() will return a matrix with short matches expanded to the same 
  ## length as the longest:

str_extract_all(more, color_match, simplify = TRUE)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)



# EXERCISES

  ## 1.

  ## 2.


# GROUPED MATCHES

  ## You can also use parentheses to extract parts of a complex match.
  ## For example, imagine we want to extract nouns from the sentences.
  ## As a heuristic, we'll look for any word that comes after "a" or "the".
  ## Defining a "word" in a regular expression is a little tricky, so here I use a simple approximation,
    ### a sequence of at least one character that isn't a space:

noun <- "(a|the) ([^ ]+)"

has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)

has_noun %>%
  str_extract(noun)

  ## str_extract() gives us the complete match.
  ## str_match() gives each individual component.
  ## Instead of a character vector, it returns a matrix, with one column for the comple match followed by one column for each group:

has_noun %>%
  str_match(noun)

  ## If your data is in a tibble, it's often easier to use tidyr::extract().
  ## It works like str_match() but requires you to name the matchs, which are then placed in new columns:

tibble(sentence = sentences) %>%
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)",
    remove = FALSE)

  ## Like str_extract(), if you want all matches for each string, you'll need str_match_all().


# EXERCISES

  ## 1.

  ## 2.


# REPLACING MATCHES

  ## str_replace() and str_replace_all() allow you to replace matches with new strings.
  ## The simplest use is to replace a pattern with a fixed string:

x <- c("apple", "pear", "banana")

str_replace(x, "[aeiou]", "-")

str_replace_all(x, "[aeiou]", "-")

  ## With str_replace_all() you can perform multiple replacements by supplying a named vector:

x <- c("1 house", "2 cars", "3 people")

str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

  ## Instead of replacing with a fixed string you can use backreferences to insert components of the match.
  ## In the following code, I flip the order of the second and third words:

sentences %>%
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%
  head(5)



# EXERCISES

  ## 1.

  ## 2.

  ## 3.


# SPLITTING

  ## Use str_split() to split a string up into pieces. 
  ## For example, we could split sentenctes into words:

sentences %>%
  head(5)%>%
  str_split(" ")

  ## Because each component might contain a different number of pieces, this returns a list.
  ## If you're working with a length-1 vectir, the easiest thing is to just extract the first element of the list:

"a|b|c|d" %>%
  str_split("\\|") %>%
  .[[1]]

  ## Otherwise, like the other stringr functions that return a list, 
  ## you can use simplify = TRUE to return a matrix:

sentences %>%
  head(5) %>%
  str_split(" ", simplify = TRUE)


  ## You can also request a maximum number of pieces:

fields <- c("Name: Jose", "Country: BR", "Age: 26")

fields %>%
  str_split(": ", n = 2, simplify = TRUE)


  ## Instead of splitting up strings by patterns, you can also split up by character, line, sentence, and word boundary()s:

x <- "This is a sentence. This is another sentence."

str_view_all(x, boundary("word"))

str_split(x, " ")[[1]]

str_split(x, boundary("word"))[[1]]



# EXERCISES

  ## 1.

  ## 2.

  ## 3.


# FIND MATCHES

  ## str_lcate() and str_locate_all() give you the starting and ending positions of each match.
  ## These are particularly useful when none of the other functions does exactly what you want.
  ## You can use str_locate() to find the matching pattern, and str_sub() to extract and/or modify them.


# OTHER TYPES OF PATTERN

  ## When you use a pattern that's a string, it's automatically wrapped into a call to regex():

str_view(fruit, "nana") # the regular call

str_view(fruit, regex("nana")) # is shorthand for


  ## You can use the other arguments of regex() to control details of the match:

  ## ignore_case = TRUE allows characters to match either their uppercase or lowercase forms,
  ## This always uses the current locale:

bananas <- c("banana", "Banana", "BANANA")

str_view(bananas, "banana")

str_view(bananas, regex("banana", ignore_case = TRUE))


  ## multiline = TRUE allows ^ and $ to match the start and end of each line rather than the start and end of the complete string:

x <- "Line 1\nLine 2\nLine 3"

str_extract_all(x, "^Line")[[1]]

str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

  ## comments = TRUE allows you to use comments and white space to make comlex regular expressions more understandable.
  ## Spaces are ignored, as is everything after #.
  ## To match a literal space, you'll need to escape it: " \\ ".

phone <- regex("
               \\(? # comment
               (\\d{3}) #comment
               [)- ]? #comment
               (\\d{3}) # comment
               [ -]? #comment
               (\\d{3}) # comment", comments = TRUE)

str_match("514-791-8141", phone)

  ## dotall = TRUE allows . to match everything, including \n.

  ## There are three other functions you can use instead of regex():

  ## fixed() matches exactly the specified sequence of bytes.
  ## coll() compares strings using standard collation rules.

  ## As you saw with str_split(), you can use boundary() to match boundaries.
  ## You can also use it with the other functions:

x <- "This is a sentence"

str_view_all(x, boundary("word"))

str_extract_all(x, boundary("word"))


# EXERCISES

  ## 1.

  ## 2.


# OTHER USES OF REGULAR EXPRESSIONS

  ## There are two useful functions in base R that also use regular expressions:

  ## apropos() searches all objects available from the global environment.
  ## This is useful if you can't quite remember the name of the function:

apropos("replace")

  ## dir() lists all the files in a directory().
  ## The pattern argument takes a regular expression and only returns filenames that match the pattern.
  ## For example, you can find all the R Markdown files in the current directory with:

head(dir(pattern = "\\.Rmd$"))