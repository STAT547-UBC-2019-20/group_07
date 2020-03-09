# Exploratory Data Analysis


library(tidyverse)
library(corrplot)
library(here)
## Loading Data File
books_data <- read.csv(here("Data", "classics.csv"))

## How many observations do we have?
dim(books_data)

## What are the names of the columns (i.e. the variables we can use in our analysis)?
colnames(books_data)

## What is the relationship between year of publication and reading difficulty as measured by the automatic readability index?
books_data %>%
  ggplot(aes(bibliography.publication.year, metrics.difficulty.automated.readability.index)) +
  geom_point() + 
  ggtitle("Plot of Publication Year vs Readability Difficulty")


## What is the relationship between average sentence length over time? Has the average gotten longer or shorter over time?
books_data %>%
  ggplot(aes(bibliography.publication.year, metrics.statistics.average.sentence.length)) +
  geom_point() +
  facet_wrap(vars())
ggtitle("Plot of Publication Year vs Sentence Length")


## Sentiment Analysis
books_data %>%
  ggplot(aes(bibliography.publication.year, metrics.sentiments.polarity)) +
  geom_point() + 
  ggtitle("Plot of Publication Year vs Sentiment Polarity")

