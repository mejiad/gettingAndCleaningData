##
## libraries required to process the raw data files
##
library(dplyr)
library(reshape)

##
## Definition of local functions.
##

##
## readXFiles: function to read the X_ file that contains the measures data
## directory: Path where the X_ file is stored
## name of the file to load
## 
readXFiles <- function(directory, filename) {
  path <- paste(directory, filename, sep ="/")
  xfile <- read.csv(path, header=FALSE, sep = "")
  xfile
}

##
## readFeatures: function to read the numeric data of features.txt that 
## corresponds to every column description
##
  readFeatures <- function(directory, filename="features.txt"){
    path <- paste(directory, filename, sep="/")
    features <- read.delim(path, header = FALSE, sep = " ")
    lstFeatures <- sapply(features[,2], as.character)
    lstFeatures
  }


##
## readActivities: reads the data in the y_file that contains the information of activities 
## this information comes in numeric data and should be converted to a string factor
##
readActivities <- function(directory, filename){
  path <- paste(directory, filename, sep="/")
  yfile <- read.fwf(path, c(1))
  yfile
}


readActivitiesLabels <- function(directory, filename="activity_labels.txt"){
  path <- paste(directory, filename, sep="/")
  labels <- read.csv(path, sep = " ", header = FALSE)
  labels[,2]
}
##
## readSubject: read the information of the subject_[test|train].txt file that contains the 
## key of every subject.
##
readSubject <- function(directory, filename){ 
  path = paste(directory, filename, sep = "/")
  subject <- read.delim(path, header = FALSE, sep = " ")
  subject
}

##
## This is the controller function that calls all the required local function
## to load and process the three files: X_[train|test].txt, y_[train|test].txt and 
## subject_[train|test].txt.
## 
## readData: read the data from the specified directory and returns a data frame 
## with all the information of subject, activity and variables
## arguments:
##    from: the directory where the project is stored. In our case is all hye path to 'UCI HAR Dataset'
##    type: type of data to load, valid values are 'test' and 'train' that corresponds to each different
##          directory where the data is stored
##
## use example: readData("~/CursoDS/Curso3/week4/UCI HAR Dataset", "test")
## returns the merged data frame with the information of subject, activity and variables
##
readData <- function( from, type) {
  x_filename <- paste("X_", type, ".txt", sep ="")
  typeDir <- paste(from, type, sep ="/")
  xfile <- readXFiles(typeDir, x_filename)
  
  lstFeatures <- readFeatures(from)
  names(xfile) <- lstFeatures
  
  activities_filename <- paste("y_", type, ".txt", sep ="")
  activitiesDir <- paste(from, type, sep ="/")
  yfile <- readActivities(activitiesDir, activities_filename)
  xWithActivity <- cbind(yfile, xfile)
  
  ## * 4. Appropiately label the data set with the descriptive variable names
  ## rename columns to valid names
  valid_column_names <- make.names(names=names(xWithActivity), unique=TRUE, allow_ = TRUE)
  names(xWithActivity) <- valid_column_names
  xWithActivity <- dplyr::rename(xWithActivity, activity = V1)
  
  ## convert to factor activity column
  xWithActivity$activity <- factor(xWithActivity$activity)
  
  
  ## * 3. Use descriptive activity names to name the activities in the data set
  ## assign string levels 
  lstLabels <- readActivitiesLabels(from)
  ## levels(xWithActivity$activity) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
  levels(xWithActivity$activity) <- lstLabels
  
  
  ## read subject data
  subject_filename <- paste("subject_", type, ".txt", sep="")
  subjectDir <- paste(from, type, sep="/")
  subject <- readSubject(subjectDir, subject_filename)
  xWithActivityAndSubject <- cbind(subject, xWithActivity)
  
  ## rename added column and change to factor type
  xWithActivityAndSubject <- dplyr::rename(xWithActivityAndSubject, subject = V1)
  xWithActivityAndSubject$subject <- factor(xWithActivityAndSubject$subject)
  
  # return value contains all the information of subject and variables
  xWithActivityAndSubject
  
}

##
## Here is where the process starts
##

##
## main 
## function that is the 
## 
main <- function(directory) {
  ## get the test data frame
  directory <- paste(directory, "UCI HAR Dataset", sep ="/")
  testDF <- readData(directory, "test")
  
  ## get the train data frame
  trainDF <- readData(directory, "train")
  
  ## merge both data frames
  resultBind <- rbind(testDF, trainDF)
  
  ## * 2. Extract only the measurements on the mean and the standard deviation for each measurements
  ## select only the mean and std variables
  result <- select(resultBind, contains("subject"), contains("activity"), contains(".mean.."), contains(".std.."))
  
  ## convert to rows the variables
  resultReshaped <- melt(result, id=c("subject", "activity"))
  
  ## * 5. From the data set in step 4, create a second, independently tidy data set with 
  ##      the average of each variable for each activity and each subject.
  ##  calculate the mean of every variable group by subject, activity and variable
  resultadoFinal <- group_by(resultReshaped, subject, activity, variable) %>% summarise(mean = mean(value))
  
  ## 
  resultadoFinal$variable <- gsub("\\.+", "", resultadoFinal$variable)
  resultadoFinal$variable <- gsub("\\.$", "", resultadoFinal$variable)
  resultadoFinal$variable <- gsub("mean", "Mean", resultadoFinal$variable)
  resultadoFinal$variable <- gsub("std", "Std", resultadoFinal$variable)
  ## resultadoFinal$variable <- tolower(resultadoFinal$variable)
  ## resultadoFinal$variable <- gsub("\\.", " ", resultadoFinal$variable)
  
  ## final result
  finalresultPath <- paste(directory, "result.csv", sep ="/")
  write.csv(resultadoFinal, file = finalresultPath, row.names = FALSE)
  resultadoFinal          
}

## 
## You should change the directory to the place where the 'UCI HAR Dataset' directory 
## is located in the hard disk.
##
## main("~/CursoDS/Curso3/week4/UCI HAR Dataset")
