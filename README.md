## Getting and Cleaning Data Course Project
Daniel Mejia  
Coursera Data Science  
Course: Getting and Cleaning Data  
mejiad@evol-tech.com  




# Table of contents
1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Plan to solve each requirement](#plan)
4. [1. Merge the training and test sets to create one data set](#one)
5. [2. Extract only the measurements on the mean and the standard deviation for each measurements](#two)
6. [3. Use descriptive activity names to name the activities in the data set](#three)
7. [4. Appropiately label the data set with the descriptive variable names](#four)
8. [5. From the data set in step 4, create a second, independently tidy data set with the average of each variable for each activity and each subject.](#five)
9. [How to run the script](#run)
10. [How to load the result data set](#load)
11. [License](#license)


Introduction <a name="introduction"></a>
======================

This document describe the process to tidy and reshape the files to obtain the required 
variables and their mean.

Requirements <a name="requirements"></a>
======================

The assigment requires to:

1. Merge the training and test sets to create one data set
2. Extract only the measurements on the mean and the standard deviation for each measurements
3. Use descriptive activity names to name the activities in the data set
4. Appropiately label the data set with the descriptive variable names
5. From the data set in step 4, create a second, independently tidy data set with the average of each variable for each activity and each subject.


#Plan to solve each requirement <a name="plan"></a>
The steps to solve every requirement are describe in the following paragraphs. The part of code that is required for each step is explained. The script is commented to try to explain the functionality of every part  of code, but in this document the most important part of the functions are explained.

## 1. Merge the training and test sets to create one data set <a name="one"></a>

In order to know what files should be merged we need to read the README.txt from the original data set, document that is provided with the data files in the zip file. In this document we can identify what information is in every files and what are required to accomplish the task. 

The content of every files is defined as:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features. The name of every column of the X_ files.

- 'activity_labels.txt': Links the class labels with their activity name. The labels in the X_test.txt and X_train.txt.
                        
- 'train/X_train.txt': Training set. The data defined in 'features.txt', the files has 561 columns each one corresponds to every feature.

- 'train/y_train.txt': Training labels. This files has the number of every subject. Codified in numeric value.

- 'test/X_test.txt': Test set. Similar a X_train.txt

- 'test/y_test.txt': Test labels. Similar as y_train.txt

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 




The following files are not necessary to complete the Coursera requirement.

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


Activities requiered to solve every requirement


First in required to know what we have in the directory that was provided to these tasks. Mos of the information 
is explained in the README.txt that comes with the data. 


The information provided comes in a differente directories and files. The content in the zip files is:

```
└── UCI\ HAR\ Dataset
    ├── README.txt
    ├── activity_labels.txt
    ├── features.txt
    ├── features_info.txt
    ├── test
    │   ├── Inertial\ Signals
    │   │   ├── body_acc_x_test.txt
    │   │   ├── body_acc_y_test.txt
    │   │   ├── body_acc_z_test.txt
    │   │   ├── body_gyro_x_test.txt
    │   │   ├── body_gyro_y_test.txt
    │   │   ├── body_gyro_z_test.txt
    │   │   ├── total_acc_x_test.txt
    │   │   ├── total_acc_y_test.txt
    │   │   └── total_acc_z_test.txt
    │   ├── X_test.txt
    │   ├── subject_test.txt
    │   └── y_test.txt
    └── train
        ├── Inertial\ Signals
        │   ├── body_acc_x_train.txt
        │   ├── body_acc_y_train.txt
        │   ├── body_acc_z_train.txt
        │   ├── body_gyro_x_train.txt
        │   ├── body_gyro_y_train.txt
        │   ├── body_gyro_z_train.txt
        │   ├── total_acc_x_train.txt
        │   ├── total_acc_y_train.txt
        │   └── total_acc_z_train.txt
        ├── X_train.txt
        ├── subject_train.txt
        └── y_train.txt

```


After listing the directories we can see that there are two directories, test and train that contains 
the a set of files. The question is what files we need to consider to the assigment and what data contains every file.

(I used the test as example, this description apply the same for both, test and train files)
The names of the files indicates what is contained in the file. The subject_test.txt and the subject_test.txt contains a subject information.
The y_test.txt is a file with the activity for each row, every activity comes in a numeric code. To know what number corresponds to what activity we
need to use the information in the activity_labels.txt. In this case I'm considering that the first activity in this file corresponds to the numebr one in the y_train.txt file.

The most important file is the X_train.txt, this file contains the mesurements listed in the features.txt. If we check the content of this file we 
find that the file has 561 columns and 2947 rows. This number of rows corresponds to the same number of rows in the subject and y_test.txt files, 
for this reason I consider that every row of those files corresponds to every row in he X_train.txt file.

Files Relationship  


       subject_test.txt -----> X_test.txt <---------- y_test.txt (activity)
       ^                                                     ^
       |                                                     |
       |                                                     |
       +---------------- every row corresponds --------------+                        
                        to one row in X_test.txt



With this information we can process the files to complete the tasks required in the course.

After the required files were identified we can proceed to write the code to merge these files.

To merge these files three functions are defined:  

```
readXFiles <- function(directory, filename) {
  path <- paste(directory, filename, sep ="/")
  xfile <- read.csv(path, header=FALSE, sep = "")
  xfile
}  

readActivities <- function(directory, filename){  
  path <- paste(directory, filename, sep="/")
  yfile <- read.fwf(path, c(1))
  yfile
}  

readSubject <- function(directory, filename){  
  path = paste(directory, filename, sep = "/")
  subject <- read.delim(path, header = FALSE, sep = " ")
  subject
}
```

The idea to write functions is to reuse these code for the train and test data sets.

**readXFiles**: reads the files with the measurements (X_[train | test]) and return a data frame.

**ReadActivities**: Reads the y_[train | test].txt file and return a vector with the number of activity for each row.

**readSubject**: This function reads the subject_[train | test].txt file.

With all the information loaded in R we can join this data to obtain the measurements, the subject and the activity in one big data frame.


## 2. Extract only the measurements on the mean and the standard deviation for each measurements <a name="two"></a>


Before we can realize this point we need to name every column of the data frame. To do this we need to read the names from the features.txt file. To do this the readFeatures function was defined.

```
readFeatures <- function(directory, filename="features.txt"){
  path <- paste(directory, filename, sep="/")
  features <- read.delim(path, header = FALSE, sep = " ")
  lstFeatures <- sapply(features[,2], as.character)
  lstFeatures
}
```

This function reads from the hard disk the data with the columns name, with this list we can assign the name of the data frame loaded with the readXFiles, before merge with the other files. Teh code to do this is shown:

```
  xfile <- readXFiles(typeDir, x_filename)
  
  lstFeatures <- readFeatures(from)
  names(xfile) <- lstFeatures
```

In the last line of the previous code we assign the name of the columns.



## 3. Use descriptive activity names to name the activities in the data set <a name="three"></a>

The activities are stored in the y_[train | test].txt files. We need to read this data, merge with teh X_file and convert to Factor, assigning levels to the data from the activity_labels.txt.

Function to read factor labels

```
readActivitiesLabels <- function(directory, filename="activity_labels.txt"){
  path <- paste(directory, filename, sep="/")
  labels <- read.csv(path, sep = " ", header = FALSE)
  labels[,2]
}
```

To convert the data to factor and assign labels:

```
  lstLabels <- readActivitiesLabels(from)
  levels(xWithActivity$activity) <- lstLabels

```


## 4. Appropiately label the data set with the descriptive variable names <a name="four"></a>

To labels the data set we need to read the "features.txt" file and set the names of the data frame to this list.

```
readFeatures <- function(directory, filename="features.txt"){
  path <- paste(directory, filename, sep="/")
  features <- read.delim(path, header = FALSE, sep = " ")
  lstFeatures <- sapply(features[,2], as.character)
  lstFeatures
}

lstFeatures <- readFeatures(from)
names(xfile) <- lstFeatures

```

one issue with this point is that the names has characters not valid for names, for that reason we need to process the names to convert invalid characters to valid column names.

```
valid_column_names <- make.names(names=names(xWithActivity), unique=TRUE, allow_ = TRUE)
names(xWithActivity) <- valid_column_names
```

This code converts invalid names to valid names, replacing invalid characters to the '.' character. The names resulting of this change has many dot charactes. The names are processed to get more legible names. The following code show how the names are changed.

```
  resultadoFinal$variable <- gsub("\\.+", "", resultadoFinal$variable)
  resultadoFinal$variable <- gsub("\\.$", "", resultadoFinal$variable)
  resultadoFinal$variable <- gsub("mean", "Mean", resultadoFinal$variable)
  resultadoFinal$variable <- gsub("std", "Std", resultadoFinal$variable)
```

## 5. From the data set in step 4, create a second, independently tidy data set with the average of each variable for each activity and each subject. <a name="five"></a>

In order to calculate the mean fo every variable for each activity and each subject we need to have a most efficient structure to do this. One option is to have the data in the long format, something like this:

```
Subject 	Activity	variable	value
	1		WALKING		X			y	
	.			.			.			.	
	.			.			.			.
	.			.			.			.
	
```

With this format the calculation is easier to do. To convert our wide format to long format we need to use the follwoing code:

```
  resultadoFinal <- group_by(resultReshaped, subject, activity, variable) %>% summarise(avg = mean(value))
```

With this code the information is grouped by subject, activity and variable and the summarise calculates the mean for each variable.

The result of all process is something like this:

```

   subject activity          variable         mean
    <fctr>   <fctr>             <chr>        <dbl>
1        2  WALKING     tBodyAccMeanX  0.276426586
2        2  WALKING     tBodyAccMeanY -0.018594920
3        2  WALKING     tBodyAccMeanZ -0.105500358
4        2  WALKING  tGravityAccMeanX  0.913017333
5        2  WALKING  tGravityAccMeanY -0.346607090
6        2  WALKING  tGravityAccMeanZ  0.084727087
7        2  WALKING tBodyAccJerkMeanX  0.061808070
8        2  WALKING tBodyAccJerkMeanY  0.018249268
9        2  WALKING tBodyAccJerkMeanZ  0.007895337
10       2  WALKING    tBodyGyroMeanX -0.053025816
```

We get the mean for every subject, activity and variable.


## How to run the script <a name="run"></a>
The script should be loaded to R with the following code:

```
# Move to the directory where the project is stored. Exactly one directory up of the dir 'UCI HAR Dataset' is.

# **IMPORTANT NOTE**: You need to change the directory where the UCI HAR Dataset is stored
> setwd("path where he script is in the disk")

# Load the code
> source("run_analysis.R")

# run the program. 
# **IMPORTANT NOTE**: You need to change the directory where the UCI HAR Dataset is stored
# if you are in the project directory the scritp can be run as follows:

> main(".")

```


## How to load the result data set <a name="load"></a>

To load the result set we need to move to the directory where the project was stored and run the follworing command:

```
resultDS <- read.csv("result.csv")
```

License: <a name="license"></a>
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
