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

"This script loads the data necessary for our project
Usage: clean.R --file_path=<raw_file_path> --filename=<clean_file_path>
"-> doc

#' @author Denitsa Vasileva
#' @param file_path  file path of raw file
#' @param filename file name for new file to be saved

# Loading command line arguments 
opt <- docopt(doc)

clean <- function(file_path ,filename ){
  # check if the file provided by the file_path argument exists
  if (!file.exists(file_path)) {
    print(glue("The file {file_path} is invalid"))
  }else{
    data<-read.csv(file_path)
    # Renaming a column
    colnames(data)[1]<-"Bibliography Congress Classification"
    # Removing unnecessary columns
    data<- data[-(19)]
    write.csv(data,row.names=FALSE,  here("data", filename))
    print (glue("File {filename} Successfully written"))
  }
}
clean(opt$file_path,opt$filename)