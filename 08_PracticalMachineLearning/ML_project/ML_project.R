library(caret)
library(dplyr)
library(rattle)
library(caretEnsemble)

download.file(url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv", destfile = "train_data.csv")
download.file(url = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv", destfile = "test_data.csv")

set.seed(42)

training<-read.csv("train_data.csv")
testing<-read.csv("test_data.csv")

getNAProportion<-function(df){
      colSums(is.na(df)*1)/nrow(df)
}


#Fix errors and remove variables with near zero variance
errorrows<-rowSums((training=="#DIV/0!")*1, na.rm = TRUE)
training<-training[errorrows==0,]
training<-training[,getNAProportion(training)!=1]
training<-training[,((nearZeroVar(training, saveMetrics= TRUE)$nzv*1)==0)]

testing<-testing[,getNAProportion(testing)!=1]
testing<-testing[,((nearZeroVar(testing, saveMetrics= TRUE)$nzv*1)==0)]

inTrain<-createDataPartition(training$classe,p=.75,list=FALSE)
newTrain<-training[inTrain,-1]
newTest<-training[-inTrain,-1]

treeFit <- train(classe ~ ., data=newTrain, method="rpart")
fancyRpartPlot(treeFit$finalModel)

predtree<-predict(treeFit,newdata = newTest)
confusionMatrix(predtree,newTest$classe)

#From https://github.com/lgreski/datasciencectacontent/blob/master/markdown/pml-randomForestPerformance.md
fitControl <- trainControl(method = "cv", number = 10, allowParallel = TRUE)
parallelforestFit <- train(classe ~ ., data=newTrain, method="rf", trControl=fitControl)
predpforest<-predict(parallelforestFit,newdata = newTest)
confusionMatrix(predpforest,newTest$classe)

boostFit <- train(classe ~ ., data=newTrain, method="gbm")
predboost<-predict(boostFit,newdata = newTest)
confusionMatrix(predboost,newTest$classe)

#Final Results
predforest2<-predict(parallelforestFit,newdata = testing)

