
#https://rpubs.com/jiankaiwang/rf
packageName <- "randomForest"
if(!(packageName %in% rownames(installed.packages()))) {
  install.packages("randomForest")
}
library("randomForest")
data(iris)
set.seed(111)

# 建立抽樣樣本
# 1 表示為訓練資料
# 2 表示為測試資料
ind <- sample(2, nrow(iris), replace = TRUE, prob = c(0.8, 0.2))

# the prototype of randomForest
# formula: 公式
# data: 要進行訓練的資料
# subset: 索引向量，表示那些行被用來訓練
# x: 輸入變數
# y: 預測變數及輸出變數
# xtest: 測試集輸入的變數
# ytest: 測試集輸出的變數
# mtry: 每個枝中分裂的數目
# ntree: 幾顆樹
# replace: 是否重複選取資料
# classwt: 各類的加權值，預設為 1
# do.trace: 是否列出建樹運行過程
# cutoff: 針對分類樹的切割點，預設為 1/k，k 為類數
# strata: 分層抽樣中的因數向量
# sampsize: 抽樣數
# importance: 估計出變數的重要性
# localImp: 計算出樣本的重要性
# nPerm: 估計變數重要性，每顆樹 OOB 估計資料變化的次數
# proximity: 估計樣本間的相似度
randomForest(formula, data=NULL, ..., subset, na.action=na.fail)
randomForest(x, y=NULL,  xtest=NULL, ytest=NULL, ntree=500,
             mtry=if (!is.null(y) && !is.factor(y))
             max(floor(ncol(x)/3), 1) else floor(sqrt(ncol(x))),
             replace=TRUE, classwt=NULL, cutoff, strata,
             sampsize = if (replace) nrow(x) else ceiling(.632*nrow(x)),
             nodesize = if (!is.null(y) && !is.factor(y)) 5 else 1,
             maxnodes = NULL,
             importance=FALSE, localImp=FALSE, nPerm=1,
             proximity, oob.prox=proximity,
             norm.votes=TRUE, do.trace=FALSE,
             keep.forest=!is.null(y) && is.null(xtest), corr.bias=FALSE,
             keep.inbag=FALSE, ...)

iris.rf <- randomForest(Species ~ ., data=iris[ind == 1,])
iris.rf

## 
## Call:
##  randomForest(formula = Species ~ ., data = iris[ind == 1, ]) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 2
## 
##         OOB estimate of  error rate: 3.33%
## Confusion matrix:
##            setosa versicolor virginica class.error
## setosa         45          0         0  0.00000000
## versicolor      0         39         1  0.02500000
## virginica       0          3        32  0.08571429



 #the prototype of predict
# model: 隨機森林模型
# testdata: 測試資料
# type: response(預測的值), prob(預測各水準的機率), vote(預測各水準的投票數)
predict(model, testdata, type=response, ...)

iris.pred <- predict(iris.rf, iris[ind==2,])
iris.pred
##         18         25         40         44         48         55 
##     setosa     setosa     setosa     setosa     setosa versicolor 
##         60         65         71         78         82         92 
## versicolor versicolor  virginica  virginica versicolor versicolor 
##         97         99        100        103        105        110 
## versicolor versicolor versicolor  virginica  virginica  virginica 
##        113        114        115        118        123        127 
##  virginica  virginica  virginica  virginica  virginica  virginica 
##        128        129        134        139        141        142 
##  virginica  virginica versicolor  virginica  virginica  virginica 
## Levels: setosa versicolor virginica

table(observed=iris[ind==2,"Species"], predicted = iris.pred)
##             predicted
## observed     setosa versicolor virginica
##   setosa          5          0         0
##   versicolor      0          8         2
##   virginica       0          1        14
importance(iris.rf)
##              MeanDecreaseGini
## Sepal.Length         7.531027
## Sepal.Width          1.613308
## Petal.Length        33.897747
## Petal.Width         35.819451

# sort: 是否按重要性降冪排列
varImpPlot(iris.rf, sort = TRUE)

predict(iris.rf, iris[ind==2,], proximity = TRUE)
