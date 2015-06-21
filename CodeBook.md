Course Project Code Book
========================

Source of original data is at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


Original Description is at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

run_analysis.r performs the following steps to clean up the data

* download data set from the web(if is not yet downloaded)

* Merges the training and the test sets to create one data set

* Extracts only the measurements on the mean and standard deviation  for each measure

* Uses descriptive activity names to name the activities in the data set
		walking
        
        walking upstairs
        
        walking downstairs
        
        sitting
        
        standing
        
        laying

* Write to a text file