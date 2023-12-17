#data 607 final project
#to find out what variables makes one manga sell better than another 
#to see if I can predict how success a new manga will be


#https://www.kaggle.com/datasets/andreuvallhernndez/myanimelist?select=manga.csv
#https://www.kaggle.com/datasets/drahulsingh/best-selling-manga

#feedback
#Good proposal - try identifying the variables as part of your exploration. 
#I didn't find the dataset itself, but did see a lot of available code and even available APIs. 
#Make sure to document all your sources. 
#You can use work from others, not sure it will help you, just make sure to call it out.


#steps: 
#find a second csv - top 100 mangas, use anime dataset as well (if the anime is doing good so does the manga)
#clean data
#start looking at the variables or data

#ppt: title, intro, 

library(readr)
library(dplyr)
myanimelist_manga <- read.csv("Data607/finalproject/myanimelist/manga.csv")
head(myanimelist_manga)
colnames(myanimelist_manga)
nrow(myanimelist_manga)

myanimelist_anime <- read.csv("Data607/finalproject/myanimelist/anime.csv")
head(myanimelist_anime)
colnames(myanimelist_anime)
nrow(myanimelist_anime)

#clean both
myanimelist_manga <- subset(myanimelist_manga, select=c(1,2,3,4,5,6,7,8,9,10,11,12,13,19,20,21,23))
colnames(myanimelist_manga)
#clean columns: end_date (fix blanks -> NA), genres?, themes?, demographics, serializations
#end date add NA
myanimelist_manga$end_date[myanimelist_manga$end_date==""] <- NA
myanimelist_manga$demographics <- str_extract(myanimelist_manga$demographics, "[A-Z]+[a-z]+")
myanimelist_manga$serializations <- str_extract(myanimelist_manga$serializations, "[A-Z]+[a-z]+")
#weird titles
myanimelist_manga$title[myanimelist_manga$title=="One Punch-Man"] <- "One Punch Man"

myanimelist_anime <- subset(myanimelist_anime, select=c(1,2,3,4,5,6,7,8,9,10,11,12,15,29))
colnames(myanimelist_anime)
#clean columns: end_date (fix blanks -> NA), studios
#end date add NA
myanimelist_anime$end_date[myanimelist_anime$end_date==""] <- NA
myanimelist_anime$studios <- str_extract(myanimelist_anime$studios, "[A-Z]+[a-z]+")
#get rid of dup roles for join
colnames(myanimelist_anime)[3] = "type_anime"
colnames(myanimelist_anime)[4] = "score_anime"
colnames(myanimelist_anime)[5] = "scored_by_anime"
colnames(myanimelist_anime)[6] = "status_anime"
colnames(myanimelist_anime)[8] = "start_date_anime"
colnames(myanimelist_anime)[9] = "end_date_anime"
colnames(myanimelist_anime)[11] = "members_anime"
colnames(myanimelist_anime)[12] = "favorites_anime"

#make one big myanimelist dataset: join to anime (do they have an adaption?, views, etc.)
myanimelist <- left_join(myanimelist_manga, myanimelist_anime, by = "title")
myanimelist <- myanimelist_manga
myanimelist[ , 'anime_adaption'] <- No
myanimelist$anime_adaption <- 'No'

colnames(myanimelist)
nrow(myanimelist)
head(myanimelist)
print(myanimelist_anime$title)
NA %in% myanimelist_anime$title

#talk about my for loop problem
myanimelist$anime_adaption[myanimelist$title %in% myanimelist_anime$title] <- "Yes"
colnames(myanimelist)
head(myanimelist[, c(2,18)])


for (x in head(myanimelist)) {
  print(myanimelist$title[x])
  print("-")
  t <- myanimelist$title[x] %in% myanimelist_anime$title
  print(t)
  ifelse(t==TRUE, myanimelist$anime_adaption[myanimelist$title == myanimelist$title[x], ] <- 'Yes', 'No')
  #if(t != FALSE){
    #print("Yes")
  #}
  #if(sum(str_detect(myanimelist_anime$title, myanimelist$title[x])) > 0){
    #myanimelist$anime_adaption[x] = "Yes"
    #print("Yes")
  #}
}

if(sum(str_detect(myanimelist_anime$title, "D.Gray-man")) > 0){
  #myanimelist$anime_adaption[x] = "Yes"
  print("Yes")
}


'D.Gray-man' %in% myanimelist_anime$title
sum(str_detect(myanimelist_anime$title, 'D.Gray-man'))
str_extract_all("One Punch-Man","[A-Za-z]+( [A-Za-z]+ [A-Za-z]+)?")
gsub("[^a-zA-Z ]", "", "One Punch-Man")
gsub("-", " ", "One Punch-Man")

str_extract_all("One Punch-Man","[:punct:]")


bestsellingmanga <- read.csv("Data607/finalproject/best-selling-manga.csv")
head(bestsellingmanga)
colnames(bestsellingmanga)[1]="title"
colnames(bestsellingmanga)
nrow(bestsellingmanga)

bestsellingmanga$anime_adaption <- 'No'
bestsellingmanga$anime_adaption[bestsellingmanga$title %in% myanimelist_anime$title] <- "Yes"
head(bestsellingmanga)

#create long datasets for genres and themes for the top mangas
top_manga <- inner_join(bestsellingmanga, myanimelist_manga, by = "title")
#get rid of non manga rows if type != "manga" for dups
top_manga <- top_manga[top_manga$type == 'manga', ]
head(top_manga)
nrow(top_manga)

#genres
top_manga_genres <- data.frame(matrix(ncol=2,nrow=0))
colnames(top_manga_genres) <- c('title','genre')
top_manga_genres

for (i in 1:nrow(top_manga)){
  print(top_manga$title[i])
  genre_manga <- str_extract_all(top_manga$genres[i],"[A-Za-z]+(-[A-Za-z]+)?( [A-Za-z]+ [A-Za-z]+)?( [A-Za-z]+)?")
  for(m in genre_manga){
    for(n in m){
      top_manga_genres[nrow(top_manga_genres) + 1, ] = c(top_manga$title[i], n)
    }
  }
}
top_manga_genres
nrow(top_manga_genres)
nrow(top_manga_genre[top_manga_genre$genre == "Action", ])
top_manga_genres$count <- 1

top <- top_manga_genres %>% group_by(genre) %>%
  summarise(count=sum(count),
            .groups = 'drop')
top <- top[order(top$count, decreasing = TRUE), ]
top
ggplot(data=top, aes(x=genre, y=count)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

#themes
top_manga_themes <- data.frame(matrix(ncol=2,nrow=0))
colnames(top_manga_themes) <- c('title','theme')
top_manga_themes

for (i in 1:nrow(top_manga)){
  print(top_manga$title[i])
  genre_manga <- str_extract_all(top_manga$themes[i],"[A-Za-z]+(-[A-Za-z]+)?( [A-Za-z]+ [A-Za-z]+)?( [A-Za-z]+)?")
  for(m in genre_manga){
    for(n in m){
      top_manga_themes[nrow(top_manga_themes) + 1, ] = c(top_manga$title[i], n)
    }
  }
}
top_manga_themes
nrow(top_manga_themes)



#work
str_extract_all("['Drama', 'Ecchi', 'Romance', 'Slice of Life']","[A-Za-z]+")
str_extract_all("['Drama', 'Ecchi', 'Romance', 'Slice of Life']","[A-Za-z]+( [A-Za-z]+)?")
str_extract_all("['Drama', 'Ecchi', 'Romance', 'Slice of Life']","[A-Z]+(.)+[a-z]+")
str_extract_all("['Action', 'Adventure', 'Award Winning',' Ecchi', 'Sci-Fi', 'Slice of Life']","[A-Za-z]+(-[A-Za-z]+)?( [A-Za-z]+ [A-Za-z]+)?( [A-Za-z]+)?")

genre_manga <- str_extract_all("['Action', 'Adventure', 'Award Winning',' Ecchi', 'Sci-Fi', 'Slice of Life']","[A-Za-z]+(-[A-Za-z]+)?( [A-Za-z]+ [A-Za-z]+)?( [A-Za-z]+)?")
genre_manga
typeof(genre_manga)
for (j in genre_manga){
  print(j)
  for(i in j){
    print(i)
  }
}

head(myanimelist)
animelist <- myanimelist %>% group_by(anime_adaption) %>%
  summarise(count=0,
            .groups = 'drop')

animelist <- data.frame(matrix(ncol=2,nrow=0))
colnames(animelist) <- c('anime_adaption','count')
animelist[nrow(animelist) + 1, ] = c('Yes', nrow(myanimelist[myanimelist$anime_adaption == "Yes", ]))
animelist[nrow(animelist) + 1, ] = c('No', nrow(myanimelist[myanimelist$anime_adaption == "No", ]))
nrow(myanimelist[myanimelist$anime_adaption == "Yes", ])
animelist


colnames(myanimelist)

#find probabilty notes on key  set.seed(49563)

samp <- myanimelist %>%
  sample_n(10)

samp
colnames(samp)

#genres
samp_genres <- data.frame(matrix(ncol=2,nrow=0))
colnames(samp_genres) <- c('title','genre')
samp_genres

for (i in 1:nrow(samp)){
  t <- str_extract_all(samp$genres[i],"[A-Za-z]+(-[A-Za-z]+)?( [A-Za-z]+ [A-Za-z]+)?( [A-Za-z]+)?")
  for(m in t){
    for(n in m){
      samp_genres[nrow(samp_genres) + 1, ] = c(samp$title[i], n)
    }
  }
}
samp_genres <- na.omit(samp_genres)
samp_genres

samp_genres$count <- 1
samp_genres_stats <- samp_genres %>% group_by(genre) %>%
  summarise(count=sum(count),
            .groups = 'drop')
samp_genres_stats <- samp_genres_stats[order(samp_genres_stats$count, decreasing = TRUE), ]
samp_genres_stats
ggplot(data=samp_genres_stats, aes(x=genre, y=count)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

sum(samp_genres_stats$count)
t <- 0 
for(x in 1:nrow(samp_genres_stats)){
  print(samp_genres_stats$genre[x])
  if(samp_genres_stats$genre[x] %in% head(top$genre, 5)){
    t <- t + samp_genres_stats$count[x]
  }
}
print(t/sum(samp_genres_stats$count)*100)
"Action" %in% head(top$genre, 5)
head(top$genre, 5)

#themes
top_manga_themes <- data.frame(matrix(ncol=2,nrow=0))
colnames(top_manga_themes) <- c('title','theme')
top_manga_themes

for (i in 1:nrow(top_manga)){
  print(top_manga$title[i])
  genre_manga <- str_extract_all(top_manga$themes[i],"[A-Za-z]+(-[A-Za-z]+)?( [A-Za-z]+ [A-Za-z]+)?( [A-Za-z]+)?")
  for(m in genre_manga){
    for(n in m){
      top_manga_themes[nrow(top_manga_themes) + 1, ] = c(top_manga$title[i], n)
    }
  }
}
top_manga_themes
nrow(top_manga_themes)



#get top 5 genres and themes


#analysis on myanimelist big table (), genre long, theme long

#to do: fix myanimelist, analysis and graphs

#graphs: does the popular mangas have animes
#ppt: intro, 

colnames(bestsellingmanga)
colnames(myanimelist_manga)

## more samples
```{r samples, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
library(readr)
library(stringr)
library(dplyr)
library(ggplot2)

myanimelist_manga <- read.csv("myanimelist/manga.csv")
myanimelist_anime <- read.csv("myanimelist/anime.csv")
bestsellingmanga <- read.csv("best-selling-manga.csv")

head(bestsellingmanga, 1)
colnames(bestsellingmanga)
nrow(bestsellingmanga)
```



