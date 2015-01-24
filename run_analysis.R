#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
#              method="curl", destfile="getdata.zip")
#unzip("getdata.zip")

test_x <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE, 
                   as.is = TRUE)
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE,
                    as.is = TRUE)

merge_x <- rbind(test_x, train_x)

column_names <- read.table("UCI HAR Dataset/features.txt", 
                           header = FALSE, as.is = TRUE, 
                           colClasses = c("NULL", "character"), 
                           col.names=c("NULL","names") )$names

colnames(merge_x) <- column_names

merge_x <- merge_x[,grep("-mean\\(\\)|-std\\(\\)", names(merge_x), ignore.case = TRUE)]

test_y <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE,
                     as.is = TRUE, colClasses = c(rep("character",1)),
                     col.names=c("activity_id"))
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE,
                      as.is = TRUE, colClasses = c(rep("character",1)),
                      col.names=c("activity_id"))

merge_y <- rbind(test_y, train_y)

merge_x <- cbind(merge_x, merge_y)

activity_labs <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE,
                            as.is=TRUE, colClasses=c(rep("character",2)), 
                            col.names=c("activity_id", "activity_name"))

#merge_x <- merge(merge_x, activity_labs, by = "activity_id")
 
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE,
                     as.is = TRUE, colClasses = c(rep("character",1)),
                     col.names=c("subject"))
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE,
                      as.is = TRUE, colClasses = c(rep("character",1)),
                      col.names=c("subject"))

merge_sub <- rbind(test_sub, train_sub)

merge_x <- cbind(merge_x, merge_sub)

#merge_x$activity_id <- NULL

library(data.table)
DT <- data.table(merge_x)
df <- DT[, lapply(.SD,mean), by=c("subject", "activity_id")]

df <-  merge(df, activity_labs, by="activity_id")
df$activity_id <- NULL

write.table(df, file = "result.txt", row.names=FALSE, col.names = FALSE)