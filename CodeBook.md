
# DATA DICTIONARY

##Getting and Cleaning Data Course Project
In this document each column of the result data frame is described.



##subject: Subject code
            - Factor with 30 levels
            - levels: 1..30

##activity: The name of each activity in the sample. 
            -  Factor with six levels
            1 WALKING
            2 WALKING_UPSTAIRS
            3 WALKING_DOWNSTAIRS
            4 SITTING
            5 STANDING
            6 LAYING

##variable: Variables of measures 
            - char value
            - The following variables are the result of selecting just the Mean and Std variables from the base list of variables.
            -  values are:
                tBodyAccMeanX          
                tBodyAccMeanY           
                tBodyAccMeanZ           
                tGravityAccMeanX       
                tGravityAccMeanY        
                tGravityAccMeanZ        
                tBodyAccJerkMeanX      
                tBodyAccJerkMeanY       
                tBodyAccJerkMeanZ       
                tBodyGyroMeanX         
                tBodyGyroMeanY          
                tBodyGyroMeanZ          
                tBodyGyroJerkMeanX     
                tBodyGyroJerkMeanY      
                tBodyGyroJerkMeanZ      
                tBodyAccMagMean         
                tGravityAccMagMean       
                tBodyAccJerkMagMean      
                tBodyGyroMagMean        
                tBodyGyroJerkMagMean     
                fBodyAccMeanX           
                fBodyAccMeanY          
                fBodyAccMeanZ           
                fBodyAccJerkMeanX       
                fBodyAccJerkMeanY      
                fBodyAccJerkMeanZ       
                fBodyGyroMeanX          
                fBodyGyroMeanY         
                fBodyGyroMeanZ          
                fBodyAccMagMean          
                fBodyBodyAccJerkMagMean 
                fBodyBodyGyroMagMean     
                fBodyBodyGyroJerkMagMean 
                tBodyAccStdX           
                tBodyAccStdY            
                tBodyAccStdZ            
                tGravityAccStdX        
                tGravityAccStdY         
                tGravityAccStdZ         
                tBodyAccJerkStdX       
                tBodyAccJerkStdY        
                tBodyAccJerkStdZ        
                tBodyGyroStdX          
                tBodyGyroStdY           
                tBodyGyroStdZ           
                tBodyGyroJerkStdX      
                tBodyGyroJerkStdY       
                tBodyGyroJerkStdZ       
                tBodyAccMagStd          
                tGravityAccMagStd        
                tBodyAccJerkMagStd       
                tBodyGyroMagStd         
                tBodyGyroJerkMagStd      
                fBodyAccStdX            
                fBodyAccStdY           
                fBodyAccStdZ            
                fBodyAccJerkStdX        
                fBodyAccJerkStdY       
                fBodyAccJerkStdZ        
                fBodyGyroStdX           
                fBodyGyroStdY          
                fBodyGyroStdZ           
                fBodyAccMagStd           
                fBodyBodyAccJerkMagStd  
                fBodyBodyGyroMagStd      
                fBodyBodyGyroJerkMagStd 


##mean: Value of the mean for every Subject, activity and variable
                - numeric value 
                - range of values from -0.9976661 to 0.9745087


