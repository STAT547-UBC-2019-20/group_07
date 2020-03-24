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

app <- Dash$new()

app$layout(
	htmlDiv(
		list(
			htmlH1(children="Project Gutenberg Book Analysis")
		)
	)
)

app$run_server(debug=TRUE)
