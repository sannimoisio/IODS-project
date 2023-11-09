# created by Sanni Moisio 9.11.2023
# this R script will prepare data for regression analysis (assignment 2)

# setting the working directory to the IODS course project folder
setwd("/Users/sannimoi/Documents/courses/IODS/IODS-project")

# loading required libraries
library(dplyr)
library(readr)

# reading in the 2014 learning dataset
data <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=T)

# checking the dimensions of the data table
dim(data)
# 183 rows, 60 columns

# checking the data structure
str(data)
# data is structured in a data frame
# 59 columns contain integer values, 1 (gender) characters

# creating an analysis dataset, containing gender, age, attitude, deep, stra, surf and points variables
# first selecting the columns that are already defined in current data frame
data2 <- select(data, one_of("gender", "Age", "Attitude", "Points"))

# then defining the questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# selecting the columns related to deep learning 
deep_columns <- select(data, one_of(deep_questions))
# and creating column 'deep' by averaging
data2$deep <- rowMeans(deep_columns)

# selecting the columns related to surface learning 
surface_columns <- select(data, one_of(surface_questions))
# and creating column 'surf' by averaging
data2$surf <- rowMeans(surface_columns)

# selecting the columns related to strategic learning 
strategic_columns <- select(data, one_of(strategic_questions))
# and creating column 'stra' by averaging
data2$stra <- rowMeans(strategic_columns)

# reordering the table
data2 <- data2[,c(1:3,5:7,4)]

# and redefining column names so that everything is lowercase
colnames(data2) <- tolower(colnames(data2))

# excluding observations from the data where exam points are zero
data2 <- subset(data2, data2$points!=0)

# checking the data dimensions
dim(data2)
# 166 rows, 7 columns

# writing the prepared data into the data folder
write_csv(data2, "data/learning2014.csv")
# and in case the data needs to be read in again
data <- as.data.frame(read_csv("data/learning2014.csv"))
dim(data)
# 166 rows, 7 columns
head(data)
# gender age attitude     deep     surf  stra points
# 1      F  53       37 3.583333 2.583333 3.375     25
# 2      M  55       31 2.916667 3.166667 2.750     12
# 3      F  49       25 3.500000 2.250000 3.625     24
# 4      M  53       35 3.500000 2.250000 3.125     10
# 5      M  49       37 3.666667 2.833333 3.625     22
# 6      F  38       38 4.750000 2.416667 3.625     21
str(data)
# 'data.frame':	166 obs. of  7 variables:
# $ gender  : chr  "F" "M" "F" "M" ...
# $ age     : num  53 55 49 53 49 38 50 37 37 42 ...
# $ attitude: num  37 31 25 35 37 38 35 29 38 21 ...
# $ deep    : num  3.58 2.92 3.5 3.5 3.67 ...
# $ surf    : num  2.58 3.17 2.25 2.25 2.83 ...
# $ stra    : num  3.38 2.75 3.62 3.12 3.62 ...
# $ points  : num  25 12 24 10 22 21 21 31 24 26 ...

# structure looks correct