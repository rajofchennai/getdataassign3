# README

## 1- Merging test and train data set

* Read the data from test, train and merge them into a variable called merge_x
* The files do not have header so header is FALSE

```r
test_x <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE,
                   as.is = TRUE)
train_x <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE,
                    as.is = TRUE)

merge_x <- rbind(test_x, train_x)
```

## 4 - Appropriately labels the data set with descriptive variable names

* Read the feature names from features.txt and assign as column names

```r
column_names <- read.table("UCI HAR Dataset/features.txt",
                           header = FALSE, as.is = TRUE,
                           colClasses = c("NULL", "character"),
                           col.names=c("NULL","names") )$names

colnames(merge_x) <- column_names
```

## 2 - Extracts only the measurements on the mean and standard deviation for each measurement

* Filter  only the columns whose names match mean or std

```r
merge_x <- merge_x[,grep("-mean\\(\\)|-std\\(\\)", names(merge_x), ignore.case = TRUE)]
```

### Assigns activity id to the dataset

* Read activity_id from test, train and merge them
* Also add the activity_id to original dataset

```r
test_y <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE,
                     as.is = TRUE, colClasses = c(rep("character",1)),
                     col.names=c("activity_id"))
train_y <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE,
                      as.is = TRUE, colClasses = c(rep("character",1)),
                      col.names=c("activity_id"))

merge_y <- rbind(test_y, train_y)

merge_x <- cbind(merge_x, merge_y)
```

* Extract the actual activity_labels then map it to the activity id data.

```r
activity_labs <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE,
                            as.is=TRUE, colClasses=c(rep("character",2)),
                            col.names=c("activity_id", "activity_name"))

```

## 5 -From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
## 3 - Uses descriptive activity names to name the activities in the data set

* Read the subject data from test,train and then merge them.
* Add an additional column to the original dataset

```r
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE,
                     as.is = TRUE, colClasses = c(rep("character",1)),
                     col.names=c("subject"))
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE,
                      as.is = TRUE, colClasses = c(rep("character",1)),
                      col.names=c("subject"))

merge_sub <- rbind(test_sub, train_sub)

merge_x <- cbind(merge_x, merge_sub)
```

* calculate mean of all columns using lapply
* write output to a result.txt

```r
library(data.table)
DT <- data.table(merge_x)
head(DT)
library(knitr)
df <- DT[, lapply(.SD,mean), by=c("subject", "activity_id")]
df <-  merge(df, activity_labs, by="activity_id")
df$activity_id <- NULL
write.table(df, file = "result.txt", row.names=FALSE, col.names = FALSE)
```