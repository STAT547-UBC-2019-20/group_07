# Group 7

## Group Members:
  * Denitsa Vasileva
  * Lucy Mosquera
  
## Project Description:

The purpose of this project is to explore the dataset found [here](https://corgis-edu.github.io/corgis/datasets/csv/classics/classics.csv). 
This data set was obtained from Project Gutenberg- an online free book repository
and contains different - meta, author, sentimentality analysis, etc.- information 
about more than 1000 books. The most recent version of our report is available [here](https://github.com/STAT547-UBC-2019-20/group_07/blob/master/docs/Milestone1.md)

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

3. Run the following scripts (in order) with the appropriate arguments specified:

  ### Download data
  ```
  Rscript scripts/load_data.r --data_url="https://corgis-edu.github.io/corgis/datasets/csv/classics/classics.csv"
  ```
  
  ### Wrangle/clean/process your data 
  ```
  Rscript scripts/clean.r --raw_file_path="data/classics_raw_data.csv" --clean_file_path="data/classics_clean.csv"
  ```
  
  ### EDA script to export images
  ```
  Rscript scripts/data_exploration.R --image_path="images" --data_path="data/classics_clean.csv"  
  ```
  
  ### Linear regression
  ```
  RScript scripts/linear_regression.r --clean_data_path="data/classics_clean.csv" --output_path_image="images" --output_path_model="data"
  ```
  
  ### Knit your draft final report
```
Rscript scripts/knit.R --final_report="scripts/report.RMD"
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
