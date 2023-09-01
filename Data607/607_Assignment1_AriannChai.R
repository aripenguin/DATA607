library(readr)
wwc_matches <- read_csv("Data607/womens-world-cup-2019/wwc_matches.csv")
View(wwc_matches)

wwc_columns <- subset(wwc_matches, select=c(1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20))
wwc_columns$prob1<-100*wwc_columns$prob1
wwc_columns$prob2<-100*wwc_columns$prob2
wwc_columns$probtie<-100*wwc_columns$probtie
wwc_columns$team1 = substr(wwc_columns$team1, 1, nchar(wwc_columns$team1)-5)
wwc_columns$team2 = substr(wwc_columns$team2, 1, nchar(wwc_columns$team2)-5)
colnames(wwc_columns)[1]="game date"
colnames(wwc_columns)[5]="team1’s soccer power index rating"
colnames(wwc_columns)[6]="team2s soccer power index rating"
colnames(wwc_columns)[7]="team1’s win probability"
colnames(wwc_columns)[8]="team2’s win probability"
colnames(wwc_columns)[9]="tie probability"
colnames(wwc_columns)[10]="team1’s projected goals"
colnames(wwc_columns)[11]="team2’s projected goals"
colnames(wwc_columns)[12]="team1’s final score"
colnames(wwc_columns)[13]="team2’s final score"
colnames(wwc_columns)[14]="team1’s shot expected goals"
colnames(wwc_columns)[15]="team2's shot expected goals"
colnames(wwc_columns)[16]="team2's non-shot expected goals"
colnames(wwc_columns)[17]="team2's non-shot expected goals"
colnames(wwc_columns)[18]="team1's adjusted scores"
colnames(wwc_columns)[19]="team2's adjusted scores"

View(wwc_columns)

