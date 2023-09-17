library(stringr)

## 1. Using the 173 majors listed in fivethirtyeight.com’s College Majors dataset [https://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/], provide code that identifies the majors that contain either "DATA" or "STATISTICS"
#install.packages("RCurl")
library(RCurl) 
x <- getURL("https://raw.githubusercontent.com/fivethirtyeight/data/master/college-majors/majors-list.csv") 
y <- read.csv(text = x)
y

selectedMajors <- y[str_detect(y$Major, "DATA|STATISTICS"), ]
selectedMajors

nrow(selectedMajors)
str_c(selectedMajors$Major, collapse = ", ")

## 2. Write code that transforms the data below:

before <- "bell pepper, bilberry, blackberry, blood orange, blueberry, cantaloupe, chili pepper, cloudberry, elderberry, lime, lychee, mulberry, olive, salal berry"
before

after <- c(str_split(before, ", "))
after

## 3. Describe, in words, what these expressions will match:

#a (.)\1\1
str_detect("aaa", "(.)\1\1")
str_detect("aaa", "(.)\\1\\1")

#b "(.)(.)\\2\\1"
str_detect("adeed", "(.)(.)\\2\\1")

#c (..)\1
str_detect("haha", "(..)\1")
str_detect("haha", "(..)\\1")

#d "(.).\\1.\\1"
str_detect("banana", "(.).\\1.\\1")

#e "(.)(.)(.).*\\3\\2\\1"
str_detect("abccba", "(.)(.)(.).*\\3\\2\\1")


## 4. Construct regular expressions to match words that:

#a Start and end with the same character.
str_detect("area","^(.).*\\1$")

#b Contain a repeated pair of letters (e.g. "church" contains "ch" repeated twice.)
str_detect("chruch", "(..).*\\1")

#c Contain one letter repeated in at least three places (e.g. "eleven" contains three "e"s.)
str_detect("eleven", "(.).*\\1.*\\1")
