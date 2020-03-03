---
title: "Project Gutenberg Classic Books Analysis"
author: "Denitsa Vasileva, Lucy "
date: '2020-03-02'
output:
  html_document:
   keep_md: true
---



# Introduction 

Project Gutenberg is a free online source which provides free access to more than 60,000
books- mostly classics. Its purpose is to crete digital copies of books in the public domain and
thus make them more accessible and foster a love of reading to new generations of readers.
The Gutenberg project stores troves of information about each available book- including both metadata
about the author and work itself as well as popularity, difficulty and readibility metrics for each book.

# Data Set

The data set which will be used in this project can be downloaded [here](https://corgis-edu.github.io/corgis/csv/classics/?fbclid=IwAR0u9jexVHzWWvP65r7sKXYw8VvKiih80BQIzPVu8HjcpsXwjxVN9n5jCeE).
The rows represent books vailable through Project Gutenberg and the columns are attributes
of these books- e.g. meta data and popularity metrics.

# Exploratory Data Analysis

## Loading File


```r
books_data<- read.csv ("classics.csv")
```


## How many observations do we have?


```r
dim(books_data)
```

```
## [1] 1006   38
```
 This shows that in the data there are 38 variables avilable for 1006 books. 
 
## How many misisng values?


```r
summary(is.na(books_data))
```

```
##  bibliography.congress.classifications bibliography.languages
##  Mode :logical                         Mode :logical         
##  FALSE:1005                            FALSE:1006            
##  TRUE :1                                                     
##  bibliography.subjects bibliography.title bibliography.type
##  Mode :logical         Mode :logical      Mode :logical    
##  FALSE:1006            FALSE:1006         FALSE:1006       
##                                                            
##  metadata.downloads metadata.id     metadata.rank   metadata.url   
##  Mode :logical      Mode :logical   Mode :logical   Mode :logical  
##  FALSE:1006         FALSE:1006      FALSE:1006      FALSE:1006     
##                                                                    
##  bibliography.author.birth bibliography.author.death
##  Mode :logical             Mode :logical            
##  FALSE:1006                FALSE:1006               
##                                                     
##  bibliography.author.name bibliography.publication.day
##  Mode :logical            Mode :logical               
##  FALSE:1006               FALSE:1006                  
##                                                       
##  bibliography.publication.full bibliography.publication.month
##  Mode :logical                 Mode :logical                 
##  FALSE:1006                    FALSE:1006                    
##                                                              
##  bibliography.publication.month.name bibliography.publication.year
##  Mode :logical                       Mode :logical                
##  FALSE:1006                          FALSE:1006                   
##                                                                   
##  metadata.formats.total metadata.formats.types
##  Mode :logical          Mode :logical         
##  FALSE:1006             FALSE:1006            
##                                               
##  metrics.difficulty.automated.readability.index
##  Mode :logical                                 
##  FALSE:1006                                    
##                                                
##  metrics.difficulty.coleman.liau.index
##  Mode :logical                        
##  FALSE:1006                           
##                                       
##  metrics.difficulty.dale.chall.readability.score
##  Mode :logical                                  
##  FALSE:1006                                     
##                                                 
##  metrics.difficulty.difficult.words
##  Mode :logical                     
##  FALSE:1006                        
##                                    
##  metrics.difficulty.flesch.kincaid.grade
##  Mode :logical                          
##  FALSE:1006                             
##                                         
##  metrics.difficulty.flesch.reading.ease metrics.difficulty.gunning.fog
##  Mode :logical                          Mode :logical                 
##  FALSE:1006                             FALSE:1006                    
##                                                                       
##  metrics.difficulty.linsear.write.formula metrics.difficulty.smog.index
##  Mode :logical                            Mode :logical                
##  FALSE:1006                               FALSE:1006                   
##                                                                        
##  metrics.sentiments.polarity metrics.sentiments.subjectivity
##  Mode :logical               Mode :logical                  
##  FALSE:1006                  FALSE:1006                     
##                                                             
##  metrics.statistics.average.letter.per.word
##  Mode :logical                             
##  FALSE:1006                                
##                                            
##  metrics.statistics.average.sentence.length
##  Mode :logical                             
##  FALSE:1006                                
##                                            
##  metrics.statistics.average.sentence.per.word
##  Mode :logical                               
##  FALSE:1006                                  
##                                              
##  metrics.statistics.characters metrics.statistics.polysyllables
##  Mode :logical                 Mode :logical                   
##  FALSE:1006                    FALSE:1006                      
##                                                                
##  metrics.statistics.sentences metrics.statistics.syllables
##  Mode :logical                Mode :logical               
##  FALSE:1006                   FALSE:1006                  
##                                                           
##  metrics.statistics.words
##  Mode :logical           
##  FALSE:1006              
## 
```

## What are the names of the columns (i.e. the vriables we can use in our analysis)?


```r
colnames(books_data)
```

```
##  [1] "bibliography.congress.classifications"          
##  [2] "bibliography.languages"                         
##  [3] "bibliography.subjects"                          
##  [4] "bibliography.title"                             
##  [5] "bibliography.type"                              
##  [6] "metadata.downloads"                             
##  [7] "metadata.id"                                    
##  [8] "metadata.rank"                                  
##  [9] "metadata.url"                                   
## [10] "bibliography.author.birth"                      
## [11] "bibliography.author.death"                      
## [12] "bibliography.author.name"                       
## [13] "bibliography.publication.day"                   
## [14] "bibliography.publication.full"                  
## [15] "bibliography.publication.month"                 
## [16] "bibliography.publication.month.name"            
## [17] "bibliography.publication.year"                  
## [18] "metadata.formats.total"                         
## [19] "metadata.formats.types"                         
## [20] "metrics.difficulty.automated.readability.index" 
## [21] "metrics.difficulty.coleman.liau.index"          
## [22] "metrics.difficulty.dale.chall.readability.score"
## [23] "metrics.difficulty.difficult.words"             
## [24] "metrics.difficulty.flesch.kincaid.grade"        
## [25] "metrics.difficulty.flesch.reading.ease"         
## [26] "metrics.difficulty.gunning.fog"                 
## [27] "metrics.difficulty.linsear.write.formula"       
## [28] "metrics.difficulty.smog.index"                  
## [29] "metrics.sentiments.polarity"                    
## [30] "metrics.sentiments.subjectivity"                
## [31] "metrics.statistics.average.letter.per.word"     
## [32] "metrics.statistics.average.sentence.length"     
## [33] "metrics.statistics.average.sentence.per.word"   
## [34] "metrics.statistics.characters"                  
## [35] "metrics.statistics.polysyllables"               
## [36] "metrics.statistics.sentences"                   
## [37] "metrics.statistics.syllables"                   
## [38] "metrics.statistics.words"
```

## What is the relationship between year of publication and reading difficulty as measured by the automatic readibility index?

```r
books_data %>%
  ggplot() +aes (bibliography.publication.year, metrics.difficulty.automated.readability.index) +geom_point() +ggtitle("Plot of Publication Year vs Readbility Difficulty")
```

![](Milestone1_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

The graph does not show any significant difference in the level of difficulty in books based on 
Publication Year.


## What is the relationship between country of publication and average sentence length? Has the average gotten longer or shorter over time?

```r
books_data %>%
  ggplot() +aes (bibliography.publication.year, metrics.statistics.average.sentence.length) +geom_point() +ggtitle("Plot of Publication Year vs Sentence Length")
```

![](Milestone1_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

The graph does not show any significant difference in the average length of sentences in books based on 
Publication Year.

## Sentiment Analysis

```r
books_data %>%
  ggplot() +aes (bibliography.publication.year, metrics.sentiments.polarity) +geom_point() +ggtitle("Plot of Publication Year vs Sentiment Polarity")
```

![](Milestone1_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

# Research Question

1. How do the prevalent sentiments and subjects in books in Project Gutenberg change based on publication year?


# Futre Analysis
