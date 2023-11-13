library(tidyr)
library(lubridate)

#find data set
#Create an Example.  
#Using one or more TidyVerse packages, & any dataset
#create a programming sample “vignette” that demonstrates how to use one or more of the capabilities of the selected TidyVerse package with your selected dataset.

lotteryInitial <- read.csv("Data607/tidyverse/lotteryorder.csv")
lotteryInitial = lotteryInitial[-1,]
head(lotteryInitial)
colnames(lotteryInitial)

#using the lubridate package, condense the date
lotteryClean <- subset(lotteryInitial, select=-c(4,5))
colnames(lotteryClean)[3] = "Date"
head(lotteryClean)


for (i in 1:length(lotteryClean)){
  #get for lotteryInitial - DD MMM YYYY
  day = lotteryInitial$DD
  month = lotteryInitial$MMM
  year = lotteryInitial$YYYY
  date =  paste(year, month, day, sep="")
  lotteryClean$Date = ymd(date)
  lotteryClean$Day = wday(ymd(date),label = TRUE, abbr = FALSE)
}

head(lotteryClean)
