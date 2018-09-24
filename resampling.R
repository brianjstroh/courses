library(dplyr)

data("ToothGrowth")

d.5<-filter(ToothGrowth,dose==.5)
d1<-filter(ToothGrowth,dose==1)
d2<-filter(ToothGrowth,dose==2)

reSample<-function(n=1000,yVar=3){
      rows.5<-sample(1:nrow(d.5),size=n,replace=TRUE)
      rows1<-sample(1:nrow(d1),size=n,replace=TRUE)
      rows2<-sample(1:nrow(d2),size=n,replace=TRUE)
      
      dSamp.5<-d.5[rows.5,c(1,yVar)]
      dSamp1<-d1[rows1,c(1,yVar)]
      dSamp2<-d2[rows2,c(1,yVar)]
      
      d.5_avg<-mean(dSamp.5$len)
      d1_avg<-mean(dSamp1$len)
      d2_avg<-mean(dSamp2$len)
      
      return(c(d.5_avg,d1_avg,d2_avg))
}

myRep<-t(replicate(10000,reSample()))

summary(myRep[,1])
summary(myRep[,2])
summary(myRep[,3])

mean(d.5$len)
mean(d1$len)
mean(d2$len)
