"Script to knit the final report.
Usage: knit.R --final_report=<report> --report_dir=<report_dir>" -> doc

# load packages
suppressMessages(library(docopt))
suppressMessages(library(rmarkdown))
suppressMessages(library(glue))
suppressMessages(library(bookdown))
suppressMessages(library(here))

opt <- docopt(doc)

#' @author Denitsa Vasileva & Lucy Mosquera
#' @param report path to the final report

knit_report <- function(report, report_dir){
  # check that the report file we want to knit exists 
  if(!file.exists(report)) {
    stop(glue("Report file {report} not found"))
  }
  # check that the output location exists
  if (! dir.exists(here(report_dir))){
    stop(glue("Report output directory: {report_dir} not found"))
  }
  # knit report file
  rmarkdown::render(report, c("bookdown::pdf_document2", "bookdown::html_document2"), 
                    output_dir = here(report_dir))
  # print completion statement
  print("Rmarkdown file knit successfully!")
}


knit_report(report = opt$final_report, report_dir = opt$report_dir)