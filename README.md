myGacdProj
==========

# R oode for Coursera / Getting and Cleaning Data / Course Project

# step 1: Merges the training and the test sets to create one data set
activityLabels: data.frame with "activity_labels.txt" content. 2 columns: "activityId", "activityName"
features: data.frame with "activity_labels.txt" content. 2 columns: "featureId", "featureName"
nFeatures: rows number of features

subjectTrain: data.frame with "subject_train.txt" content
xTrain: data.frame with "X_train.txt" content
yTrain: data.frame with "y_train.txt" content
subjectTest: data.frame with "subject_test.txt" content
xTest: data.frame with "X_test.txt" content
yTest: data.frame with "y_test.txt" content

subjectAll <- rbind(subjectTrain, subjectTest)
colnames(subjectAll) <- c("subjectId")
xAll <- rbind(xTrain, xTest)
yAll <- rbind(yTrain, yTest)
colnames(yAll) <- c("activityId")
dataSet0 <- cbind(subjectAll, xAll, yAll)

# step 2: Extracts only the measurements on the mean and standard deviation for each measurement
library(sqldf)
myFeatures <- sqldf("select * from features where featureName like '%-mean(%' or featureName like '%-std(%'")
kFeatures <- dim(myFeatures)[1]
myColumns <- c(1, myFeatures$featureId+1, nFeatures+2)
dataSet1 <- dataSet0[, myColumns]

# step 3: Uses descriptive activity names to name the activities in the data set
library(dplyr)
dataSet1 <- left_join(dataSet1, activityLabels)

# step 4: Appropriately labels the data set with descriptive variable names
myFeatures$featureName2 <- gsub("[-(),]", "", myFeatures$featureName)
colnames(dataSet1)[1:kFeatures+1] <- myFeatures$featureName2

# step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
dataSet2 <- summarize(group_by(dataSet1, activityId, subjectId), mean(tBodyAccmeanX))
for (featureName in myFeatures$featureName2[2:kFeatures]){
   eval(parse(text=sprintf("dataSet2 <- left_join(dataSet2, summarize(group_by(dataSet1, activityId, subjectId), mean(%s)))", featureName)))
                                      # Joining by: c("activityId", "subjectId")
}
dataSet2 <- left_join(dataSet2, activityLabels)  # dommage de le refaire...

write.table(dataSet2, file="project-output.txt", quote=FALSE, row.names=FALSE)
