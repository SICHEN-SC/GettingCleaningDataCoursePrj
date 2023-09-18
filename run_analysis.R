# Getting and Cleaning Data Course Project ----
library(dplyr)
library(tidyverse)

filename <- "Coursera_DS3_Final.zip"
   
   # Checking if archieve already exists.
   if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
   }  
   
   # Checking if folder exists
   if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
   }
   

## 1. Merge training & test sets ----
### 1.1 Read training sets ----
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

### 1.2 Read test sets ----
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

### 1.3 Read the features & activity ---- 
features <- read.table('./UCI HAR Dataset/features.txt')
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')

# 1.2 Assigning column names----
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

### 1.4 Merge into one dataset ----
train <- cbind(x_train,subject_train, y_train) 
test <- cbind(x_test,subject_test, y_test) 
dat <- rbind(train, test)

## 2. Extracts mean and sd cols ----
dat_avg_sd <- dat %>%
     select(subjectId, activityId, contains(c("mean", "std"))) 

dat_avg_sd_name = merge(dat_avg_sd, activityLabels, by = "activityId")
dat_avg_sd_name$activityType = as.factor(dat_avg_sd_name$activityType)

## 3/4 Done is step 1 ----

## 5. New dataset with average of each var ---
dat_new <- dat_avg_sd_name %>%
     group_by(subjectId, activityType) %>%
     summarise(across(everything(), mean),.groups = 'drop')

# CHECK FINAL RESULTS ----
str(dat_new)

### 5.1 Writing second tidy data set in txt file

write.table(dat_new, "q5_data.txt", row.name=FALSE)

