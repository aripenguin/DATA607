install.packages("RMySQL")
library(RMySQL)

mysqlconnection = dbConnect(RMySQL::MySQL(),
                            dbname='607_Assignment2',
                            host='localhost',
                            port=3306,
                            user='root',
                            password='')

dbListTables(mysqlconnection)

result = dbSendQuery(mysqlconnection, "select * from moviesRating") 
# write query to access the records from a particular table.

moviesRating = fetch(result)
moviesRating

#for rmarkdown purposes, saved to a csv
write.csv(moviesRating,file='/Users/Ari/Data607/moviesRating.csv')

#managing null values
for(i in 1:ncol(moviesRating)) {
  if (any(is.na(moviesRating[ ,i]))){
    moviesRating[ ,i][is.na(moviesRating[ ,i])] <- mean(moviesRating[ ,i], na.rm=TRUE)
    moviesRating[ ,i]=round(moviesRating[ ,i],1)
    }
}

moviesRating

library(readr)
moviesRating2 <- read_csv("Data607/moviesRating.csv")

moviesRating2

#get rid of first column & make a dataframe
moviesRating2 <- subset(moviesRating2, select=c(2,3,4,5,6,7,8))
moviesRating2 = as.data.frame(moviesRating2)
moviesRating2
#moviesRating3 to be used later for the null values
moviesRating3 <- moviesRating2

#get rid of null values
for(i in 1:ncol(moviesRating2)) {
  if (any(is.na(moviesRating2[ ,i]))){
    moviesRating2[ ,i][is.na(moviesRating2[ ,i])] <- mean(moviesRating2[ ,i], na.rm=TRUE)
    moviesRating2[ ,i]=round(moviesRating2[ ,i],1)
  }
}

moviesRating2

#graphs
library(ggplot2)

#bar graph total null vs nonnull ratings
totalnulls <- data.frame(nulls=c("null ratings", "non-null ratings"), count=c(0, 0))
totalnulls

totalnulls[1,2]=sum(is.na(moviesRating))
totalnulls[2,2]=((ncol(moviesRating)-1)*nrow(moviesRating)-sum(is.na(moviesRating)))
totalnulls

ggplot(data=totalnulls, aes(x=nulls,y=count))+geom_bar(stat="identity", width=0.5,fill="lightblue")+xlab("total ratings")

#bar graph total numbers of movies withnulls vs no nulls
nullvsnonnull <- data.frame(nulls=c("has nulls", "no nulls"), count=c(0, 0))

nullvsnonnull
for(i in 2:ncol(moviesRating2)) {
  if (any(is.na(moviesRating2[ ,i]))){
    nullvsnonnull[1,-1] = (nullvsnonnull[1,-1]+1)
  }else{
    nullvsnonnull[2,-1] = (nullvsnonnull[2,-1]+1)
  }
}
nullvsnonnull

ggplot(data=nullvsnonnull, aes(x=nulls,y=count))+geom_bar(stat="identity", width=0.5,fill="lightblue")

#movie specific null to non null
sum = nrow(moviesRating2)
movieNull <- data.frame(group=rep(c("nulls","non-nulls"),each=6),
                        movies=rep(c("SpidermanNWH", "DrStrange2", "BlackPanther2", "Thor4", "Antman3", "GOTG3")),
                        count=c(0,0,0,0,0,0,sum,sum,sum,sum,sum,sum))
movieNull

for(i in 2:ncol(moviesRating2)) {
  movieNull[(i-1),3] = sum(is.na(moviesRating2[i]))
  movieNull[(i+5),3] = (sum-sum(is.na(moviesRating2[i])))
}

movieNull

ggplot(movieNull, aes(x=factor(movies,level=c("SpidermanNWH", "DrStrange2", "BlackPanther2", "Thor4", "Antman3", "GOTG3")),y=count,fill=group))+ 
  geom_bar(stat="identity",position=position_dodge()) + xlab("movies")


#ggplot with averages
#add last row with average scores
moviesMean <- data.frame(movies=rep(c("SpidermanNWH", "DrStrange2", "BlackPanther2", "Thor4", "Antman3", "GOTG3")),
                      averages=c(0,0,0,0,0,0))

moviesMean[1,2]=mean(moviesRating$SpidermanNWH)
moviesMean[2,2]=mean(moviesRating$DrStrange2)
moviesMean[3,2]=mean(moviesRating$BlackPanther2)
moviesMean[4,2]=mean(moviesRating$Thor4)
moviesMean[5,2]=mean(moviesRating$Antman3)
moviesMean[6,2]=mean(moviesRating$GOTG3)

moviesMean
ggplot(data = moviesMean, aes(x=factor(movies,level=c("SpidermanNWH", "DrStrange2", "BlackPanther2", "Thor4", "Antman3", "GOTG3")), y = averages,fill=movies)) + 
  geom_bar(stat="identity") + xlab("movies")


