filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
#check if directory exists
if(!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}
#check if folder exists
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

#assigning data frames

activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label", "Activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

#merge
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_data <- cbind(subject, y, x)

#extract mean & sd
library(dplyr)
Clean_data <- select(merged_data, subject, label, contains("mean"), contains("std"))

#name activities
Clean_data$label <- activity[Clean_data$label,2]

#Descriptive variable names
names(Clean_data)[2] <- "Activity"
names(Clean_data) <- gsub("Acc", "Accelerometer", names(Clean_data))
names(Clean_data) <- gsub("Gyro", "Gyroscope", names(Clean_data))
names(Clean_data) <- gsub("Mag", "Magnitude", names(Clean_data))
names(Clean_data) <- gsub("BodyBody", "Body", names(Clean_data))
names(Clean_data) <- gsub("^t", "Time", names(Clean_data))
names(Clean_data) <- gsub("^f", "Frequency", names(Clean_data))
names(Clean_data) <- gsub("tBody", "TimeBody", names(Clean_data))

#Final tidy data

final_data <- Clean_data%>%
  group_by(subject, Activity)%>%
  summarise_all(mean)

write.table(final_data, "final_data.txt", row.names = FALSE)
str(final_data)
View(final_data)