library(caret)
library(dplyr)

download.file(url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", destfile = "train_data.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", destfile = "test_data.csv")

training<-read.csv("train_data.csv")
testing<-read.csv("test_data.csv")

#Fix errors
errorrows<-rowSums((training=="#DIV/0!")*1, na.rm = TRUE)
training<-training[errorrows==0,]
training<-training[,getNAProportion(training)!=1]
training<-training[,((nearZeroVar(training, saveMetrics= TRUE)$nzv*1)==0)]
summary(training$kurtosis_picth_belt)
str()

getNAProportion<-function(df){
      colSums(is.na(df)*1)/nrow(df)
}

traintest<-cbind(as.data.frame(predict(dummyVars(classe~.,training), newdata = training)),training$classe)
names(traintest)<-c(names(traintest)[1:(length(traintest)-1)],"classe")
str(traintest)