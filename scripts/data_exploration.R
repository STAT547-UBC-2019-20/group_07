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

"This script loads the data necessary for our project
Usage: clean.R --image_path=<save_images_here>
"-> doc

# Loading command line arguments 
opt <- docopt(doc)

exploratory <- function(image_path){
  # check if path exists 
  if (!dir.exists(image_path)){
    print(glue("Invalid directory{image_path}"))
  }else{
  books_data <- read.csv(here("Data", "classics.csv"))
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
    ggsave("sentiment_analysis.png",path=image_path)
    print (glue(" Three plots have been successfully created in {image_path}"))
}
}
exploratory(opt$image_path)