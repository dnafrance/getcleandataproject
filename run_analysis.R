# This script does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation 
#       for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, 
#       independent tidy data set with the average of each variable 
#       for each activity and each subject.

# Assumption:
# The current script is present in the working directory
# i.e.  ./run_analysis.R
# Project datasets have been downloaded and unzipped in the working directory
# maintaining the original directory structure of the zip file.
# e.g. Test data is available in ./UCI HAR Dataset/test/
#      Training data is available in ./UCI HAR Dataset/train/
# The output is created in the working directory
# i.e. ./tidy_data.txt

# Load libraries
library(reshape2)

# Download dataset
datafile <- "dataset.zip"
if (!file.exists(datafile)){
        fileurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
        download.file(fileurl,datafile,method='curl')
}

# Unzip dataset
if (!file.exists("UCI HAR Dataset")){
        unzip(datafile)
}

# Load activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
# Load features
features <- read.table("UCI HAR Dataset/features.txt")
features$V2 <- as.character(features$V2) # Convert factors
# Select only mean and standard deviation (std) measurements 
selectedfeatures <- features[grep("mean|std",features$V2),]
featurenames <- selectedfeatures[,2]

# Load selected features from training and test datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[selectedfeatures$V1]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")[selectedfeatures$V1]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Include subjects and activities in the datasets
train <- cbind(trainSubjects, trainActivities, train)
test <- cbind(testSubjects, testActivities, test)

# Merge training and test datasets into one
mergedata <- rbind(train,test)
colnames(mergedata) <- c("subject","activity",featurenames)
# Add activity labels
mergedata$activity <- factor(mergedata$activity, levels = activityLabels[,1], 
                             labels = activityLabels[,2] )

# Melt into long format
mergedata.melted <- melt(mergedata, id = c("subject", "activity"))
# Add average of each variable for each subject and each activity
mergedata.mean <- dcast(mergedata.melted, subject + activity ~ variable, mean)

# Output tidy data
write.table(mergedata.mean, "tidy_data.txt", row.names = FALSE, quote = FALSE)
