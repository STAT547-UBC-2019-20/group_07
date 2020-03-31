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
book.data <- read.csv(here("Data","classics_clean.csv"))



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




app$layout(
	htmlDiv(
		list(
			htmlH1(children="Project Gutenberg Book Analysis"),
			md,
			slider,
			htmlDiv(list(
				md,
				dccTabs(id = "tabs", children = list(
					dccTab(label = "Word-Cloud", children = list(
						htmlLabel("Word cloud of themes"),
					  dccMarkdown('Please select the clarity of diamonds to view:')
						)),
					dccTab(label = "Bar-Chart", children = list(
						htmlLabel("Bar chart of themes"),
						dccMarkdown('Please select the clarity of diamonds to view:')
						))
					))
			), style = list('columnCount'=2,
											'display'='flex'))
			)
	))


app$callback(
	#update summary info
	output=list(id = 'histogram', property = 'figure'),
	#based on values diamond clarity from drop down
	params=list(input(id = 'popSlider', property='value')),
	#this translates your list of params into function arguments
	function(popSlider) {
		make_plot1(dataSubset = histSubset, scale = yaxisType)
	})

app$run_server(debug=TRUE)
