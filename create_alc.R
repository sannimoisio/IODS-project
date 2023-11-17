# created by Sanni Moisio 15.11.2023
# this script will prepare data for logistic regression analysis task (assignment 3)

# setting the working directory to the IODS course project data folder
setwd("/Users/sannimoi/Documents/courses/IODS/IODS-project/data")

# loading the required libraries
library(readr)
library(dplyr)

# reading in the desired student performance datasets from math and portuguese classes
# which was downloaded from UCI Machine Learning Repository: http://www.archive.ics.uci.edu/dataset/320/student+performance
mat <- read.csv("student-mat.csv", sep=";")
por <- read.csv("student-por.csv", sep=";")

# checking the structure and dimensions of both data frames
dim(mat)
str(mat)
# 395 observations (rows), 33 variables (columns)
dim(por)
str(por)
# 649 observations (rows), 33 variables (columns)
setdiff(colnames(por), colnames(mat))
# both tables have the same column names

# joining the datasets using all other variables except
# failures, paid, absences, G1, G2, G3 as (student) identifiers
# so defining the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")
# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)
# joining the two data sets by the selected identifiers
math_por <- inner_join(mat, por, by = join_cols, suffix=c(".math", ".por"))
# checking the structure and dimensions
str(math_por)
dim(math_por)
# 370 observations (rows), 39 variables (columns)

# then getting rid of the duplicate records in the joined dataset
# first creating a table with only the columns used for joining
alc <- math_por[,join_cols]
# and then for every column not used for joining
# including the mean value from the mat and por tables (if value is numeric)
# or the value from the mat table if the value is not numeric
for (c in free_cols) {
  # selecting the two corresponding columns from the math_por table
  two_cols <- select(math_por, starts_with(c))
  # then adding the mean value if the values are numeric, or the first one if not
  if (is.numeric(two_cols[,1])) {
    alc[c] <- round(rowMeans(two_cols))}
  if (isFALSE(is.numeric(two_cols[,1]))){
    alc[c] <- two_cols[,1]}}
# checking the dimensions of the new table
dim(alc)
# 370 observations (rows), 33 variables (columns) as desired

# then adding two columns to the table
# one, alc_use, describing the mean alcohol consumption over weekdays and weekend
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# and the other column, high_use, describing high alcohol use as TRUE
# if the mean consumption over weekdays and weekend is > 2
alc <- mutate(alc, high_use = alc_use > 2)

# checking the new table by the glimpse function
glimpse(alc)
# there are 370 observations in the data
# also checking if it corresponds to the correct table linked in moodle
goal <- read.csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/alc.csv")
table(alc==goal)
# which is true so the tables are identical

# writing the generated table out
write.csv(alc, "alc.csv", row.names=F)
