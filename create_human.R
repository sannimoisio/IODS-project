# created by Sanni Moisio 17.11.2023
# modified 27.11.2023 to add further processing steps
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

# reading in the human development index data again
human <- read_csv("human.csv")

# checking the dimensions and structure
dim(human)
str(human)
colnames(human)

# the dataset contains 195 observations (rows) and 19 variables (columns)
# variables include "HDI Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Rank-HDI.Rank",
# "GII Rank","GII", "Mat.Mor", "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", "Labo.F", "Labo.M", "Edu2.FM", and "Labo.FM"

# Indeed, each row in the data corresponds to a Country/region, and the countries have been ranked according to human development index (HDI)
# which is based on three dimensions:
# long and healthy life, the indicator of which is life expectancy at birth (Life.Exp column)
# knowledge, the indicators of which are expected and mean years of schooling (Edu.Exp and Edu.Mean columns, respectively)
# and a decent standard of living, the indicator of which is gross national income (GNI) per capita (GNI column).
# The relationship between the GNI and HDI rank can also be studied based on the GNI.Rank-HDI.Rank column as it describes their difference.

# Moreover, information about the countries' gender inequality index (GII) has also been included in the table including the GII Rank column
# which index is based on different dimensions as well, namely:
# health, the indicators of which are maternal mortality ratio (Mat.Mor) and adolecent birth rate (Ado.Birth)
# empowerment, the indicators of which are female and male shares of parlamentry seats (percentange of female representatives in parliament, Parli.F reported here)
# and female and male population with at least secondary education (Edu2.F and Edu2.M columns, respectively)
# as well as labour market, the indicators of which are female and male labour force participation rates (Labo.F and Labo.M columns, respectively).
# The ratio of female vs male population with at least secondary education and labour force participation rates can be studied based on the Edu2.FM and Labo.FM columns, respectively.

# then only keeping countries and removing regions, which have HDI and GII values but are not included in the rank
human <- subset(human, !is.na(human$`HDI Rank`))

# then keeping only the following columns of interest
cols <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- human[,cols]

# removing all rows with missing values
human2 <- filter(human, complete.cases(human))

# checking the dimensions
dim(human2)
# the current data has 155 observations (=rows) and 9 variables (columns) as desired

# writing the updated human dataset out, overwriting the previous one
write_csv(human2, "human.csv")
