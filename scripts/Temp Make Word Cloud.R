#Load Data
books <- read.csv(choose.files())

#Load Packages
library(dplyr)
library(stringr)
library(wordcloud)
library(ggplot2)

#Reshaping data for word cloud, want key value pairs of rank and then each descriptor as a single row
booksWDesc <- books %>% filter(! is.na(subjects))
longList <- apply(booksWDesc , MARGIN = 1, function(x){
	rankVal <- x[["rank"]]
	tempDesc <- trimws(unlist(strsplit(trimws(unlist(strsplit(as.character(x[["subjects"]]), "--"))),
											 ";")))
	tempDesc <- unique(tempDesc)
	desc <- as.vector(sapply(tempDesc, function(x){
		if (substr(x, start = 1, stop = 7) == "Fiction"){
			if (stringr::str_length(x) == 7){
				x } else {substr(x, start = 9, stop = stringr::str_length(x))}
			} else (x)
		}))
	data.frame("Rank" = rep(rankVal, length(desc)),
						 "Desc" = desc)
	})

longDesc <- dplyr::bind_rows(longList)

## Here is where the call to subset based on rank will be needed

## Calculate n occurences for each subject
## Remove fiction (optional?)
subjectCounts <- as.data.frame(table(longDesc %>% filter(! str_detect(Desc, "Fiction")) %>% 
																		 	pull(Desc)))

wordcloud(words = subjectCounts$Var1, freq = subjectCounts$Freq, min.freq = 3,
					max.words=50, random.order=FALSE, rot.per=0.35, 
					colors=brewer.pal(8, "Dark2"))

