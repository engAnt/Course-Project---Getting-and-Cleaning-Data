
# CodeBook - HAR data tidy

### dowloand and unzip

* dataUrl - the url of the zipped data and the first argument to _download.file()_
- zippedFilePath  - file name to save the downloaded zipped file as. This is passed as the _destfile_ argument to _download.file()_ and the _zipfile_ argument to _unzip()_
+ dateDownloaded - date download occurred
* unzippedDataPath - directory containing unzipped data files and folders

### load data from files

* testActivityLabels - data frame for activity number references for test data
+ testDataset - data frame for test data set
- testSubjects - data frame for subject refences for test data
* trainingActivityLabels - data frame for activity number references for train data
+ trainingDataset - data frame for train data set
- trainingSubjects - data frame for subject refences for train data
* activityLabelRef - data frame holding the activities and their number refernces (e.g. 1 == "WALKING")
+ features - data frame for the features (column names) and their number refences



Activity names, such as "WALKING_UP", are transformed to "WALKING UP" by substituting the '_' with a single space. The activity names are converted to factor as well since grouping will happen by activity.



### merge data frames

+ combinedActivityLabels - data frame with the rows of trainingActivityLabels below the rows of testActivityLabels
+ combinedSubjects - data frame with the rows of trainingSubjects below the rows of testSubjects
+ combinedDataset - data frame with the rows trainingDataset below the rows of testDataset

### filter features (column names)

- meanstdFeatures - data frame resulting from filtering for features with "mean" or "std" in their name
- usefulCombinedDataset - data frame after retrieving only the columns in combinedDataset that match with columns in meanstdFeatures

### average of each variable, for each activity, and each subject

* activity - factor variable matching each row in usefulCombinedDataset to its corresponding activity name
* subject - factor variable matching each row in usefulCombinedDataset to its corresponding subject (participant)



At this point the data frame, usefulCombinedDataset, is updated with the new columns ("activity", and "subject").

### group by activity, then subject

* aggregatedSummary - a data frame as a result of grouping by activity, and then subject, and then using _dplyr_ to generate summary statistics (only mean/average in this case) for all columns in _usefulCombinedDataset_ besides the grouping columns


