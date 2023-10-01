#mysql set up
install.packages("RMySQL")
library(RMySQL)

mysqlconnection = dbConnect(RMySQL::MySQL(),
                            dbname='607_AssignmentW5',
                            host='localhost',
                            port=3306,
                            user='root',
                            password='')

dbListTables(mysqlconnection)

#query from mysql
result = dbSendQuery(mysqlconnection, "select * from arrivalDelays") 
arrivalDelays = fetch(result)
arrivalDelays <- subset(arrivalDelays, select = -1)
arrivalDelays

#turn mysql query into a csv for rmd
write.csv(arrivalDelays,file='/Users/Ari/Data607/assignmentW5/arrivalDelays.csv')

#clean data - using 2 libraries
library(tidyr)
library(dplyr)

as_tibble(arrivalDelays)
arrivalDelays

#tidy means 1 row for each observations - (4*5=20)
arrivalDelay_tidy <- 
  pivot_longer(arrivalDelays, 
             cols=c('LosAngeles', 'Phoenix', 'SanDiego', 'SanFrancisco', 'Seatte'),
             names_to = 'Locations',
             values_to = 'Flights')
arrivalDelay_tidy <- arrivalDelay_tidy[order(arrivalDelay_tidy$Locations),]
arrivalDelay_tidy

#analysis

arrivalDelay_tidy %>% group_by(airline) %>% 
  summarise(count=sum(Flights),
            .groups = 'drop')

arrivalDelay_tidy %>% 
  group_by(airline, delayStatus) %>% 
  summarise(count=sum(Flights),
            .groups = 'drop')

arrivalDelay_tidy %>% 
  group_by(Locations) %>% 
  summarise(count=sum(Flights),
            .groups = 'drop')

arrivalDelay_tidy %>% 
  group_by(Locations, delayStatus) %>% 
  summarise(count=sum(Flights),
            .groups = 'drop')

