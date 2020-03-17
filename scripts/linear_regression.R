### Linear Regression Analysis ###

#Loading packages 
suppressMessages(library(tidyr))
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(docopt))
suppressMessages(library(glue))
suppressMessages(library(roxygen2))
suppressMessages(library(RCurl))
suppressMessages(library(readr))
suppressMessages(library(broom))
suppressMessages(library(here))

"This script performs linear regression
Usage: linear_regression.R --clean_data_path=<clean_data_path> --output_path_image=<output_path_image> --output_path_model=<output_path_model>
"-> doc

# Loading command line arguments 
opt <- docopt(doc)

linear_regression<- function(clean_data_path, output_path_image, output_path_model){
  runModel <- TRUE
  # Read-in cleaned data file
  if (file.exists(here(clean_data_path))){
    data <- read.csv(here(clean_data_path))
  } 
  else{
    print(glue("Invalid clean data path: {clean_data_path}"))
    runModel <- FALSE
  } 
  if (! dir.exists(here(output_path_model))){ 
    # check if output_path_model exists 
    print(glue("Invalid model directory path: {output_path_model}"))
    runModel <- FALSE
  } 
  if (! dir.exists(here(output_path_image))){ 
    # check if output_path_image exists 
    print(glue("Invalid image directory path: {output_path_image}"))
    runModel <- FALSE
  } 
  if (runModel){
    ## Linear regression of polarity (positivity of the work) vs. publication year
    model<- lm(data$polarity ~ data$publication.year)
    
    ## Plot of the regression line
    data %>%
      ggplot(aes(x = publication.year, y = polarity)) + 
        geom_smooth(method = "lm") +
        theme_bw() + 
        geom_point() +
        xlab("Publication Year") +
        ylab("Polarity") 
    ggsave(file= here(output_path_image,"year_polarity.pdf"))
    
    ## Save the various model forms
    saveRDS(tidy(model), file = here(output_path_model,"tidy_model.rds"))
    saveRDS(augment(model), file=here(output_path_model,"augment_model.rds") )
    saveRDS(glance(model), file=here(output_path_model,"glance_model.rds") )
    
    ## Print completion message 
    print("Linear regression run successfully!")
  }
}
linear_regression(clean_data_path = opt$clean_data_path, 
                  output_path_image = opt$output_path_image, 
                  output_path_model = opt$output_path_model)

