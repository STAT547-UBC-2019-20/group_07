# Group 7

## Group Members:
  * Denitsa Vasileva
  * Lucy Mosquera
  
## Project Description:

The purpose of this project is to explore the dataset found [here](https://corgis-edu.github.io/corgis/datasets/csv/classics/classics.csv). 
This data set was obtained from Project Gutenberg- an online free book repository
and contains different - meta, author, sentimentality analysis, etc.- information 
about more than 1000 books. The most recent version of our report is available [here](https://github.com/STAT547-UBC-2019-20/group_07/blob/master/docs/report.md).

## Usage for Command Line:

1. Clone this repo. https://github.com/STAT547-UBC-2019-20/group_07.git

2. Ensure the following packages are installed:

  - ggplot2
  - dplyr
  - RCurl
  - here
  - glue
  - docopt
  - roxygen2
  - tidyr
  - ggcorrplot
  - readr
  - knitr
  - broom 
  - stringr
  - wordcloud

3. Run the following scripts (in order) with the appropriate arguments specified:

  ### Download data
  ```
  Rscript scripts/load_data.R --data_url="https://corgis-edu.github.io/corgis/datasets/csv/classics/classics.csv"
  ```
  
  ### Wrangle/clean/process your data 
  ```
  Rscript scripts/clean.R --raw_file_path="data/classics_raw_data.csv" --clean_file_path="data/"
  ```
  
  ### EDA script to export images
  ```
  Rscript scripts/data_exploration.R --image_path="images" --data_path="data/classics_clean.csv"  
  ```
  
  ### Linear regression
  ```
  RScript scripts/linear_regression.R --clean_data_path="data/classics_clean.csv" --output_path_image="images" --output_path_model="data"
  ```
  
  ### Knit your draft final report
  ```
  Rscript scripts/knit.R --final_report="scripts/report.RMD" --report_dir="docs"
  ```

## Usage for GNU Make

1. Clone this repo. https://github.com/STAT547-UBC-2019-20/group_07.git

2. Ensure the following packages are installed:

  - ggplot2
  - dplyr
  - RCurl
  - here
  - glue
  - docopt
  - roxygen2
  - tidyr
  - ggcorrplot
  - readr
  - knitr
  - broom 
  - stringr
  - wordcloud
  
 3. To run the analysis in its entirety, run the following in the command line
 
 ```
 make all
 ```
 
 4. To delete the outputs of the analysis run
 ```
 make clean 
 ```

## Dashboard Proposal

### Description

The purpose of our dashboard is to explore the books within the Project Gutenberg repository.  The man question we seek to answer is what makes some books on the Gutenberg project more popular than others.
At the top of the landing page there is a slider for the user to interact with to restrict the number of books included in a particular search based on popularity. The slider goes from the most popular book (#1) to the least popular book (#1006) providing summary results for 20 books at a time - in order of popularity. Alternatively, users can use a select all option to see the summary for the entire database. The default is that the first twenty most popular books are analyzed first (ranked books 1-20).
Below the slider, there are two columns of different properties of books. The first column represents semantic properties such as sentence length while the second is for thematic properties such as sentiment of the text. These are the properties whose values will be calculated for the set of books selected by the user. On the right side is a word cloud of most common themes in books that will change depending on the books selected.

![](https://github.com/STAT547-UBC-2019-20/group_07/blob/master/images/Dashboard%20Suggestion.png?raw=true)

### Usage 

A user might want to use the dashboard in order to explore how different aspects of books - both semantic and thematic- have changed depending on book popularity. 

For example, they might want to look at how a variety of variables such as sentence length or sentence readability have changed in books over the years. 
A user can do this by first selecting the 20 most popular books using the slider and looking at the appropriate variables in the column for semantic analysis and then selecting the twenty least popular books in the same way and repeating the process.
For users who wish to examine how thematic variables change in books based on popularity, they can examine the thematic variables section as well as the word cloud in which prominent themes are displayed.
These comparisons can also be made to the database as a whole by using the 'select all' feature. 


### Dashboard Deployment

Here is a screenshot of our dashboard:
![](https://github.com/STAT547-UBC-2019-20/group_07/blob/master/images/dashScreenShot.png)

Click [here](https://group-07.herokuapp.com/?fbclid=IwAR3s-XFZqxRK7riEhPCE-IT7VWbs5pi1k01rjozRuHaLkedoKthjeQl_GSw) to see our dash board.
#

