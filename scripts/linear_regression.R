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
Usage: linear_regression.R  
"-> doc

linear_regression<- function(){
  # Read-in cleaned data file
  data<- read.csv(here("data","classics_clean.csv"))
  model<- lm(data$polarity ~ data$publication.year)
  data %>%
    ggplot(aes(x= publication.year,y=polarity))+geom_smooth(method = "lm")+  theme_bw() + geom_point()+
    xlab("Publication Year") +
    ylab("Polarity") 
    ggsave(file= here("images","year_polarity.pdf"))
    saveRDS(tidy(model), file = here("data","tidy_model.rds"))
    saveRDS(augment(model), file=here("data","augment_model.rds") )
    saveRDS(glance(model), file=here("data","glance_model.rds") )
}
linear_regression()

