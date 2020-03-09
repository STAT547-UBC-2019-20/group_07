################################ Loading data ###########################

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
Usage: load_data.R --data_url=<data_url>
"-> doc

opt <- docopt(doc)

#data url = https://corgis-edu.github.io/corgis/datasets/csv/classics/classics.csv

#' @author Denitsa Vasileva
#' @param  data_url data URL

load_data<- function(data_url){
  # checking if url is valid
  if (!url.exists(data_url)){
    print ("URL does not exist")
  }else{
    # Loading the data from the URL into the dataframe data 
    url<- getURL(data_url)
    data<-read.csv(text=url, header=TRUE)
    # Writing the data as a csv file
    write.csv(data,row.names=FALSE, here("data","classics_raw_data.csv"))
  print ( "Data has been successfully loaded in the Data directory")}
}

load_data(opt$data_url)