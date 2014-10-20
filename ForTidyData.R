# Source from data for : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# This R script will be

# 1. Merges the training both test sets to create one data only one.

Tmp1 <- read.table("train/X_train.txt")
Tmp2 <- read.table("test/X_test.txt")
Xx <- rbind(tmp1, tmp2)

Tmp1 <- read.table("train/subject_train.txt")
Tmp2 <- read.table("test/subject_test.txt")
Ss <- rbind(tmp1, tmp2)

Tmp1 <- read.table("train/y_train.txt")
Tmp2 <- read.table("test/y_test.txt")
Yy <- rbind(tmp1, tmp2)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
Xx <- Xx[, indices_of_good_features]
names(Xx) <- features[indices_of_good_features, 2]
names(Xx) <- gsub("\\(|\\)", "", names(Xx))
names(Xx) <- tolower(names(Xx))

# 3. Uses descriptive activity names to name the activities in the data set.

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Yy[,1] = activities[Y[,1], 2]
names(Yy) <- "activity"

# 4. Appropriately labels the data set with descriptive activity names.

names(Ss) <- "subject"
cleaned <- cbind(Ss, Yy, Xx)
write.table(cleaned, "merged_clean_data.txt")

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

uniqueSubjects = unique(Ss)[,1]
numSubjects = length(unique(Ss)[,1])
numActivities = length(activities[,1])
numCols = dim(cleaned)[2]
result = cleaned[1:(numSubjects*numActivities), ]

row = 1
for (s in 1:numSubjects) {
  for (a in 1:numActivities) {
    result[row, 1] = uniqueSubjects[s]
    result[row, 2] = activities[a, 2]
    tmp <- cleaned[cleaned$subject==s & cleaned$activity==activities[a, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}
write.table(result, "data_set_with_the_averages.txt")
