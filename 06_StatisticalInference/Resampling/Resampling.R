library(dplyr)
library(reshape2)
library(ggplot2)

#Null Hypothesis would be that the average tooth growth is identical across all doses of all supplements


data("ToothGrowth")

d.5<-filter(ToothGrowth,dose==.5)
d1<-filter(ToothGrowth,dose==1)
d2<-filter(ToothGrowth,dose==2)
sOJ<-filter(ToothGrowth,supp=="OJ")
sVC<-filter(ToothGrowth,supp=="VC")



#~~~~~~~~~~~~~~~~~~~~~~~~RESAMPLING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

reSample_Dose<-function(n=1000,yVar=3){
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

mySample<-data.frame(t(replicate(10000,reSample_Dose(n=20))))
names(mySample) <- c("dose.5","dose1","dose2")
mySampleMelt<-melt(mySample)
names(mySampleMelt)<-c("dose","tooth.length")
ggplot(mySampleMelt,aes(x=tooth.length, color = dose)) +
      geom_histogram(binwidth = .01)

reSample_Supp<-function(n=1000,yVar=2){
      rowsOJ<-sample(1:nrow(sOJ),size=n,replace=TRUE)
      rowsVC<-sample(1:nrow(sVC),size=n,replace=TRUE)
      
      sSampOJ<-sOJ[rowsOJ,c(1,yVar)]
      sSampVC<-sVC[rowsVC,c(1,yVar)]
      
      OJ_avg<-mean(sSampOJ$len)
      VC_avg<-mean(sSampVC$len)
      
      return(c(OJ_avg,VC_avg))
}

mySample2<-data.frame(t(replicate(10000,reSample_Supp(n=30))))
names(mySample2) <- c("suppOJ","suppVC")
mySampleMelt2<-melt(mySample2)
names(mySampleMelt2)<-c("supp","tooth.length")
ggplot(mySampleMelt2,aes(x=tooth.length, color = supp)) +
      geom_histogram(binwidth = .01)



#~~~~~~~~~~~~~~~~~~~~~~~~HYPOTHESIS TESTING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Null Hypothesis is: the average tooth growth is identical across all doses and all supplements

data("ToothGrowth")

d.5<-filter(ToothGrowth,dose==.5)
d1<-filter(ToothGrowth,dose==1)
d2<-filter(ToothGrowth,dose==2)

t.test(len~dose,paired=FALSE,data=rbind(d1,d.5))
t.test(len~dose,paired=FALSE,data=rbind(d2,d1))
t.test(len~dose,paired=FALSE,data=rbind(d2,d.5))
t.test(len~supp,paired=FALSE,data=ToothGrowth)
