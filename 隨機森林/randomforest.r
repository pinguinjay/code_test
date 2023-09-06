library(naniar) 
data("iris")
iris <- iris[,-c(5)]
any_na(iris)
library(randomForest)
model <- randomForest(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data = iris,   
                      importane = T, proximity = T, 
                      do.trace = 100,na.action = na.roughfix)
par(mfrow=c(1,1))
plot(model) 
importance(model)
library(rminer)
rf <- Importance(model,iris,measure="AAD")
rf$imp
par(mfrow=c(1,3))
boxplot(iris$Sepal.Width)$out
boxplot(iris$Petal.Length)$out
boxplot(iris$Petal.Width)$out
#因為離群值不多，所以先不轉
n <- nrow(iris)
set.seed(1117)
subiris <- sample(seq_len(n), size = round(0.7 * n))
traindata <- iris[subiris,]
testdata <- iris[ - subiris,]


#####
features <- setdiff(x = names(traindata), y = "Sepal.Length")
par(mfrow=c(1,1))
set.seed(123)
tuneRF(x = traindata[features], y = traindata$Sepal.Length,
       mtryStart = 1,ntreeTry = 450)
set.seed(123)
model <- randomForest(Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data = traindata,    
                      ntree = 450, mtry = 3,
                      do.trace = 50,na.action = na.roughfix)
future <- predict(model,testdata)
future <- as.data.frame(future)
final <- cbind(future,testdata)
library(dplyr)
final <- mutate(final,mape=abs(future-Sepal.Length)/Sepal.Length)
mean(final$mape)
