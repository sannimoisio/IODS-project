# created by Sanni Moisio 17.11.2023
# this script will prepare data for dimensionality reduction task (assignment 5)

# setting the working directory to the IODS course project data folder
setwd("/Users/sannimoi/Documents/courses/IODS/IODS-project/data")

# loading the required libraries
library(readr)
library(dplyr)

# reading in the datasets, human development index and gender inequality index data
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# checking the structure and dimensions of the data
str(hd)
str(gii)
dim(hd)
dim(gii)
# both have 195 observations, i.e., rows which correspond to countries
# and hd has 8 variables, i.e., columns, and gii 10 columns

# creating summaries of the variables
sum_hd <- summary(hd)
sum_gii <- summary(gii)
sum_hd
sum_gii

# renaming the columns with shorter, yet descriptive names
colnames(hd)
# "HDI.Rank","Country", "Human.Development.Index..HDI.", "Life.Expectancy.at.Birth", "Expected.Years.of.Education", "Mean.Years.of.Education", "Gross.National.Income..GNI..per.Capita", "GNI.per.Capita.Rank.Minus.HDI.Rank"    
colnames(hd)[3:8] <- c("HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Rank-HDI.Rank")
colnames(gii)
# "GII.Rank", "Country", "Gender.Inequality.Index..GII.", "Maternal.Mortality.Ratio", "Adolescent.Birth.Rate", "Percent.Representation.in.Parliament", "Population.with.Secondary.Education..Female.", "Population.with.Secondary.Education..Male.", "Labour.Force.Participation.Rate..Female.", "Labour.Force.Participation.Rate..Male."  
colnames(gii)[3:10] <- c("GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M")

# creating two new variables to gender inequality index gii table
# first, a ratio of female and male populations with secondary education
gii <- mutate(gii, Edu2.FM = Edu2.F/Edu2.M)
# second, a ratio of labor force participation of females and males
gii <- mutate(gii, Labo.FM = Labo.F/Labo.M)

# joining the human development and gender inequality index datasets together
# using country as the identifier
human <- inner_join(hd, gii, by = "Country")

# writing the created data out
write_csv(human, "human.csv")
