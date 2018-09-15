###################################################################################################################################
###################################################################################################################################
#####################################################RUN_ANALYSIS.R - Brian Stroh##################################################
###################################################################################################################################
#### The purpose of this script is to reformat the data from the datasets created from the UCI activity recognition ###############
#### experiment into a tidy dataset that is comprehensive, descriptive and succinct. Additionally, the output will ##############
#### include a summary of the mean and standard deviation statistics for each source, activity, feature and dimension #############
#### cohort. A detailed description of the script can be found in the CodeBook.md file. ###########################################
###################################################################################################################################
###################################################################################################################################

library(tidyr)
library(plyr)
library(dplyr)
library(reshape2)

#This code block will download this project's source data, unzip it in the working directory, and extract a list of the file names.
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "projectFiles.zip")
unzip("projectFiles.zip")
file_paths<-unzip("projectFiles.zip",list=TRUE)[,1]

#Reads in the data containing the activity and feauture indices
activity_labels<-read.table(file_paths[1],sep=" ",col.names = c("activity_number","description"))
features<-file_paths[2] %>% read.table(sep=" ",col.names = c("feature_number","description"))

#Reads in the data from the test cohort of subjects and their subsequent feature measurements
test<-read.table(file_paths[16],col.names = "subject")
test[,2]<-read.table(file_paths[18],col.names = "activity_number")
test[,2]<-join(test,activity_labels,by="activity_number")[,3]     #<-This will overwrite the activity numbers with their descriptions
test<-rename(test,activity=activity_number)
test<-cbind(test,read.table(file_paths[17],col.names = "X",sep=","))
test[,3]<-trimws(gsub(pattern="  ", replacement=" ",x=test[,3]))        #<-Removes extra white space from the source data
test<-cbind(data_source=rep("test",nrow(test)),test[,1:2],separate(test[3],col="X",into=as.character(features$description), sep=" "))
test[,4:ncol(test)]<-mutate_all(test[,4:ncol(test)], as.numeric)  #<-Parses the measurements as numeric instead of factors

#Reads in the data from the train cohort of subjects and their subsequent feature measurements
train<-read.table(file_paths[30],col.names = "subject")
train[,2]<-read.table(file_paths[32],col.names = "activity_number")
train[,2]<-join(train,activity_labels,by="activity_number")[,3]   #<-This will overwrite the activity numbers with their descriptions
train<-rename(train,activity=activity_number)
train<-cbind(train,read.table(file_paths[31],col.names = "X",sep=","))
train[,3]<-trimws(gsub(pattern="  ", replacement=" ",x=train[,3]))      #<-Removes extra white space from the source data
train<-cbind(data_source=rep("train",nrow(train)),train[,1:2],separate(train[3],col="X",into=as.character(features$description), sep=" "))
train[,4:ncol(train)]<-mutate_all(train[,4:ncol(train)], as.numeric)    #<-Parses the measurements as numeric instead of factors


full_dataset<-rbind(test,train)     #<-appends the train dataset to the test dataset and stores the result in full_dataset
keep<-names(full_dataset) %>% grep(pattern="mean\\(\\)|std\\(\\)")
full_dataset<-full_dataset[,c(1:3,keep)]  #<-removes all feature data except for the mean and standard deviation

#This code block will format the _Mag variables to be consistent with the X,Y,Z variables
keep<-grep(pattern="Mag-",names(full_dataset))
names(full_dataset)[keep]<-paste0(gsub(pattern="Mag",replacement = "",names(full_dataset)[keep]),"-magnitude")

#This line stacks all of the feature descriptions and values in a longer but more narrow dataset
full_dataset<-melt(full_dataset,id.vars=names(full_dataset[,1:3]),variable.name = "feature")

#This line splits up the feature description so that we can effectively group by measurement type and dimension
full_dataset<-separate(full_dataset,col="feature",into=c("feature","statistic", "dimension"),sep="-")

#Removes the extra parenthesis from the measurement field.
full_dataset$statistic<- gsub(pattern="\\(\\)",replacement = "",full_dataset$statistic)

#Calculates the average of both the mean and standard deviation across all other variables
attach(full_dataset)
averages<-aggregate(value,by=list(data_source,subject,activity,feature,statistic,dimension),FUN = "mean")
detach(full_dataset)
colnames(averages)<-c(colnames(full_dataset)[1:length(colnames(full_dataset))-1],"means")

#After this code block, the data is now tidy. There is a unqiue and descriptive record for each record in the final dataset
averages$activity<-tolower(averages$activity)
averages$dimension<-tolower(averages$dimension)
averages$feature<-tolower(sub("^f","frequency_",averages$feature))
averages$feature<-tolower(sub("^t","time_",averages$feature))
averages$feature<-tolower(sub("_bodybody","_body_",averages$feature))
averages$feature<-tolower(sub("acc","_acceleration_",averages$feature))
averages$feature<-tolower(sub("_$","",averages$feature))
averages$feature<-tolower(sub("__","_",averages$feature))

#Saves the final result to the user's working directory
save(averages,file="run_analysis_output")
write.table(averages,file = "run_analysis_output.txt", sep=" ", row.names = FALSE)
