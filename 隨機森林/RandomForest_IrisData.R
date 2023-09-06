library(randomForest)# randomForest 4.7-1.1
#使用內建的 iris 資料
data("iris")

set.seed(111)
# 建立抽樣樣本
# 1 表示為訓練資料
# 2 表示為測試資料
ind <- sample(2, nrow(iris), replace = TRUE, prob = c(0.8, 0.2)) 

####建立隨機森林模型#####
iris.rf <- randomForest(Species ~ ., data=iris[ind == 1,])
iris.rf

#######對測試資料進行預測#######
# the prototype of predict
# model: 隨機森林模型
# testdata: 測試資料
# type: response(預測的值), prob(預測各水準的機率), vote(預測各水準的投票數)
#predict(model, testdata, type=response, ...)
iris.pred <- predict(iris.rf, iris[ind==2,])
iris.pred

########生成交叉矩陣#########
table(observed=iris[ind==2,"Species"], predicted = iris.pred)
#由上的預測結果可以看出，測試資料中 setosa 的樣本全部都預測正確；versicolor 有 8 個樣本正確分類，而有 2 個樣本分類錯誤；virginica 則有 1 個樣本被分類錯誤。


####求得變數的重要性，並畫出重要性圖######
importance(iris.rf)
# sort: 是否按重要性降冪排列
varImpPlot(iris.rf, sort = TRUE)
#透過 Mean Decrease Gini 來衡量變數重要性指數，表示 Gini 係數減少的平均值。在隨機森林中，衡量變數的重要性方法是透過剔除該變數，並將剔除變數的模型與原模型比較，差異越大表示變數越重要。如本例中，重要變數為 Petal.Width，較不重要為 Sepal.Width。
