#w5 for 3 untidy datasets
library(dplyr)
library(tidyr)
library(readr)

#dataset 1 - Matthew Roland (World Population)
worldPopulation <- read_csv("Data607/project2/world_population.csv")
colnames(worldPopulation) 
nrow(worldPopulation)
#tidy - population into year & population #
worldPopulation_tidy <- 
  pivot_longer(worldPopulation, 
               cols=c('2022 Population', '2020 Population', '2015 Population', '2010 Population', 
                      '2000 Population', '1990 Population', '1980 Population', '1970 Population'),
               names_to = 'Year',
               values_to = 'Population #')
worldPopulation_tidy <- worldPopulation_tidy[order(worldPopulation_tidy$`Country/Territory`),]
worldPopulation_tidy
colnames(worldPopulation_tidy)
worldPopulation_tidy
worldPopulation_tidy[,c(1:3,10:11)]

write.csv(worldPopulation_tidy,file='/Users/Ari/Data607/project2/worldPopulation_tidy.csv')

#dataset 2 - Haig Bedros (US Stock Market)
stockMarket <- read_csv("Data607/project2/market_indicators.csv")
colnames(stockMarket)
stockMarket
#tidy - separate the oil and gold into 2 dataframes, then the treasury into treasury year & count
oilMarket_tidy <- subset(stockMarket, select = c(1,2,3))
goldMarket_tidy <- subset(stockMarket, select = c(1,2,4))
goldMarket_tidy
treasuryMarket <- subset(stockMarket, select = c(1,2,5,6,7))

treasuryMarket_tidy <- 
  pivot_longer(treasuryMarket, 
               cols=c('treasury_5_years', 'treasury_10_years', 'treasury_30_years'),
               names_to = 'Treasury Year',
               values_to = 'Amount')
treasuryMarket_tidy <- treasuryMarket_tidy[order(treasuryMarket_tidy$Date),]
#clean up the Treasury Year names replace?
treasuryMarket_tidy$`Treasury Year`[which(treasuryMarket_tidy$`Treasury Year`=="treasury_5_years")] <- 5
treasuryMarket_tidy$`Treasury Year`[which(treasuryMarket_tidy$`Treasury Year`=="treasury_10_years")] <- 10
treasuryMarket_tidy$`Treasury Year`[which(treasuryMarket_tidy$`Treasury Year`=="treasury_30_years")] <- 30
treasuryMarket_tidy







#dataset 3 
sleepingAlone <- read_csv("Data607/project2/sleeping-alone-data.csv")
colnames(sleepingAlone) 
nrow(sleepingAlone)
#tidy - population into year & population #
sleepingAlone_tidy <- 
  pivot_longer(worldPopulation, 
               cols=c('2022 Population', '2020 Population', '2015 Population', '2010 Population', 
                      '2000 Population', '1990 Population', '1980 Population', '1970 Population'),
               names_to = 'Year',
               values_to = 'Population #')
worldPopulation_tidy <- worldPopulation_tidy[order(worldPopulation_tidy$`Country/Territory`),]
worldPopulation_tidy[]
