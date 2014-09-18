# R oode for Coursera / Getting and Cleaning Data / Course Project

# step 1: Merges the training and the test sets to create one data set
activityLabels <- read.table("activity_labels.txt", sep=" ", stringsAsFactors=FALSE)
colnames(activityLabels) <- c("activityId", "activityName")
features <- read.table("features.txt", sep=" ", stringsAsFactors=FALSE)
colnames(features) <- c("featureId", "featureName")
nFeatures <- dim(features)[1]

setwd("./train")
subjectTrain <- read.table("subject_train.txt")
xTrain <- read.table(file="X_train.txt", colClasses="numeric")
yTrain <- read.table("y_train.txt")
setwd("../test")
subjectTest <- read.table("subject_test.txt")
xTest <- read.table(file="X_test.txt", colClasses="numeric")
yTest <- read.table("y_test.txt")
setwd("..")

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
