library(caret)
library(dplyr)
library(rattle)

download.file(url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", destfile = "train_data.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", destfile = "test_data.csv")

training<-read.csv("train_data.csv")
testing<-read.csv("test_data.csv")

getNAProportion<-function(df){
      colSums(is.na(df)*1)/nrow(df)
}


#Fix errors
errorrows<-rowSums((training=="#DIV/0!")*1, na.rm = TRUE)
training<-training[errorrows==0,]
training<-training[,getNAProportion(training)!=1]
training<-training[,((nearZeroVar(training, saveMetrics= TRUE)$nzv*1)==0)]

inTrain<-createDataPartition(training$classe,p=.75,list=FALSE)
newTrain<-training[inTrain,-1]
newTest<-training[-inTrain,-1]

treeFit <- train(classe ~ ., data=newTrain, method="rpart")
fancyRpartPlot(treeFit$finalModel)

predclasse<-predict(treeFit,newdata = newTest)
confusionMatrix(predclasse,newTest$classe)

forestFit <- train(classe ~ ., data=newTrain, method="rf")
predforest<-predict(forestFit,newdata = newTest)
confusionMatrix(predforest,newTest$classe)
