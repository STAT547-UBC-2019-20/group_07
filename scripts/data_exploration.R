##### Exploratory Data Analysis #####

#Loading packages 
suppressMessages(library(tidyr))
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(docopt))
suppressMessages(library(glue))
suppressMessages(library(roxygen2))
suppressMessages(library(RCurl))
suppressMessages(library(here))
suppressMessages(library(corrplot))

"This script loads the data necessary for our project
Usage: clean.R --image_path=<save_images_here> --data_path=<data_path>
"-> doc

# Loading command line arguments 
opt <- docopt(doc)

exploratory <- function(image_path, data_path){
  # check if path exists 
  if (!dir.exists(here(image_path))){
    print(glue("Invalid directory{image_path}"))
  }else{
  books_data <- read.csv(here(data_path))
  
  # creating the first plot - a scatter plot of Publication Date vs Readability Difficulty
  books_data %>%
    ggplot(aes(bibliography.publication.year, metrics.difficulty.automated.readability.index)) +
    geom_point() + 
    xlab("Publication Date")+
    ylab("Readability Difficult")+
    ggtitle("Plot of Publication Year vs Readability Difficulty")
    ggsave("publication_readibility.png",path=image_path)
    
    # creating second plot - a histogram of publication dates
  books_data %>%
    ggplot(aes(bibliography.publication.year))+
      geom_histogram(bins = 10) +
    ggtitle("Histogram of Distribution of Publication Dates of Books of Books")
    ggsave("publication_dates.png",path=image_path)
    
    # creating third scatter plot- sentiment analysis plot of plublication year 
    # vs sentiment polarity
    books_data %>%
      ggplot(aes(bibliography.publication.year, metrics.sentiments.polarity)) +
      xlab("Publication Year")+
      ylab("Sentiment Polarity")+
      geom_point() + 
      ggtitle("Plot of Publication Year vs Sentiment Polarity")
    ggsave("sentiment_analysis.png", path=image_path)
    
    # creating fourth plot- correlation plot of key continuous variables
    
    books_cor <- books_data %>%
      select(bibliography.author.birth, metrics.difficulty.automated.readability.index, 
             metrics.difficulty.coleman.liau.index, metrics.difficulty.dale.chall.readability.score, 
             metrics.difficulty.difficult.words, metrics.difficulty.flesch.kincaid.grade, 
             metrics.difficulty.flesch.reading.ease, metrics.statistics.average.letter.per.word, 
             metrics.statistics.average.sentence.length, metrics.statistics.average.sentence.per.word, 
             metrics.statistics.characters, metrics.statistics.syllables, metrics.statistics.words) %>% 
      cor(.) %>% 
      round(., 4)
    
    books_cor %>% 
      corrplot(., type="upper", 
               method="color", 
               tl.srt=45,
               addCoef.col = "black",
               diag = FALSE)
      xlab("Publication Year")+
      ylab("Sentiment Polarity")+
      geom_point() + 
      ggtitle("Plot of Publication Year vs Sentiment Polarity")
    ggsave("sentiment_analysis.png", path=image_path)
    print(glue("Three plots have been successfully created in {image_path}"))
}
}
exploratory(image_path = opt$image_path, data_path_opt$data_path)