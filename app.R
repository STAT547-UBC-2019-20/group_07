# 07-Apr-2020
# This code defines the main Dashboard based on DashR

# For better formatting of the layouts we import
# and use Bootstrap css (only the css, no JavaScripts)

# More information on Bootstrap and its various components:
# https://getbootstrap.com/docs/4.0/getting-started/introduction/
#
# You can find information about the css classes used in this Dashboard
# here: https://www.w3schools.com/bootstrap4/bootstrap_ref_all_classes.asp
#

# Load various R libraries quietly
suppressPackageStartupMessages(library(dash))
suppressPackageStartupMessages(library(dashCoreComponents))
suppressPackageStartupMessages(library(dashHtmlComponents))
suppressPackageStartupMessages(library(plotly))
suppressPackageStartupMessages(library(here))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(wordcloud))
suppressPackageStartupMessages(library(dplyr))

title <- "Dashboard - Books at Project Gutenberg"

# color scheme
colors <- list (bg.color = "#eae9ee", p2.color = "#ffc110", tl.color = "#ffc104",
                c1.color = "#765903", c2.color = "#a57b02", c3.color = "#d29c01",
                c4.color = "#fdbd09", c5.color = "#faca2a", c6.color = "#04c2f0",
                c7.color = "#00a2fc")

# Markdown
md <- dccMarkdown("
                  The purpose of this dashboard is to explore the

                  selection of books available in [Project Gutenberg](https://www.gutenberg.org). 
                  Specifically, we are examining the structural and semantic attributes 
                  of the books by _popularity_.
                  
                  To use our dashboard, use the slider to select a group of 200 books 
                  by decreasing popularity. Then, you can see 
                  statistics of semantic (in amber) and thematic (in blue) variables
                  of the selected group of books. You will also see the
                  most common subjects in the books selected by either a 
   bar chart or a word cloud.
                  ")

## Read in raw data
bookFull <- read.csv(here("Data","classics_clean.csv"))
bookWC <- read.csv(here("Data","classics_word_cloud.csv"))

# Create the dashboard app and load the Bootstrap's css
app <- Dash$new(
  external_stylesheets = "https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css")

app$title(title)

# This components uses the 'Card' css classes defined by bootstrap 

# More info: https://getbootstrap.com/docs/4.0/components/card/
make_struct_cards <- function(maxRank = 1, minRank = 1006){
  w <- "330px"
  tempBook <- bookFull %>% filter(rank >= maxRank & rank <= minRank)
  
  # Average birth year of the Author Card
  avg.auth.birth <- round(mean(tempBook[tempBook$author.birth > 0, "author.birth"], na.rm = TRUE))
  card.year <- htmlDiv(
    htmlDiv(
      list(

        htmlLabel("Author's Birth", className = "text-white"),

        htmlH6(avg.auth.birth, className = "text-white")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", style = list(width = w, 
                                                  backgroundColor=colors$c1.color, height = "120px") 

  )
  
  avg.length <- round(mean(tempBook[tempBook$sentences > 0,"sentences"], na.rm = TRUE))
  
  card.num <- htmlDiv(
    htmlDiv(
      list(

        htmlP("Avg Sentences", className = "text-white"),

        htmlH6(format(avg.length,big.mark = ","), className = "text-white text-bold")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", style = list(width = w,

                                                  backgroundColor=colors$c2.color, height = "120px")
  )
  
  avg.words <- round(mean(tempBook[tempBook$words > 0 ,"words"], na.rm = TRUE))
  card.words <- htmlDiv(
    htmlDiv(
      list(

        htmlP("Avg Words", className = "text-white"),

        htmlH6(format(avg.words,big.mark = ","), className = "text-white text-bold")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", style = list(width = w,

                                                  backgroundColor=colors$c3.color, height = "120px")
  )
  
  avg.dfclt.words <- round(mean(tempBook[tempBook$difficult.words > 0 ,"difficult.words"], na.rm = TRUE))
  card.dfclt.words <- htmlDiv(
    htmlDiv(
      list(

        htmlP("Difficult Words", className = "text-white"),

        htmlH6(format(avg.dfclt.words,big.mark = ","), className = "text-white text-bold")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", style = list(width = w, 

                                                  backgroundColor=colors$c4.color, height = "120px")
  )
  
  avg.rdbl <- round(mean(tempBook[tempBook$automated.readability.index > 0,
                                  "automated.readability.index"], na.rm = TRUE))
  card.rdbl <- htmlDiv(
    htmlDiv(
      list(

        htmlP("Readability", className = "text-white"),

        htmlH6(avg.rdbl, className = "text-white text-bold")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", style = list(width = w, 

                                                  backgroundColor=colors$c5.color, height = "120px")
  )
  
  # Average subjectivity
  avg.subj <- 100 * mean(tempBook[tempBook$subjectivity > 0, "subjectivity"], na.rm = TRUE)
  avg.subj.perc <- sprintf("%.1f %%", avg.subj)
  card.subj <- htmlDiv(
    htmlDiv(
      list(

        htmlP("Subjectivity", className = "text-white"),

        htmlH6(avg.subj.perc, className = "text-white")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", 
    style = list(width = w, backgroundColor=colors$c6.color,height = "120px") 

  )
  
  # Average polarity
  avg.polar <- 100 * mean(tempBook[tempBook$polarity > 0,"polarity"], na.rm = TRUE)
  avg.polar.perc <- sprintf("%.1f %%", avg.polar)
  card.polar <- htmlDiv(
    htmlDiv(
      list(

        htmlP("Polarity", className = "text-white"),

        htmlH6(avg.polar.perc, className = "text-white text-bold")
      )
      ,className = "card-body"
    )

    ,className = "card text-center", style = list(width = w, 

                                                  backgroundColor=colors$c7.color, height = "120px")
  )
  
  return (htmlDiv(

    list(card.year, 
         card.num, 
         card.words, 
         card.dfclt.words,
         card.rdbl,
         card.subj, 

         card.polar)
    ,className = "row"))
}

# Make word cloud plot
make_plot1 <- function(maxRank = 1, minRank = 1006){
  ## Calculate n occurences for each subject
  ## Remove fiction

  subjectCounts <- 
    as.data.frame(
      table(
        bookWC %>% 
          filter(! str_detect(Desc, "Fiction")) %>%
          filter(Rank >= maxRank & Rank <= minRank) %>% 
          pull(Desc))) %>% 
    mutate(Size = scale(Freq)) %>% 
    arrange(desc(Freq))
  
  ## Calculate plotting positions 
  plot_pos <- subjectCounts %>% 

    slice(1:15) %>%  # Only plot top 15 words/subject
    mutate(x = sample(-90:90, 15, replace = TRUE),
           y = sample(-90:90, 15, replace = TRUE))
  

  plot1 <- plot_pos %>% 
    ggplot(aes(x = x, y = y, label = Var1)) +
    geom_text(aes(size = Size + 5), show.legend = FALSE) +
    theme_classic() +
    theme(axis.line = element_blank(), axis.title = element_blank(), 

  
  ggplotly(plot1)
}

# Make bar graph plot
make_plot2 <- function(maxRank = 1, minRank = 1006){
  ## Calculate n occurences for each subject
  ## Remove fiction
  subjectCounts <- as.data.frame(

    table(bookWC %>% 
            filter(! str_detect(Desc, "Fiction")) %>%
            filter(Rank >= maxRank & Rank <= minRank) %>% 
            pull(Desc))
  )
  
  plot2 <- subjectCounts %>% 
    arrange(desc(Freq)) %>% 
    slice(1:20) %>%
    ggplot(aes(x = reorder(Var1, Freq), y = Freq )) + 
    geom_col(show.legend = FALSE) + 
    coord_flip() +
    xlab(NULL) +
    ylab("Frequency") + 
    ggtitle(paste0("Most Common Subject Matter for Books Ranked ", maxRank, " to ", minRank)) +
    theme_classic() 

  ggplotly(plot2,  height = 400)
}

# Create the graphs
tab <- dccTabs(id = "tabs", children = list(
  dccTab(label = "Popular Subject Bar Graph", children = list(
    dccGraph(id='barchart', figure = make_plot2(), style = list("width" = "100%")))),
  dccTab(label = "Popular Subject Word Cloud", children = list(
    dccGraph(id='wordCloudPlot', figure = make_plot1(), style = list("width" = "100%"))))
))

slider <- htmlDiv(
  list(
    htmlH4(id="slider-title-id"),
    htmlSup("(Drag the slider to change)", className = "text-muted"),
    dccRangeSlider(
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

    )), className = "mx-auto text-center", 

)

app$layout(
  htmlDiv(
    list(
      htmlDiv(style = list(height = "35px")),
      
      htmlDiv(
        list(
          htmlH2(title),
          htmlHr(),
          md

        ), 
        className = "mx-auto jumbotron text-center shadow-lg p-3 mb-5 rounded",  
        style = list(width="90%", color = "white", backgroundColor = colors$tl.color)), 

      htmlDiv(
        list(
          slider,
          htmlDiv(
            htmlDiv(id="struct-cards-id"),
            className = "card-deck p-3"
          ),

          htmlDiv(tab, className = "well p-3 mb-5", 
                  style = list(backgroundColor = colors$p2.color))
        ), 
        className = "mx-auto jumbotron text-center shadow-lg p-3 mb-5 bg-white rounded", 

        style = list(width="90%"))
    ), className = "container-fluid", style = list(backgroundColor = colors$bg.color)
  ))

app$callback(
  output=list(id = 'wordCloudPlot', property = 'figure'),
  params=list(input(id = 'popSlider', property='value')),
  function(popSlider) {
    make_plot1(maxRank = popSlider[1], minRank = popSlider[2])
  })

app$callback(
  output=list(id = 'barchart', property = 'figure'),
  params=list(input(id = 'popSlider', property='value')),
  function(popSlider) {
    make_plot2(maxRank = popSlider[1], minRank = popSlider[2])
  })

app$callback(
  output=list(id = 'struct-cards-id', property = 'children'),
  params=list(input(id = 'popSlider', property='value')),
  function(popSlider) {
    make_struct_cards(maxRank = popSlider[1], minRank = popSlider[2])
  })

app$callback(
  output=list(id = 'slider-title-id', property = 'children'),
  params=list(input(id = 'popSlider', property='value')),
  function(popSlider) {
    return (sprintf("Selected Popularity Range: %s - %s", popSlider[1], popSlider[2]))
  }
)


app$run_server(host = '0.0.0.0', port = Sys.getenv('PORT', 8050))

