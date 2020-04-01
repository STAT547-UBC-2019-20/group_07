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
examining the structural and semantic attributes of the books by _popularity_.
You can visit the **Project Gutenberg** website [here](https://www.gutenberg.org). 

To use our dashboard, use the slider to select 
a group of 200 books by decreasing popularity. Then,on the
left hand side, the user can see 
statistics of semantic and thematic variables
of the selected group of books. In the center, the user can see the
most common subjects in the books selected by either a 
bar chart or a word cloud (by selecting the appropriate tab).
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
	pushable = 15, 
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
		mutate(Size = scale(Freq)) %>% 
		arrange(desc(Freq))
	## Calculate plotting positions ** NEEDS IMPROVEMENT TO PREVENT OVERLAP **
	plot_pos <- subjectCounts %>% 
		slice(1:15) %>%  # Only plot top 15 words/subject
		mutate(x = sample(-70:70, 15, replace = FALSE),
					 y = sample(-20:20, 15, replace = FALSE))
	
	plot1 <- plot_pos %>% 
		ggplot(aes(x = x, y = y, label = Var1)) +
		geom_text(aes(size = Size + 5), show.legend = FALSE) +
		xlim(-100, 100) +
		ylim(-40, 40) +
		theme_classic() +
		theme(axis.line = element_blank(), axis.title = element_blank(), 
					axis.text = element_blank(), axis.ticks = element_blank())
	
	ggplotly(plot1, width = 1000, height = 400)
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
		ggtitle(paste0("Most Common Subject Matter for Books Ranked ", maxRank, " to ", minRank)) +
		scale_colour_gradientn(colours = rainbow(20)) +
		guides(colours = FALSE) + 
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
	
	return(list(htmlP(paste0("Displaying results for books ranked from #", maxRank, " to #", minRank,
								" on Project Guttenberg.")),
							htmlStrong("Structural Details"),
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
			htmlDiv(list(
				htmlDiv(list(
					htmlH3(children = "Summary of Selected Books:"),
					htmlDiv(id = "summaryInfo"))),
				dccTabs(id = "tabs", children = list(
					dccTab(label = "Popular Subject Bar Graph", children = list(
						dccGraph(id='barchart', figure = make_plot2(), style = list("width" = "100%")))),
					dccTab(label = "Popular Subject Word Cloud", children = list(
						dccGraph(id='wordCloudPlot', figure = make_plot1(), style = list("width" = "100%"))))
					))),
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
