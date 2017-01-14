library(ggplot2)
library(fpp)
mtcars
mtcars$cyl<-as.factor(mtcars$cyl)
mtcars$am<-as.factor(mtcars$am)
levels(mtcars$am)<-c("Automatic", "Manual")
ggplot(data = mtcars, aes(am,mpg))+geom_boxplot(aes(fill=am))

##simple regression
fit<-lm(mpg ~ am, data = mtcars)
summary(fit)
#this explains only 33% of variance in mpg 

##multiple linear regression
#backward approach using p values
mfit1<-lm(mpg ~ ., data = mtcars)
summary(mfit1)
mfit2<-lm(mpg ~ am+factor(cyl)+disp+hp+wt+qsec+vs+gear+carb, data = mtcars)
summary(mfit2)
mfit3<-lm(mpg ~ am+factor(cyl)+disp+hp+wt+qsec+vs+carb, data = mtcars)
summary(mfit3)
mfit4<-lm(mpg ~ am+disp+hp+wt+qsec+vs+carb, data = mtcars)
summary(mfit4)
mfit5<-lm(mpg ~ am+disp+hp+wt+qsec+vs, data = mtcars)
summary(mfit5)
mfit6<-lm(mpg ~ am+disp+hp+wt+qsec, data = mtcars)
summary(mfit6)
mfit7<-lm(mpg ~ am+hp+wt+qsec, data = mtcars)
summary(mfit7)
mfit8<-lm(mpg ~ am+wt+qsec, data = mtcars)
summary(mfit8)


#anova(mfit1,mfit2,mfit3,mfit4,mfit5,mfit6,mfit7,mfit8)
par(mfrow=c(2,2))
plot(mfit8)

Acf(resid(mfit8))
