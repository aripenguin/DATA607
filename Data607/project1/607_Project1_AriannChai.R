#Project: Create an R Markdown file that generates a .CSV file
library(stringr)

#read txt file 
txt_data <- read.delim("Data607/Project1/tournamentinfo.txt")
txt_data
typeof(txt_data)
txt_data[-(1:3),]

txt_data <- paste(readLines("Data607/Project1/tournamentinfo.txt"))
txt_data

#Find Player’s Name - need to get names with more than 2 words
player_names <- str_extract(txt_data, "\\| [A-Z]+ +[A-Z]+ ")
player_names <-player_names[!is.na(player_names)]
player_names <- str_extract(player_names, "[A-Z]+ +[A-Z]+")
#remove the id name
player_names <- player_names[ !player_names == 'USCF ID']
player_names
length(player_names)

#player_names redone to get names w/ 3+ words
player_names <- str_extract(txt_data, "\\| [A-Z]+(.)+[A-Z]+     ")
player_names <-player_names[!is.na(player_names)]
player_names <- str_extract(player_names, "[A-Z]+(.)+[A-Z]+")
player_names <- player_names[ !player_names == 'USCF ID']
player_names
length(player_names)

#Find Player’s State
player_states <- str_extract(txt_data, "[A-Z][A-Z] \\|")
player_states <-player_states[!is.na(player_states)]
player_states <- str_extract(player_states, "[A-Z][A-Z]")
player_states
length(player_states)

#Find Total Number of Points
points_total <- str_extract(txt_data, "\\|[0-9].[0-9]")
points_total <-points_total[!is.na(points_total)]
points_total <- str_extract(points_total, "[0-9].[0-9]")
points_total
length(points_total)

#Find Player’s Pre-Rating
player_prerating <- str_extract(txt_data, ("R: +[0-9][0-9][0-9]+"))
player_prerating <-player_prerating[!is.na(player_prerating)]
player_prerating <- str_extract(player_prerating, "[0-9][0-9][0-9]+")
player_prerating
length(player_prerating)

#Find Average Pre Chess Rating of Opponents
opponents_prerating <- str_extract(txt_data, ("\\|[L,W,D] +[0-9]+\\|"))
#([L,W,D] optional #)*7+\\|
opponents_prerating <-opponents_prerating[!is.na(opponents_prerating)]
#get it like |W  39|W  21|W  18|W  14|W   7|D  12|D   4|
#edit to 39,21,18,14,7,12,4
opponents_prerating
length(opponents_prerating)

#tests
str_detect("|W  39|W  21|W  18|W  14|W   7|", "\\|[W]+[0-9]")
str_detect("|W  39|W  39", "(\\|[W]+ +[0-9])\\1")
str_detect("|L 27|W 3|W 13|", "(\\|[W]+ +[0-9]+).*\\|")
str_extract("|W 73|W 3|W 3|", "(\\|[W]+ +[0-9]+).*\\|")
str_detect("|L ", "\\|[L,W] ")
str_extract("|W 3|W 3|W 3|", "(\\|[W]+ +[0-9]).*\\|")

#get it like |W  39|W  21|W  18|W  14|W   7|D  12|D   4|
opponents_prerating <- str_extract(txt_data, ("(\\|[L,W,D]+ +[0-9]+).*\\|"))
opponents_prerating <- opponents_prerating[!is.na(opponents_prerating)]
opponents_prerating
#edit character to 39 21 18 14 7 12 4
opponents_prerating <- str_extract_all(opponents_prerating,"[0-9]+")
opponents_prerating

#match up numbers - use player_prerating and positions []
#make vector to hold data
avg_opponents_prerating <- vector(length=length(opponents_prerating))
#2 for loops: i through opponents_preratings, j through the each character 
for (i in 1:length(opponents_prerating)){
  opponents_num <- 0 #for # of opponents
  scores_combined <- 0 #for opponents' scores
  #print(opponents_prerating[i])
  for (j in opponents_prerating[[i]]){
    opponents_num <- opponents_num+1
    #print(j[1])#works!
    scores_combined <- scores_combined+as.numeric(player_prerating[as.numeric(j[1])])
  }
  avg_opponents_prerating[i] <- scores_combined/opponents_num
  print(opponents_prerating[i])
  print(x)
}
avg_opponents_prerating <- round(avg_opponents_prerating, 0)
avg_opponents_prerating
length(avg_opponents_prerating)


#turn txt into a dataframe into a csv

#5 columns: Player’s Name, Player’s State, Total Number of Points, Player’s Pre-Rating, & Average Pre Chess Rating of Opponents
#make dataframe with the 5 vectors
csv_data <- data.frame(player_names,player_states,points_total,player_prerating,avg_opponents_prerating)
#rename the 5 vectors
colnames(csv_data)[1]="Player’s Name"
colnames(csv_data)[2]="Player’s State"
colnames(csv_data)[3]="Total Number of Points"
colnames(csv_data)[4]="Player’s Pre-Rating"
colnames(csv_data)[5]="Average Pre Chess Rating of Opponents"

csv_data
#write.csv("tournamentinfo.csv")
library(readr)
write_csv(csv_data, "Data607/Project1/tournamentinfo.csv")

