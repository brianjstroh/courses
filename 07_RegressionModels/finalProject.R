library(dplyr)

data(mtcars)
manual<- filter(mtcars, am == 1)
auto<-filter(mtcars, am == 0)
      
summary(manual$mpg)
summary(auto$mpg)
#Quick test to check whether we can be confident that 
t.test(manual$mpg, auto$mpg, paired = FALSE, alternative = "greater")




#Can not use logistic regression because that is concerned with binary OUTCOMES, not INPUTS.

fit1<-lm(mpg~am-1,mtcars)
fit2<-lm(mpg~wt+am-1,mtcars)
fit3<-lm(mpg~wt+am+qsec-1,mtcars)
fit4<-lm(mpg~wt+am+qsec+hp-1,mtcars)
fitall<-lm(mpg~.-1,mtcars)

fit1<-lm(mpg~am,mtcars)
fit2<-lm(mpg~wt+am,mtcars)
fit3<-lm(mpg~wt+am+qsec,mtcars)
fit4<-lm(mpg~wt+am+qsec+hp,mtcars)
fitall<-lm(mpg~.,mtcars)


summary(fit1)$coef
summary(fit2)$coef
summary(fit3)$coef
summary(fit4)$coef
summary(fitall)$coef




anova(fit1,fit2,fit3,fit4,fitall)

plot(mtcars$am,mtcars$mpg)
+abline(fit1)
+abline(fit3)

