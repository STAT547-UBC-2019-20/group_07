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
    # Renaming a columns to remove the "bibliography.", "metrics.statistics",
    # "metrics.difficulty", "metadata", and "metrics.sentiments" prefixes
    data <- data %>% 
      rename_at(.vars = vars(starts_with("bibliography.")),
                .funs = ~ sub("bibliography.", "", .)) %>% 
      rename_at(.vars = vars(starts_with("metrics.statistics.")),
                .funs = ~ sub("metrics.statistics.", "", .)) %>% 
      rename_at(.vars = vars(starts_with("metrics.difficulty.")),
                .funs = ~ sub("metrics.difficulty.", "", .)) %>% 
      rename_at(.vars = vars(starts_with("metadata.")),
                .funs =  ~ sub("metadata.", "", .)) %>% 
      rename_at(.vars = vars(starts_with("metrics.sentiments.")),
                .funs = ~ sub("metrics.sentiments.", "", .)) %>% 
    # Re-code language so it is a set of binary indicator variables
      mutate(language.en = if_else(languages %in% c("en", "en, enm", "en, es", "enm"), 1, 0),
             language.de = if_else(languages %in% c("de"), 1, 0),
             language.es = if_else(languages %in% c("en,es", "es"), 1, 0),
             language.fr = if_else(languages == "fr", 1, 0),
             language.it = if_else(languages == "it", 1, 0),
             language.la = if_else(languages == "la", 1, 0),
             language.nl = if_else(languages == "nl", 1, 0),
             language.pt = if_else(languages == "pt", 1, 0),
             language.ru = if_else(languages == "ru", 1, 0),
             language.tl = if_else(languages == "tl", 1, 0)
             )
    write.csv(data, row.names=FALSE, here(clean_file_path))
    print (glue("File {clean_file_path} successfully written"))
  }
}
clean(raw_file_path = opt$raw_file_path, clean_file_path = opt$clean_file_path)