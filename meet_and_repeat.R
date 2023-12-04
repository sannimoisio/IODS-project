# created by Sanni Moisio 30.11.2023
# this script will prepare data for the IODS assignment 6 focusing on the analysis of 2 longitudinal datasets

# setting the working directory to the IODS course project data folder
setwd("/Users/sannimoi/Documents/courses/IODS/IODS-project/data")

# loading the required libraries
library(dplyr)

# reading in the datasets
# one with human brief psychiatric rating scale (bprs) data from a study comparing the effects of two treatments
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header=T)
# and the other comparing the effects of 3 different diets on the weight of rats
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")
colnames(rats) <- tolower(colnames(rats))

# checking the data dimensions and structures

# bprs data first
dim(bprs)
str(bprs)
summary(bprs)
# the bprs data contains 40 observations, i.e., studied subjects, and 11 variables
# one variable describing the treatment and one the subject ID number
# while the rest are reported bprs values for the same subject over 8 weeks (week 0 also reported as a starting point so in total 9 values for each subject)
# so the data is in a wide form
# all values are integer ones for now

# rat data then
dim(rats)
str(rats)
summary(rats)
# the rats data contains 16 observations, i.e., studied rats, and 13 variables
# one variable describing the (diet) group and one the subject id number
# while the rest are reported weight values from 11 different timepoints (days) over 9 weeks (64 days) so the data is in a wide form
# all values are integer ones for now

# as the treatment/diet Group and subject ID number columns are actually categorical variables and not numeric
# converting them to factors
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)
rats$id <- factor(rats$id)
rats$group <- factor(rats$group)

# converting both datasets into long form, so that the values for each week/timepoint are in reported in the same variable column
# and the week/timepoint is reported in another column
# so in the resulting table each row represents one measured value from one timepoint for one subject
bprs_long <- pivot_longer(bprs, cols = -c(treatment, subject), names_to = "weeks", values_to = "bprs") %>% arrange(weeks) %>% mutate(week = as.integer(substr(weeks,5,5)))
rats_long <- pivot_longer(rats, cols = -c(id, group), names_to = "wd", values_to = "weight") %>% mutate(time = as.integer(substr(wd,3,4))) %>% arrange(time)

# looking at the dimensions and data stucture now

# bprs data first
dim(bprs_long)
str(bprs_long)
colnames(bprs_long)
summary(bprs_long)
# now there are 360 observations and 5 variables (treatment, subject, weeks, bprs, week), and treatment and subject columns are in factor format
# so basically the measured bprs values are now each on their own row, so 360 observations in total which corresponds to the original number
# which was 40 subjects x bprs values over 9 timepoints = 360
# now there are multiple rows present for the same subject, since each timepoint value for each subject is on their own row
# and the other columns describe the subject and timepoint for each observation

# rat data then
dim(rats_long)
str(rats_long)
colnames(rats_long)
summary(rats_long)
# now there are 176 observations and 5 variables (id, group, wd, weight, time), and id and group columns are in factor format
# so basically the measured rat weight values are now each on their own row, so 176 observations in total which corresponds to the original number
# which was 16 rats x weight values over 11 timepoints = 176
# now there are multiple rows present for the same rat, since each timepoint weight for each rat is on their own row
# and the other columns describe the rat id and diet group for each observation

# writing the datasets out in their long form
write.table(bprs_long, "bprs.txt", col.names = T, row.names = F, quote=F, sep="\t")
write.table(rats_long, "rats.txt", col.names = T, row.names = F, quote=F, sep="\t")
