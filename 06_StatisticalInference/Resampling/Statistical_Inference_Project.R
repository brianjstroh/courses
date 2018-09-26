library(dplyr)
library(ggplot2)
library(gridExtra)
set.seed(51)

mySample<-matrix(rexp(n=40*1000, rate = .2),40,1000)
Means<-colSums(mySample)/40 
Variances<-colSums(mySample^2)/40-(colSums(mySample)/40)^2
mySampleStats<-tbl_df(cbind(Means,Variances))

summary(Means)
summary(Variances)

myNorm<-rnorm(n=1000, mean=mean(Means),sd=mean(sqrt(Variances)))

ggplot(mySampleStats, aes(x = Means, mean = mean(mySampleStats$Means), sd = sqrt(var(mySampleStats$Means)), binwidth = .2, n = nrow(mySampleStats))) +
      theme_dark() +
      geom_histogram(binwidth = .2, colour = "white", fill = "blue", size = 0.1) +
      stat_function(fun = function(x) dnorm(x, mean = mean(mySampleStats$Means), sd = sqrt(var(mySampleStats$Means))) * nrow(mySampleStats) * .2,aes(color = "Normal_Distribution"), size =1)+
      geom_vline(aes(xintercept = (1/.2), color = "Theoretical_Mean"), linetype="dashed", size=1.5) +
      geom_vline(aes(xintercept = mean(mySampleStats$Means), color = "Sample_Mean"), size=1) +
      scale_color_manual(name = "Chart Element", values = c(Theoretical_Mean = "green", Sample_Mean = "magenta", Normal_Distribution = "red"))+
      ggtitle("Distribution of Exponential Means") +
      annotate("text",label=paste("Sample Mean =",round(mean(mySampleStats$Means),3)),x=6,y=100,size=5,color="magenta")+
      annotate("text",label=paste("Theoretical Mean =",1/.2),x=6,y=95,size=5,color="green")+
      annotate("text",label=paste("Normal Distribution : N(mu=",round(mean(mySampleStats$Means),3),", sd =",round(sqrt(var(mySampleStats$Means)),3),")"),x=6.65,y=90,size=5,color="red")
      
ggplot(mySampleStats, aes(x = Variances, mean = mean(mySampleStats$Variances), sd = sqrt(var(mySampleStats$Variances)), binwidth = 2, n = nrow(mySampleStats))) +
      theme_dark() +
      geom_histogram(binwidth = 2, colour = "white", fill = "blue", size = 0.1) +
      stat_function(fun = function(x) dnorm(x, mean = mean(mySampleStats$Variances), sd = sqrt(var(mySampleStats$Variances))) * nrow(mySampleStats) * 2,aes(color = "Normal_Distribution"), size =1)+
      geom_vline(aes(xintercept = (1/.2)^2, color = "Theoretical_Mean"), linetype="dashed", size=1.5) +
      geom_vline(aes(xintercept = mean(mySampleStats$Variances), color = "Sample_Mean"), size=1) +
      scale_color_manual(name = "Chart Element", values = c(Theoretical_Mean = "green", Sample_Mean = "magenta", Normal_Distribution = "red"))+
      ggtitle("Distribution of Exponential Variances") +
      annotate("text",label=paste("Sample Variance =",round(mean(mySampleStats$Variances),3)),x=40,y=90,size=5,color="magenta")+
      annotate("text",label=paste("Theoretical Variance =",(1/.2)^2),x=40,y=85,size=5,color="green")+
      annotate("text",label=paste("Normal Distribution : N(mu=",round(mean(mySampleStats$Variances),3),", sd =",round(sqrt(var(mySampleStats$Variances)),3),")"),x=50,y=80,size=5,color="red")


data("ToothGrowth")
str(ToothGrowth)
summary(ToothGrowth)
p1<-ggplot(ToothGrowth, aes(x= supp, y=len, color=dose), geom = "dotplot") + geom_point()
p2<-ggplot(ToothGrowth, aes(x= dose, y=len, color=supp), geom = "dotplot") + geom_point()
grid.arrange(p1, p2, ncol = 2)
