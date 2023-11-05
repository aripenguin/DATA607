library(dplyr)
library(httr)
library(jsonlite)
library(stringr)
library(ggplot2)

#web api
apiKey <- "hSndMn20mNAgN0TcTP20NOY4Xc01dtuP"



#url for searching
term <- "Queen"
subsection <- "Europe"
begin_date <- "20220908"
end_date <- "20221231"

searchUrl <- paste0("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=",term,
                    "&fq=subsection_name:",subsection,
                    "&begin_date=",begin_date,
                    "&end_date=",end_date,
                    "&facet_filter=true&api-key=",apiKey, 
                    sep="")
searchQuery <- fromJSON(searchUrl)
searchQuery

maxPages <- round((searchQuery$response$meta$hits[1] / 10)-1) 
maxPages
pages <- vector("list",length=maxPages)
pages
for(i in 0:maxPages){
  nytSearch <- fromJSON(paste0(searchUrl, "&page=", i), flatten = TRUE) %>% data.frame()
  pages[[i+1]] <- nytSearch
  Sys.sleep(5)
}
articles <- rbind_pages(pages)
articles

#fix colnames
colnames(articles)
colnames(articles) <- str_replace(colnames(articles),pattern='response.docs\\.',replace='')
colnames(articles) <- str_replace(colnames(articles),pattern='response\\.',replace='')
colnames(articles)
articles

queenArticles<-as.data.frame(articles)

#columns to keep: copyright, web_url,pub_date,type_of_material,word_count,headline.main,byline.original
queenArticles <- subset(queenArticles, select=c(2,4,12,16,18,21,28))
colnames(queenArticles)[3]="publish_date"
colnames(queenArticles)[4]="type_of_article"
colnames(queenArticles)[6]="headline"
colnames(queenArticles)[7]="original_author"
queenArticles






http://api.nytimes.com/svc/search/v2/articlesearch.json?q=queen&subsection_name=Europe&begin_date=20220908&end_date=20221231&facet_filter=true&api-key=hSndMn20mNAgN0TcTP20NOY4Xc01dtuP
