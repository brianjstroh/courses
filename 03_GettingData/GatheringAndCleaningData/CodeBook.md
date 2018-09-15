## CodeBook for run_analysis.R
### Output Variables:
data_source - The subdirectory from which the data was derived. Levels of train and test.  
subject - The test subject involved in this iteration of the experiment.  
activity - The activity performed by this test subject.  
feature - The description of the measurement recorded by the phone's accelerometers.  
statistic - Indicates whether the mean value is the averages of the means or standard deviations.  
dimension - Direction of reading from the phone's accelerometers. Levels of magnitude, x, y, and z.  
mean - Average of values recorded from the phone's accelerometers, indicative of the corresponding statistic.  


#### The source data code book from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones describes the data collection methods as follows:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).  


### Gathering the data
The various datasets are downloaded from the source URL in a zip file: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
Using the utils function unzip(), the data is extracted into the user's working directory,
and the list of files is read into a data frame.

### Tidying the data
#### Initial Notes
The source data is all in space-delimited text format, so read.table is used throughout the script, using " " as the seperating character.

#### Reading in the universal tables
The first two data tables (UCI HAR Dataset/activity_labels.txt and UCI HAR Dataset/features.txt) are read in to the global environment.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-These are used to better describe the data in the X_... source files.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-These tables are assigned appropriate column names that will be used to merge data later.  

#### Reading in the test and train data
The same exact procedures are used to read and tidy the data for both the test and train sources:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The subject_.txt file is read into a dataframe.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The y_.txt file is read into the second column of this same dataframe.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-This file indicates the activity number for each record in the corresponding X_.txt file.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Using the activity_labels dataframe, the values in this second column are overwritten with the activity descriptions.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The second column is then renamed to reflect that this field now provides the description for each activity.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The X_.txt file is read into the third column of this same dataframe.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-This read.table call purposefully uses the "," separator instead of " ", so that all of the data is read into one column.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The double spaces are removed from this 3rd column, so that no NA values are created when the data is separated.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Leading and trailing white spaces are also removed from this field.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The next line accomplishes multiple tasks:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-A field is added to the beginning of the data frame, which describes the name of the source data.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The cleaned last column is seperated into multiple columns on each " " character.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The names of these new columns are assigned as the descriptions that were read in to the features dataframe.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-The new feature columns are all parsed to numeric fields so that the mean function can be applied to these later.  

### Building the full_dataset
-The rbind function is used to append the cleaned train dataframe to the cleaned test dataframe.  
-Each of the features not containing the mean() or std() statistics are removed from this dataframe.  
-The feautures indicating the magnitude of the measurement are reformatted to match the names of their X,Y,Z counterparts.  
-The melt function is used to stack each of the features into a single column, with it's respective values being stored in a new column.  
-The feature field is separated into description, statistic (indicating mean or std), and dimension (indicating X,Y,Z, or magnitude) columns.  
-The parenthesis are then removed from the statistic column for concision reasons, and certain substrings are replaced with more descriptive verbiage.  

### Summarizing the full_dataset
-Using the aggregate function, the means of values for each data_source, subject, activity, feature, statistic, dimesion cohort is calculated and stored in the averages dataframe.  
-The column names are set to match the names of the full_dataset dataframe, with the exception of the new mean field.  
-The upper-case letters in the activity and dimension fields are converted to lower-case, and the data is now tidy.  

### Storing the data
-The script then stores the new averages dataframe in an R object in the local working directory.  
-Additionally the script stores the averages dataframe in text format so that it can be visualized outside of R easily as well.  
