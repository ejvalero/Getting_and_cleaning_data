Data Info
================================

Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  
Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


Description Of ```run_analysis.R Script```
================================

This script contains two functions, ```preprocessing()``` and ```tidy()```, which merges training and testing data sets, estracts the measurements on the mean and standard deviation for each one, and creates a final tidy data set with the average of each variable by activity and subject.
Both ```preprocessing()``` and ```tidy()``` functions have comments throughout their codes, indicating what each group of lines do.

Output
================================

average.txt
