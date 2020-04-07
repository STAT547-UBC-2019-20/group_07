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


# Great color schemes from: https://www.canva.com/colors/color-meanings/amber/
title <- "Dashboard - Books at Project Guttenberg"

# Markdown
md <- dccMarkdown("
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

app <- Dash$new()

# I could not figure out better way to add <style> tag
# app$index_string is copied from the help ?app. I just
# added <style> tag
# (I did not want to add more files than the core app.R)
# I also loaded some pre-defined classes from the bootstrap framework.
# A useful link that helped to develop the layout:
# https://www.w3schools.com/bootstrap/bootstrap_templates.asp

app$index_string(
  "<!DOCTYPE html>
  <html lang=\"en\">
  <head>
  {%meta_tags%}
  <title>
  {%favicon%}
  {%css_tags%}
  </title>
  <style>
  body 
  .row.content {height: 1500px}
  </style>
  <link 
      rel=\"stylesheet\" 
      href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css\" 
      integrity=\"sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh\" 
      crossorigin=\"anonymous\">
  </head>
  <body>
  {%app_entry%}
  <footer>
  {%config%}
  {%scripts%}
  </footer>
  </body>
  </html>"
)

app$title(title)


make_struct_cards <- function(maxRank = 1, minRank = 1006){
  w <- "300px"
  tempBook <- bookFull %>% filter(rank >= maxRank & rank <= minRank)
  
  # Average birth year of the Author Card
  avg.auth.birth <- round(mean(tempBook[tempBook$author.birth > 0, "author.birth"], na.rm = TRUE))
  card.year <- htmlDiv(
    htmlDiv(
       list(
        htmlLabel("Average Year of Author's Birth", className = "text-white"),
        #htmlLabel("year of author's birth", className = "text-white"),
        htmlH4(avg.auth.birth, className = "text-white")
       )
      ,className = "card-body"
    )
    ,className = "card text-center", style = list(width = w, backgroundColor="#755800", height = "120px") 
  )

  avg.length <- round(mean(tempBook[tempBook$sentences > 0,"sentences"], na.rm = TRUE))
        
  card.num <- htmlDiv(
    htmlDiv(
      list(
        htmlP("Average Sentences", className = "text-white"),
      #  htmlP("Sentences in book", className = "text-white"),
        htmlH4(avg.length, className = "text-white text-bold")
      )
      ,className = "card-body"
    )
    ,className = "card text-center", style = list(width = w, backgroundColor="#a37a00", height = "120px")
  )
  
  avg.words <- round(mean(tempBook[tempBook$words > 0 ,"words"], na.rm = TRUE))
  card.words <- htmlDiv(
    htmlDiv(
      list(
        htmlP("Average Words", className = "text-white"),
       # htmlP("Words in book", className = "text-white"),
        htmlH4(avg.words, className = "text-white text-bold")
      )
      ,className = "card-body"
    )
    ,className = "card text-center", style = list(width = w, backgroundColor="#d19d00", height = "120px")
  )
  
  avg.dfclt.words <- round(mean(tempBook[tempBook$difficult.words > 0 ,"difficult.words"], na.rm = TRUE))
  card.dfclt.words <- htmlDiv(
    htmlDiv(
      list(
        htmlP("Average Difficult Words", className = "text-white"),
        #htmlP("Difficult words", className = "text-white"),
        htmlH4(avg.dfclt.words, className = "text-white text-bold")
      )
      ,className = "card-body"
    )
    ,className = "card text-center", style = list(width = w, backgroundColor="#ffbf00", height = "120px")
  )
  
  avg.rdbl <- round(mean(tempBook[tempBook$automated.readability.index > 0 ,"automated.readability.index"], na.rm = TRUE))
  card.rdbl <- htmlDiv(
    htmlDiv(
      list(
        htmlP("Average Readability", className = "text-white"),
        #htmlP("Readability", className = "text-white"),
        htmlH4(avg.rdbl, className = "text-white text-bold")
      )
      ,className = "card-body"
    )
    ,className = "card text-center", style = list(width = w, backgroundColor="#ffcb2e", height = "120px")
  )
  
  # Average subjectivity
  avg.subj <- 100 * mean(tempBook[tempBook$subjectivity > 0, "subjectivity"], na.rm = TRUE)
  avg.subj.perc <- sprintf("%.1f %%", avg.subj)
  card.subj <- htmlDiv(
    htmlDiv(
      list(
        htmlP("Average Subjectivity", className = "text-white"),
        #htmlP("Subjectivity", className = "text-white"),
        htmlH4(avg.subj.perc, className = "text-white")
      )
      ,className = "card-body"
    )
    ,className = "card text-center", 
    style = list(width = w, backgroundColor="#00bfff",height = "120px") 
  )
  
  # Average polarity
  avg.polar <- 100 * mean(tempBook[tempBook$polarity > 0,"polarity"], na.rm = TRUE)
  avg.polar.perc <- sprintf("%.1f %%", avg.polar)
  card.polar <- htmlDiv(
    htmlDiv(
      list(
        htmlP("Average Polarity", className = "text-white"),
        #htmlP("Polarity", className = "text-white"),
        htmlH4(avg.polar.perc, className = "text-white text-bold")
      )
      ,className = "card-body"
    )
    ,className = "card text-center", style = list(width = w, backgroundColor="#00a7ff", height = "120px")
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
    ggplot(aes(x = reorder(Var1, Freq), y = Freq )) + #, fill = reorder(Var1, Freq))) +
    geom_col(show.legend = FALSE) + 
    coord_flip() +
    xlab(NULL) +
    ylab("Frequency") + 
    ggtitle(paste0("Most Common Subject Matter for Books Ranked ", maxRank, " to ", minRank)) +
    theme_classic() +
    scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9"))
  ggplotly(plot2,  height = 400)
}

tab <- dccTabs(id = "tabs", children = list(
  dccTab(label = "Popular Subject Bar Graph", children = list(
    dccGraph(id='barchart', figure = make_plot2(), style = list("width" = "100%")))),
  dccTab(label = "Popular Subject Word Cloud", children = list(
    dccGraph(id='wordCloudPlot', figure = make_plot1(), style = list("width" = "100%"))))
))

slider <- htmlDiv(
  list(
     htmlP("Select Popularity Range"),
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
                      style = list(width="60%")
  
)

app$layout(
  htmlDiv(
    list(
          htmlDiv("", style = list(height = "40px")),
          
          htmlDiv(
            list(
              htmlH2(title),
              htmlHr(),
              md
            ), 
            className = "mx-auto jumbotron text-center shadow-lg p-3 mb-5 rounded",  
            style = list(width="90%", color = "white", backgroundColor = "#ffbf00")), 
          htmlDiv(
            list(
              slider,
              htmlDiv(
                htmlDiv(id="struct-cards-id"),
                className = "card-deck p-3"
              ),
              htmlDiv(style = list(height="40px")),
              htmlDiv(tab, className = "well p-3 mb-5", style = list(backgroundColor = "#ffbf00"))
            ), 
            className = "mx-auto jumbotron text-center shadow-lg p-3 mb-5 bg-white rounded", 
            style = list(width="90%"))
          
  ), className = "container-fluid", style = list(backgroundColor = "#E9EAEC")
))
  
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
  output=list(id = 'struct-cards-id', property = 'children'),
  #based on popularity values selected
  params=list(input(id = 'popSlider', property='value')),
  #this translates your list of params into function arguments
  function(popSlider) {
    make_struct_cards(maxRank = popSlider[1], minRank = popSlider[2])
  })


app$run_server(debug=TRUE)
