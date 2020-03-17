# author: Lucy Mosquera & Denitsa Vasileva
# date: March 17th, 2020

.PHONY: all clean

all: docs/report.html docs/report.pdf docs/report.md

# download data
data/classics_raw_data.csv : scripts/load_data.R
	Rscript scripts/load_data.r --data_url="https://corgis-edu.github.io/corgis/datasets/csv/classics/classics.csv"
	
# clean data
data/classics_clean.csv : scripts/clean.R data/classics_raw_data.csv
	Rscript scripts/clean.r --raw_file_path="data/classics_raw_data.csv" --clean_file_path="data/classics_clean.csv"

# EDA
images/publication_readibility.png images/publication_dates.png images/sentiment_analysis.png images/correlogram.png : scripts/data_exploration.R data/classics_clean.csv
	Rscript scripts/data_exploration.R --image_path="images" --data_path="data/classics_clean.csv"
	
# Linear regression
images/year_polarity.png data/tidy_model.rds data/augment_model.rds data/glance_model.rds : scripts/linear_regression.R data/classics_clean.csv
	RScript scripts/linear_regression.r --clean_data_path="data/classics_clean.csv" --output_path_image="images" --output_path_model="data"

# Knit report
docs/report.html docs/report.pdf docs/report.md : scripts/report.Rmd data/classics_clean.csv scripts/knit.R images/publication_readibility.png images/publication_dates.png images/sentiment_analysis.png images/correlogram.png images/year_polarity.png data/tidy_model.rds
	Rscript scripts/knit.R --final_report="scripts/report.RMD" --report_dir="docs"
    
clean :
	rm -f data/*.csv
	rm -f data/*.RDS
	rm -f images/*.png
	rm -f docs/*.md
	rm -f docs/*.html
	rm -f docs/*.pdf