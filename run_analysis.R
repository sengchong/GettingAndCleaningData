setwd('C:\\Users\\tang\\Desktop\\Gettingdata_Assignment\\getdata-projectfiles-UCI HAR Dataset\\ActualFolder')
getwd()

library(plyr)

#download data set from the web
download.data = function()
{
  #check if the directory for the data exist. Create one if there is none.
  if(!file.exists("data"))
  {
    message("Creating data directory")
    dir.create("data")
  }
  
  if(!file.exists("data/UCI HAR Dataset"))
  {
    #download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile = "data/UCI_HAR_data"
    message("Downloading data")
    download.file(fileURL, destfile = zipfile, method = "auto")
    
    unzip(zipfile, exdir = "data")
  }
}

# Merges the training and the test sets to create one data set
merge.data = function()
{
  message("Merge X")
  text1 <- read.table("data/UCI HAR Dataset/train/X_train.txt")
  text2 <- read.table("data/UCI HAR Dataset/test/X_test.txt")
  
  X <- rbind(text1, text2)
  
  message("Merge Y")
  text1 <- read.table("data/UCI HAR Dataset/train/y_train.txt")
  text2 <- read.table("data/UCI HAR Dataset/test/y_test.txt")
  
  Y <- rbind(text1, text2)
  
  message("Merge Subjects")
  text1 <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
  text2 <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
  
  Subject <- rbind(text1, text2)
  
  list(x = X, y = Y, subject = Subject)
}

#Extracts only the measurements on the mean and standard deviation  for each measure
extract.mean.and.std = function(df)
{
  #Read the features.txt
  features <- read.table("data/UCI HAR Dataset/features.txt")
  
  #Get mean and standard deviation
  mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed = T))
  std.col <- sapply(features[,2], function(x)  grepl("std()",x,fixed = T))
  
  #Extract from data
  extract.from.data <- df[, (mean.col|std.col)]
  colnames(extract.from.data) <- features[(mean.col|std.col),2]
  extract.from.data
}

#3 Uses descriptive activity names to name the activities in the data set
name.activities = function(df)
{
  colnames(df) <- "activity"
  df$activity[df$activity == 1] = "walking"
  df$activity[df$activity == 2] = "walking upstairs"
  df$activity[df$activity == 3] = "walking downstairs"
  df$activity[df$activity == 4] = "sitting"
  df$activity[df$activity == 5] = "standing"
  df$activity[df$activity == 6] = "laying"
  df
}

generate.tidy.data =function(df)
{
  tidydataset = ddply(df, .(subject,activity), function(x) colMeans(x[,1:60]))
  tidydataset
}



download.data()

merged <-merge.data()

cx <- extract.mean.and.std(merged$x)

cy <- name.activities(merged$y)

colnames(merged$subject) <-c("subject")

combined <- cbind(cx, cy, merged$subject)

tidy <- generate.tidy.data(combined)

write.table(tidy, "UCI_HAR_tidy.txt",row.names=FALSE) 

