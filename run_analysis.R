
if (!file.exists("data")) { dir.create("data") }

#****************************************************
library(dplyr)

# fetch, save, and extract zipped data
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zippedFilePath <- "./data/HARdataset.zip"
download.file(dataUrl, destfile = zippedFilePath, method = "auto")
dateDownloaded <- date()
unzip(zipfile = zippedFilePath, exdir = "./data")



### read in...
unzippedDataPath <- "./data/UCI HAR Dataset/"

# test data
testActivityLabels <- read.table(paste0(unzippedDataPath, "test/y_test.txt"))
testDataset <- read.table(paste0(unzippedDataPath, "test/X_test.txt"))
testSubjects <- read.table(paste0(unzippedDataPath, "test/subject_test.txt"))

# training data
trainingActivityLabels <- read.table(paste0(unzippedDataPath, "train/y_train.txt"))
trainingDataset <- read.table(paste0(unzippedDataPath, "train/X_train.txt"))
trainingSubjects <- read.table(paste0(unzippedDataPath, "train/subject_train.txt"))

# others
activityLabelRef <- read.table(paste0(unzippedDataPath, "activity_labels.txt"), 
                             col.names = c("num", "label"))
activityLabelRef$label <- as.factor(sub("_", " ", activityLabelRef$label))

features <- read.table(paste0(unzippedDataPath, "features.txt"), 
                       col.names = c("num", "feature"))



### merge the two sets of data
combinedActivityLabels <- rbind(testActivityLabels, trainingActivityLabels)
combinedSubjects <- rbind(testSubjects, trainingSubjects)
combinedDataset <- rbind(testDataset, trainingDataset)

# look for only mean and standard deviation for each measurement
meanstdFeatures <- features[grep("mean|std", features$feature), ]
usefulCombinedDataset <- combinedDataset[, meanstdFeatures$num]



### average of each variable, for each activity, and each subject
activity <- activityLabelRef$label[combinedActivityLabels[,1]]
subject <- as.factor(combinedSubjects[,1])
usefulCombinedDataset <- cbind( usefulCombinedDataset, activity, subject )

# group by activity, then subject
groupByActivitySubject <- dplyr::group_by(usefulCombinedDataset, activity, subject)
aggregatedSummary <- dplyr::summarize(groupByActivitySubject, avgf1 = mean(V1, na.rm = TRUE))
for (col in groupByActivitySubject[, 2:79]) {
     tmp_summary <- dplyr::summarize(groupByActivitySubject, mean(col, na.rm = TRUE))
     aggregatedSummary <- cbind(aggregatedSummary, tmp_summary[, 3])
}
names(aggregatedSummary)[4:81] <- sub("V", "avgf", names(groupByActivitySubject)[2:79])



### write out tidy data
write.table(aggregatedSummary, file = "./data/TidyData_HARaverages.txt", row.names = FALSE)



# .../add documentation to code book and README
# .../create git repo (ignore "./data" directory and file submitted to course page)

