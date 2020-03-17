"Script to knit the final report.
Usage: knit.R --final_report=<report>" -> doc

# laod packages
library(docopt)
library(rmarkdown)
library(glue)
library(bookdown)

opt <- docopt(doc)

#' @author Denitsa Vasileva & Lucy Mosquera
#' @param report path to the final report

knit_report <- function(report){
  # check that the report file we want to knit exists 
  if(!file.exists(report)) {
    stop(glue("Report file {report} not found"))
  }
  # knit reprot file
  rmarkdown::render(report, c("bookdown::pdf_document2"))
}


knit_report(opt$final_report)