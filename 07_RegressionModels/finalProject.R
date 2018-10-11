library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)

data(mtcars)
manual<- filter(mtcars, am == 1)
auto<-filter(mtcars, am == 0)
      
summary(filter(mtcars, am == 1))
summary(filter(mtcars, am == 0))

#If transmission type were the sole predictor, this would be how confident we are that manual transmissions have a great mpg.
t.test(manual$mpg, auto$mpg, paired = FALSE, alternative = "greater")$p.val




#We can not use logistic regression because that is concerned with binary OUTCOMES, not INPUTS.

fit1<-lm(mpg~am-1,mtcars)
fit2<-update(fit1,mpg~am+wt-1)
fit3<-update(fit2,mpg~am+wt+qsec-1)
fit4<-update(fit3,mpg~am+wt+qsec+disp-1)

fit1Int<-lm(mpg~am,mtcars)
fit2Int<-update(fit1,mpg~am+wt)
fit3Int<-update(fit2,mpg~am+wt+qsec)
fit4Int<-update(fit3,mpg~am+wt+qsec+disp)

anova(fit1,fit2,fit3,fit4)
anova(fit1Int,fit2Int,fit3Int,fit4Int)

summary(fit1)$coef
summary(fitInt)$coef
summary(fit2)$coef
summary(fit3)$coef
summary(fit3Int)$coef
summary(fit4)$coef

vif(fit2Int)
vif(fit3Int)
vif(fit4Int)
vif(fit3)

mtc2<-cbind(mtcars,mpg_fit1=fit1Int$coef[1]+mtcars$am*fit1Int$coef[2])
mtc2<-cbind(mtc2,mpg_fit2=fit2Int$coef[1]+mtcars$am*fit2Int$coef[2]+mtcars$wt*fit2Int$coef[3])
mtc2<-cbind(mtc2,mpg_fit3=fit3Int$coef[1]+mtcars$am*fit3Int$coef[2]+mtcars$wt*fit3Int$coef[3]+mtcars$qsec*fit3Int$coef[4])



g1<-ggplot(mtc2,aes(x=mpg,y=mpg_fit1))+geom_point()+geom_abline(slope=1,intercept = 0,lwd=3,col="red") +
      ggtitle("MPG vs Transmission Type")
g2<-ggplot(mtc2,aes(x=mpg,y=mpg_fit2))+geom_point()+geom_abline(slope=1,intercept = 0,lwd=3,col="yellow") +
      ggtitle("Weight Regressor Added")
g3<-ggplot(mtc2,aes(x=mpg,y=mpg_fit3))+geom_point()+geom_abline(slope=1,intercept = 0,lwd=3,col="green") +
      ggtitle("Quater Mile Time Regressor Added")
grid.arrange(g1,g2,g3,ncol=3, top = grid.text("Actual MPG Versus Model Fitted MPG",gp=gpar(fontsize=18,font=7)))

