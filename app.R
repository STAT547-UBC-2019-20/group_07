# author: Lucy Mosquera & Denitsa Vasileva
# date: 2020-03-23

"This script is the main file that creates a Dash app.

Usage: app.R
"

# Load libraries quietly
suppressPackageStartupMessages(library(dash))
suppressPackageStartupMessages(library(dashCoreComponents))
suppressPackageStartupMessages(library(dashHtmlComponents))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(here))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(wordcloud))

# Initialize new app
app <- Dash$new()

# App Description Text
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

## Read in raw data
bookFull <- read.csv(here("Data","classics_clean.csv"))
bookWC <- read.csv(here("Data","classics_word_cloud.csv"))

## Set up slider to select popularity range
## Default selects all books, pushable ensures min of 10 books selected at a time
slider <- dccRangeSlider(
	id='popSlider',
	min=1,
	max=1006,
	step=1,
	value=list(1, 1006),
	pushable = 10, 
	marks = list(
		"1" = list("label" = "#1"),
		"100" = list("label" = "#100"),
		"200" = list("label" = "#200"),
		"300" = list("label" = "#300"),
		"400" = list("label" = "#400"),
		"500" = list("label" = "#500"),
		"600" = list("label" = "#600"),
		"700" = list("label" = "#700"),
		"800" = list("label" = "#800"),
		"900" = list("label" = "#900"),
		"1000" = list("label" = "#1000"))
)

# Make word cloud plot
make_plot1 <- function(maxRank = 1, minRank = 1006){
	## Calculate n occurences for each subject
	## Remove fiction
	subjectCounts <- as.data.frame(table(bookWC %>% filter(! str_detect(Desc, "Fiction")) %>%
																			 	filter(Rank >= maxRank & Rank <= minRank) %>% 
																			 	pull(Desc))) %>% 
		mutate(Size = scale(Freq))
	## Calculate plotting positions
	plot_pos <- as.data.frame(wordlayout(x = sample(-70:70, 20, replace = TRUE), 
																			 y = sample(-70:70, 20, replace = TRUE), 
																			 words = as.character(subjectCounts$Var1[1:20]),
																			 xlim = c(-100, 100), ylim = c(-100,100),
																			 rotate90 = FALSE, cex = subjectCounts$Size + 10)) %>% 
		tibble::rownames_to_column("Label") %>% 
		left_join(subjectCounts, by = c("Label" = "Var1"))
	
	plot1 <- plot_pos %>% 
		ggplot() +
		aes(x = x, y = y, label = Label) +
		geom_text(aes(size = Size + 5), show.legend = FALSE) +
		xlim(-100, 100) + 
		ylim(-100, 100) + 
		theme_classic()
	ggplotly(plot1)
}

# Make bar graph plot
make_plot2 <- function(maxRank = 1, minRank = 1006){
	## Calculate n occurences for each subject
	## Remove fiction
	subjectCounts <- as.data.frame(table(bookWC %>% filter(! str_detect(Desc, "Fiction")) %>%
																			 	filter(Rank >= maxRank & Rank <= minRank) %>% 
																			 	pull(Desc)))
	
	plot2 <- subjectCounts %>% 
		arrange(desc(Freq)) %>% 
		slice(1:20) %>%
		ggplot(aes(x = reorder(Var1, Freq), y = Freq, fill = reorder(Var1, Freq))) +
		geom_col(show.legend = FALSE) + 
		coord_flip() +
		xlab("") +
		ylab("Frequency") + 
		scale_colour_gradientn(colours = rainbow(20)) +
		theme_classic() 
	ggplotly(plot2, width = 1000, height = 400)
}

make_text <- function(maxRank = 1, minRank = 1006){
	tempBook <- bookFull %>% filter(rank <= minRank & rank >= maxRank)
	aveAuthBirth <- round(mean(tempBook$author.birth, na.rm = TRUE), 0)
	aveSentences <- round(mean(tempBook$sentences, na.rm = TRUE), 0)
	aveWord <- round(mean(tempBook$words, na.rm = TRUE), 0)
	aveDiffWords <- round(mean(tempBook$difficult.words, na.rm = TRUE), 0)
	aveReadability <- round(mean(tempBook$automated.readability.index, na.rm = TRUE), 0)
	aveSubjectivity <- round(mean(tempBook$subjectivity, na.rm = TRUE), 2)
	avePolarity <- round(mean(tempBook$polarity, na.rm = TRUE), 2)
	
	return(list(htmlP(paste0("Displaying results for books ranked from ", maxRank, " to ", minRank,
								" on Project Guttenberg.")),
							htmlStrong("*Structural Details*"),
							htmlP(paste0("Average year of author birth: ", aveAuthBirth)),
							htmlP(paste0("Average number of sentences: ", aveSentences)),
							htmlP(paste0("Average number of words: ", aveWord)),
							htmlP(paste0("Average number of difficult words: ", aveDiffWords)),
							htmlP(paste0("Average readability: ", aveReadability)),
							htmlStrong("Thematic Details"),
							htmlP(paste0("Average subjectivity: ", aveSubjectivity)),
							htmlP(paste0("Average polarity: ", avePolarity)),
							htmlP("       "),
							htmlP("       "),
							htmlP("       "),
							htmlP("       ")))
}


# app$layout(
# 	htmlDiv(
# 		list(
# 			htmlH1(children="Project Gutenberg Book Analysis"),
# 			md,
# 			slider,
# 			htmlDiv(list(
# 				htmlH1(children = "TESTINGGGG"),
# 				dccTabs(id = "tabs", children = list(
# 					dccTab(label = "Bar-Chart", children = list(
# 						htmlLabel("Bar chart of themes"),
# 						dccGraph(id='barchart', figure = make_plot2())
# 					)),
# 					dccTab(label = "Word-Cloud", children = list(
# 						htmlLabel("Word cloud of themes"),
# 						dccMarkdown('Please select the clarity of diamonds to view:')
# 						), style = list("width" = "70%"))
# 					))
# 			), style = list('columnCount'=2, 'width' = "100%",
# 											'display'='flex'))
# 			)
# 	))

app$layout(
	htmlDiv(
		list(
			htmlH1(children="Project Gutenberg Book Analysis"),
			md,
			slider,
			htmlH3(children = "Summary of Selected Books:"),
			htmlDiv(list(
				htmlDiv(id = "summaryInfo"),
				dccGraph(id='barchart', figure = make_plot2(), style = list("width" = "100%"))),
				style = list("columnCount" = 2, 'display' = 'flex'))),
		style = list("flex-wrap" = "nowrap"))
	)


app$callback(
	#update summary info
	output=list(id = 'wordCloudPlot', property = 'figure'),
	#based on popularity values selected
	params=list(input(id = 'popSlider', property='value')),
	#this translates your list of params into function arguments
	function(popSlider) {
		make_plot1(maxRank = popSlider[1], minRank = popSlider[2])
	})

app$callback(
	#update summary info
	output=list(id = 'barchart', property = 'figure'),
	#based on popularity values selected
	params=list(input(id = 'popSlider', property='value')),
	#this translates your list of params into function arguments
	function(popSlider) {
		make_plot2(maxRank = popSlider[1], minRank = popSlider[2])
	})

app$callback(
	#update summary info
	output=list(id = 'summaryInfo', property = 'children'),
	#based on popularity values selected
	params=list(input(id = 'popSlider', property='value')),
	#this translates your list of params into function arguments
	function(popSlider) {
		make_text(maxRank = popSlider[1], minRank = popSlider[2])
	})

app$run_server(debug=TRUE)
