"Script to knit the final report.
Usage: knit.R --final_report=<report>" -> doc

# load packages
suppressMessages(library(docopt))
suppressMessages(library(rmarkdown))
suppressMessages(library(glue))
suppressMessages(library(bookdown))

opt <- docopt(doc)

#' @author Denitsa Vasileva & Lucy Mosquera
#' @param report path to the final report

knit_report <- function(report){
  # check that the report file we want to knit exists 
  if(!file.exists(report)) {
    stop(glue("Report file {report} not found"))
  }
  # knit report file
  rmarkdown::render(report, c("bookdown::pdf_document2", "bookdown::html_document2"))
  # print completion statement
  print("Rmarkdown file knit successfully!")
}


knit_report(opt$final_report)