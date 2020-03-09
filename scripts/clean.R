### Data Cleaning ###

#Loading packages 
suppressMessages(library(tidyr))
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(docopt))
suppressMessages(library(glue))
suppressMessages(library(roxygen2))
suppressMessages(library(RCurl))
suppressMessages(library(here))

"This script cleans the data necessary for our project
Usage: clean.R --raw_file_path=<raw_file_path> --clean_file_path=<clean_file_path>
"-> doc

#' @author Denitsa Vasileva
#' @param file_path  file path of raw file
#' @param filename file name for new file to be saved

# Loading command line arguments 
opt <- docopt(doc)

clean <- function(raw_file_path, clean_file_path){
  # check if the file provided by the file_path argument exists
  if (!file.exists(here(raw_file_path))) {
    print(glue("The file {raw_file_path} is invalid"))
  }else{
    data<-read.csv(here(raw_file_path))
    # Renaming a column
    colnames(data)[1]<-"Bibliography Congress Classification"
    # Removing unnecessary columns
    data <- data[-(19)]
    write.csv(data, row.names=FALSE, here(clean_file_path))
    print (glue("File {clean_file_path} successfully written"))
  }
}
clean(raw_file_path = opt$raw_file_path, clean_file_path = opt$clean_file_path)