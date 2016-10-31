
# Tidying HAR data

This project is based on the Human Activity Recognition (HAR) data set. The abstract on the project page paints a good picture of what the project is all about
> "Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) 
> while carrying a waist-mounted smartphone with embedded inertial sensors."

[site where data is obtained](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[zipped data for the project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)



### This repository contains the following files:

* 'run_analysis.R': Used for data processing - downloading, unzipping, loading data into data frames...
* 'CodeBook.md': Contains further explanation of the journey to get to the point of clean/tidy data
+ 'README.md': Contains description of how the run_analysis.R script works


The run_analysis.R script downloads and saves the data to the /data directory (creates one if it does not exist yet).

The data is unzipped using the function below. 
```R
unzip(zipfile = <zip-file-path>, exdir = <where to place unzipped folder and/or files>)
```

Several data frames are then created by reading the files we are interested in from the unzipped location. 
```R
read.table(<file-path>)
```

After that, each data frame related to the test data is merged with a similar data frame related to the train data using: 
```R
combinedActivityLabels <- rbind(testActivityLabels, trainingActivityLabels)
combinedSubjects <- rbind(testSubjects, trainingSubjects)
combinedDataset <- rbind(testDataset, trainingDataset)
```

#### Note:

1. _*ActivityLabels_, _*Subjects_, and _*Dataset_ are the data frames created when _read.table()_ was used to load the data from the unzipped files.
2. Each new data frame has the rows of the train data frame after the rows of the test dataframe.


The _features.txt_ file contains the column names (features) for the _combinedDataset_ data frame shown above. Using this knowledge, the column names are filtered down to only those having "mean" or "std" in their name.
Subsetting the data frame for the matched columns creates a new data frame _usefulCombinedDataset_.

The data from the data frames _combinedActivityLabels_ and _combinedSubjects_ is used to add two more columns to the data frame _usefulCombinedDataset_. This makes sense because each row in _usefulCombinedDataset_ is for a particular subject carrying out a particular activity.

Using the "dplyr" R package, the _usefulCombinedDataset_ data frame is grouped by _activity_, then _subject_. With this grouping, a summary is done on every column but the last two (since they are the grouping factors) so as to get the average of all the columns.
In this particular case, I created a data frame called _aggregatedSummary_ and setting that to the summary statistics (average or mean) of only the first column in _usefulCombinedDataset_. I then used a _for loop_ to do the same thing for every column (feature) in _usefulCombinedDataset_ but the last two.

To finish tidying up the data, I also chose to use column names with the pattern _avgf1_, _avgf2_, instead of _V1_, _V2_ that was autoassigned when the data was loaded from file. This reads __"average for feature ...?number"__. This choice was done simply to reference the data from the _features.txt_ file that had the features (column names).
It does not pay to redo something that already works well so keeping the original column names and referencing them by their number makes it easy to know that _avgf44_, for example, is the __"average for feaure 44"__. Looking at the featues data gives us _"tGravityAcc-std()-X"_ for feature number 44.



You can use 
```R
tempDataFrame <- read.table(<path-to-file>, header = TRUE)
```
to load tidy data written to *.txt file.





