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
suppressMessages(library(ggcorrplot))

"This script loads the data necessary for our project
Usage: data_exploration.R --image_path=<image_path> --data_path=<data_path>
"-> doc

#' @author Denitsa Vasileva & Lucy Mosquera
#' @param image_path  file path of where to save the images
#' @param data_path file name for dataset to be plotted

# Loading command line arguments 
opt <- docopt(doc)

exploratory <- function(image_path, data_path){
  # check if path exists 
  if (!dir.exists(here(image_path))){
    print(glue("Invalid image directory path: {image_path}"))
  }else if (! file.exists(here(data_path))){
    print(glue("Invalid data path: {data_path}"))
  } else{
    books_data <- read.csv(here(data_path))
    
    # creating the first plot - a scatter plot of Publication Date vs Readability Difficulty
    books_data %>%
      ggplot(aes(publication.year, automated.readability.index)) +
      geom_point() + 
      xlab("Publication Date")+
      ylab("Readability Difficult")+
      ggtitle("Plot of Publication Year vs Readability Difficulty")
    
    ggsave("publication_readibility.png", path = here(image_path), plot = last_plot())
    
    # creating second plot - a histogram of publication dates
    books_data %>%
      ggplot(aes(publication.year))+
        geom_histogram(bins = 10) +
        ggtitle("Histogram of Distribution of Publication Dates of Books of Books")
    
    ggsave("publication_dates.png", path = here(image_path), plot = last_plot())
    
    # creating third scatter plot- sentiment analysis plot of plublication year 
    # vs sentiment polarity
    books_data %>%
      ggplot(aes(publication.year, polarity)) +
      xlab("Publication Year")+
      ylab("Sentiment Polarity")+
      geom_point() + 
      ggtitle("Plot of Publication Year vs Sentiment Polarity")
    
    ggsave("sentiment_analysis.png", path = here(image_path), plot = last_plot())
    
    # creating fourth plot- correlation plot of key continuous variables
    books_cor <- books_data %>%
      select(author.birth, automated.readability.index, coleman.liau.index, dale.chall.readability.score, 
             difficult.words, flesch.kincaid.grade, flesch.reading.ease, average.letter.per.word, 
             average.sentence.length, average.sentence.per.word, characters, syllables, words) %>% 
      cor(.) %>% 
      round(., 4)
    
    books_cor %>% 
      ggcorrplot(., hc.order = TRUE) +
      ggtitle("Correlations Betweeen Key \nContinuous Variables")
    ggsave("correlogram.png", path = here(image_path), plot = last_plot())
    print(glue("Four plots have been successfully created in {image_path}"))
}
}
exploratory(image_path = opt$image_path, data_path = opt$data_path)