# Getting and cleaning data project - Coursera

This R script <code>run_analysis.R</code> does the following:

1. Downloads and unzips the dataset if not already existing.
2. Loads activity and feature files.
3. Loads training and test data sets and selects only mean and standard deviation measurements.
4. Includes subject and activity data for both training and test datasets.
5. Merges the training and the test sets to create one data set.
6. Updates activity labels.
7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
