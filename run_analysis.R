# Getting and Cleaning Data
# Course Project
##############################

# Packages
library(dplyr)
library(tidyr)

# Loading needed data
## Test Set
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="", na.strings="")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="", na.strings="")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", quote="\"", comment.char="", na.strings="")
data_test <- cbind(X_test,Y_test,subject_test,set="test")
## Train Set
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="", na.strings="")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="", na.strings="")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", quote="\"", comment.char="", na.strings="")
data_train <- cbind(X_train,Y_train,subject_train,set="train")

# Merging partial data sets in a unique data set
data_all <- rbind(data_train,data_test)

# Extracting the mean and standard deviation for each measurement
means <- apply(data_all[,1:561], 1,mean)
stds <- apply(data_all[,1:561], 1,sd)
new_data <- cbind(data_all[,562:564],means,stds)
names(new_data) <- c("activity","subject","set","means","stds")
new_data$activity <- as.factor(new_data$activity)
levels(new_data$activity) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
new_data$subject <- as.factor(new_data$subject)
new_data$set <- as.factor(new_data$set)

# Creating the tidy data set
new_data <- tbl_df(new_data)
tidy_data <- new_data %>% select(-set) %>% group_by(activity,subject) %>% summarize(mean_average=mean(means),std_average=mean(stds))
write.table(tidy_data,"tidy_data_set.txt",row.name=FALSE)
