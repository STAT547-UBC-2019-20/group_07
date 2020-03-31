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

#' @author Denitsa Vasileva & Lucy Mosquera
#' @param raw_file_path  file path of raw file
#' @param clean_file_path file name for new file to be saved

# Loading command line arguments 
opt <- docopt(doc)

clean <- function(raw_file_path, clean_file_path){
  # check if the file provided by the file_path argument exists
  if (!file.exists(here(raw_file_path))) {
    print(glue("The file {raw_file_path} is invalid"))
  }else{
    book_data <- read.csv(here(raw_file_path))
    # Renaming a columns to remove the "bibliography.", "metrics.statistics",
    # "metrics.difficulty", "metadata", and "metrics.sentiments" prefixes
    clean_data <- book_data %>% 
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
    write.csv(clean_data, row.names=FALSE, here(clean_file_path, "classics_clean.csv"))
    # Prepare data for app
    #Reshaping data for word cloud, want key value pairs of rank and then each descriptor as a single row
    booksWDesc <- book_data %>% filter(! is.na(subjects))
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
    write.csv(longDesc, row.names=FALSE, here(clean_file_path, "classics_word_cloud.csv"))
    
    print(glue("Files successfully written to {clean_file_path}"))
  }
}
clean(raw_file_path = opt$raw_file_path, clean_file_path = opt$clean_file_path)