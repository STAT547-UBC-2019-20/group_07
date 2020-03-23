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

- a b c 
- d e 

## What is the distribution of years of publication for the books in Project Gutenberg?

<div class="figure" style="text-align: center">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/publication_dates.png" alt="Histogram of publication year for all books on Project Guttenberg." width="40%" />
<p class="caption">(\#fig:histPubDate)Histogram of publication year for all books on Project Guttenberg.</p>
</div>

Figure \@ref(fig:histPubDate) shows the publication dates for the 1006 books present in the Project Guttenberg dataset. From this figure we can see that there are some older books, and then a large cluster of books from the 2000's.

## What are the correlations between key variables of reading difficulty and text structure? 

<div class="figure" style="text-align: center">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/correlogram.png" alt="Correlogram of the correlation between key variables" width="40%" />
<p class="caption">(\#fig:correlogram)Correlogram of the correlation between key variables</p>
</div>

Figure \@ref(fig:correlogram) shows the correlation between different key variables that describe the books as well as characterize their difficulty using metrics. In this figure we can see that there fairly high positive correlation between the number of words, number of characters, number of syllables, and number of hard words in a book as well as between the average sentence length, automated readability index, and Flesch Kincaid grade. There are also reasonably strong negative correlations between average sentence length, automated readability index, Flesch Kincaid grade and the average number of sentences per word and the Flesch reading ease index.

## What is the relationship between year of publication and reading difficulty as measured by the automatic readability index?

<div class="figure" style="text-align: center">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/publication_readibility.png" alt="Scatter plot of readability difficulty vs publication year." width="40%" />
<p class="caption">(\#fig:yearReadability)Scatter plot of readability difficulty vs publication year.</p>
</div>

Figure \@ref(fig:yearReadability) plots the readability score against the year of publication. This graph does not show any significant difference in the level of difficulty in books based on Publication Year.

## Sentiment Analysis

<div class="figure" style="text-align: center">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/sentiment_analysis.png" alt="Scatterplot of sentiment vs publication year" width="40%" />
<p class="caption">(\#fig:sentimentYear)Scatterplot of sentiment vs publication year</p>
</div>

Provided in the Project Gutenberg data is a sentiment polarity score that aims to quantify the positivity or negativity of a work in general. Figure \@ref(fig:sentimentYear) shows these sentiment scores against the publication year. This plot does not show a relationship between publication year and sentiment polarity.

# Analysis
In order to answer our research questions, we used linear regression.

To answer the first question, we implemented a linear regression model on the sentimentality index of each book compared to the publication year. 

# Results

The results of the linear model of the year of publication vs the sentimentality index for each book can be seen in Table \@ref(tab:modelOutput).


Table: (\#tab:modelOutput)Coefficient estimates, standard error, test statistics, and p-value for linear regression of year of publication predicting sentiment index values using the Project Guttenberg data.

term                       estimate   std.error   statistic     p.value
----------------------  -----------  ----------  ----------  ----------
(Intercept)               0.3307099   0.0719379    4.597159   0.0000048
data$publication.year    -0.0001151   0.0000360   -3.197866   0.0014278

The scatter plot of sentimentality index vs year with the resulting linear regression superimposed can be seen in Figure \@ref(fig:polarityYear).

<div class="figure" style="text-align: center">
<img src="C:/Users/hp/Documents/STAT547M/group_07/images/year_polarity.png" alt="Scatterplot of year vs polarity." width="50%" />
<p class="caption">(\#fig:polarityYear)Scatterplot of year vs polarity.</p>
</div>

This regression shows tha t the publication year is a significant predictor of the sentimentality index (p value = 0.0014). The coefficient for the publication year is a negative value, indicating that newer books are more negative in their general sentiment than older books (coeff = 10^{-4}), although the magnitude of this coefficient is quite small indicating a small but significant effect.

# Discussion and Conclusions

Throughout this analysis we have explored the Project Guttenberg classics dataset and gained valuable insights. We have shown that the sentiment or overall tone of newer books is marginally more negative than older books. 
