myGacdProj
==========

Comments of R oode for Coursera / Getting and Cleaning Data / Course Project

Description of variables and processing throughout the script:

. Step 1: Merges the training and the test sets to create one data set

activityLabels: data.frame with "activity_labels.txt" content. 2 columns: "activityId", "activityName"
features: data.frame with "activity_labels.txt" content. 2 columns: "featureId", "featureName"
nFeatures: rows number of features

subjectTrain: data.frame with "subject_train.txt" content
xTrain: data.frame with "X_train.txt" content
yTrain: data.frame with "y_train.txt" content
subjectTest: data.frame with "subject_test.txt" content
xTest: data.frame with "X_test.txt" content
yTest: data.frame with "y_test.txt" content

subjectAll: union of subject tables. 1 column: "subjectId"
xAll: union of x tables
yAll: union of y tables. 1 column: "activityId"
dataSet0: result of step 1

. Step 2: Extracts only the measurements on the mean and standard deviation for each measurement

use of sqldf to find the required names then columns
dataSet1: result of step 2

. Step 3: Uses descriptive activity names to name the activities in the data set

use of dplyr to join activityLabels as descriptive activity names
dataSet1: result of step 3

. Step 4: Appropriately labels the data set with descriptive variable names

use of regular expressions to clean the descriptive activity names
use of these names as field names for the x part of dataSet1

. Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

use of dplyr to perform the required processing
use of dynamic coding, through 'eval', to perform the tricky part of the processing
dataSet2: result of step 5
result file output as required (hopefully)
