# author: Lucy Mosquera & Denitsa Vasileva
# date: 2020-03-23

"This script is the main file that creates a Dash app.

Usage: app.R
"

# Libraries

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(plotly)
library(here)
library(purrr)

app <- Dash$new()

md <- dccMarkdown("

**Welcome to our Dashboard**! 

The purpose of this dashboard is to explore the
selection of books available in **Project Gutenberg**. Specifically, we are 
examining the semantic and thematic attributes of the books by _popularity_.
You can visit the **Project Gutenberg** website [here](https://www.gutenberg.org). 

** Usage **

To use our dashboard, use the slider to select 
a group of books by popularity. Then you can see 
statistics and plots of the semantic and thematic variables
of the selected plots.
                             ")

book.data <- read.csv(here("Data","classics_clean.csv"))

book.data<-book.data %>%
  mutate(popularity=ifelse(rank %in% 1:200,"Highly Popular",ifelse(rank 
                                                                   %in% 201:400,"Popular", ifelse(rank %in% 401:600, "Somewhat Popular",ifelse(rank %in% 601:800,"Not  Very Popular",ifelse(rank %in% 801:1006, "Not Popular", "Does Not Exist"))))))


book.data$popularity<-as.factor(book.data$popularity)
levels_rank<- levels(book.data$popularity)
slider_values<-seq_along(levels_rank)
slider_labels<- map(levels_rank, function(x) x)
names(slider_labels)<-slider_values




slider<-dccSlider(id="my-slider",
                  min = 1,
                  max = 1006,
                  step = 200,
                  marks= list('200'='Highly Popular','400'='Popular','600'='Somewhat Popular','800'='Not Very Popular','1006'='Not Popular'),
                  value=200
)

popularity_data<- unique(book.data$popularity)
yaxisKey <- tibble(label = (unique(popularity_data)),
                   value = (unique(popularity_data)))
yaxisDropdown<-dccDropdown( id = "popularity",
                            options = map(
                              1:nrow(yaxisKey), function(i){
                                list(label=yaxisKey$label[i], value=yaxisKey$value[i])
                              }),
                            value = "popularity")



app$layout(
	htmlDiv(
		list(
			htmlH1(children="Project Gutenberg Book Analysis"),md,slider,yaxisDropdown
		)
	)
)

app$run_server(debug=TRUE)
