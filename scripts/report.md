---
title: "Final Report (milestone_03)"
author: "Denitsa Vasileva & Lucy Mosquera"
date: '2020-03-15'
output:
  bookdown::html_document2:
    keep_md: true
    toc: true

---






# Introduction

## Motivation 

Project Gutenberg is a free online source which provides free access to more than 60,000 books- mostly classics @project_gutenberg. Its purpose is to crete digital copies of books in the public domain and thus make them more accessible and foster a love of reading to new generations of readers. The Gutenberg project stores troves of information about each available book- including both metadata about the author and work itself as well as popularity, difficulty and readibility metrics for each book.

## Research Questions

1. Explore the changes in the prevalent sentiments and subjects in books in Project Gutenberg change based on publication year?
2. Explore the changes in the prevalent sentiments and subjects in books in Project Gutenberg change based on author gender, location,etc.?
3. Explore what characteristics are associated with an increase in a book's popularity for download on Project Gutenberg. Potential variables to include are publication year, length, formats the book is available in, subject matter, and reading difficulty.


# Exploratory Data Analysis




## What are the names of the columns (i.e. the variables we can use in our analysis)?

The variables have the following names:

congress.classifications, languages, subjects, title, type, downloads, id, rank, url, author.birth, author.death, author.name, publication.day, publication.full, publication.month, publication.month.name, publication.year, formats.total, formats.types, automated.readability.index, coleman.liau.index, dale.chall.readability.score, difficult.words, flesch.kincaid.grade, flesch.reading.ease, gunning.fog, linsear.write.formula, smog.index, polarity, subjectivity, average.letter.per.word, average.sentence.length, average.sentence.per.word, characters, polysyllables, sentences, syllables, words, language.en, language.de, language.es, language.fr, language.it, language.la, language.nl, language.pt, language.ru, language.tl

## What is the distribution of years of publication for the books in Project Gutenberg?

Figure \@ref(fig:histPubDate) shows the publication dates for the 1006 books present in the Project Guttenberg dataset. From this figure we can see that there are some older books, and then a large cluster of books from the 2000's.

<div class="figure">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/publication_dates.png" alt="Histogram of publication year for all books on Project Guttenberg." width="50%" />
<p class="caption">(\#fig:histPubDate)Histogram of publication year for all books on Project Guttenberg.</p>
</div>

## What are the correlations between key variables of reading difficulty and text structure? 

<div class="figure">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/correlogram.png" alt="Correlogram of the correlation between key variables" width="50%" />
<p class="caption">(\#fig:correlogram)Correlogram of the correlation between key variables</p>
</div>

## What is the relationship between year of publication and reading difficulty as measured by the automatic readability index?

<div class="figure">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/publication_readibility.png" alt="Scatter plot of readability difficulty vs publication year." width="50%" />
<p class="caption">(\#fig:yearReadability)Scatter plot of readability difficulty vs publication year.</p>
</div>

The graph does not show any significant difference in the level of difficulty in books based on 
Publication Year.

## Sentiment Analysis

<div class="figure">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/sentiment_analysis.png" alt="Scatterplot of sentiment vs publication year" width="50%" />
<p class="caption">(\#fig:sentimentYear)Scatterplot of sentiment vs publication year</p>
</div>

Provided in the Project Gutenberg data is a sentiment polarity score that aims to quantify the positivity or negativity of a work in general. 
This plot does not show a relationship between publication year and sentiment polarity.


# Analysis
In order to answer our research questions, we used linear regression.
To answer the first question, we implemented a linear regression model on the sentimentality index of each book compared to the publication year.We also used linear regression to examine the correlation between the 
popularity of a book (i.e. number of times it has been downloaded) and the year of publication.


# Results
The linear model of the year of publication vs the sentimentality index for 
each book.

```r
model<-readRDS(here("data","tidy_model.rds"))

print(model)
```

```
## # A tibble: 2 x 5
##   term                   estimate std.error statistic    p.value
##   <chr>                     <dbl>     <dbl>     <dbl>      <dbl>
## 1 (Intercept)            0.331    0.0719         4.60 0.00000483
## 2 data$publication.year -0.000115 0.0000360     -3.20 0.00143
```
The table above  shows the parameters of the linear regression model:

The linear regression plot can be seen below:

<div class="figure">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/year_polarity.png" alt="Scatterplot of year vs polarity." width="50%" />
<p class="caption">(\#fig:polarityYear)Scatterplot of year vs polarity.</p>
</div>




Linear Model for the 

# Discussion and Conclusions

