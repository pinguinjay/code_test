####https://ithelp.ithome.com.tw/articles/10187561####

#載入隨機樹森林package
#install.packages("randomForest")
#(1)載入creditcard資料集(包含1,319筆觀察測試，共有12個變數)
#install.packages("AER")
data(CreditCard,package = "AER")

#假設我們只要以下欄位(card:是否核准卡片、信用貶弱報告數、年齡、收入(美金)、自有住宅狀況、往來年月)
bankcard <- subset(CreditCard, select = c(card, reports, age, income, owner, months))

#將是否核准卡片轉換為0/1數值
bankcard$card <- ifelse(bankcard$card == "yes", 1, 0);
#(2)測試模型
#取得總筆數
n <- nrow(bankcard)
#設定隨機數種子
set.seed(1117)
#將數據順序重新排列
newbankcard <- bankcard[sample(n),]

#取出樣本數的idx
t_idx <- sample(seq_len(n), size = round(0.7 * n))

#訓練資料與測試資料比例: 70%建模，30%驗證
traindata <- newbankcard[t_idx,]
testdata <- newbankcard[ - t_idx,]


library(randomForest)
set.seed(1117)

#(2)跑隨機樹森林模型
randomforestM <- randomForest(card ~ ., data = traindata, importane = T, proximity = T, do.trace = 100)
randomforestM

#錯誤率: 利用OOB(Out Of Bag)運算出來的
plot(randomforestM)

#衡量每一個變數對Y值的重要性，取到小數點第二位
round(importance(randomforestM), 2)
#(3)預測
result <- predict(randomforestM, newdata = testdata)
result_Approved <- ifelse(result > 0.6, 1, 0)

#(4)建立混淆矩陣(confusion matrix)觀察模型表現
cm <- table(testdata$card, result_Approved, dnn = c("實際", "預測"))
cm

#(5)正確率
#計算核準卡正確率
cm[4] / sum(cm[, 2])

#計算拒補件正確率
cm[1] / sum(cm[, 1])

#整體準確率(取出對角/總數)
accuracy <- sum(diag(cm)) / sum(cm)
accuracy


####https://ithelp.ithome.com.tw/articles/10303882####
#install.packages("randomForest")
library(randomForest)

randomForest(formula = Y~X,
             subset   = training_data_index,# 注意! 這裡不是直接放入training data，而是index值 
             na.action  =‘na.fail’,# (默認值), 不允許資料中出現遺失值/ ‘na.omit’,刪除遺失值。
             importance = TRUE,# 结合importance()函数使用，用來觀察重要變數。
             ntree   = num_tree,# number of trees, RF裡生成的決策樹數目。
             mtry    = m_variables_try, # 每次抽樣時需要抽「多少個變數」，
             # 建議設置 ?/3  (Regression trees);  √?(Classification trees)
             sampsize  = sampsize,#訓練每棵樹模型的樣本數大小。預設是使用63.25%訓練資料集的比例。
             nodesize  = nodesize,# 末梢(葉)節點最小觀察資料個數。
             Maxnode  = Maxnode,# 內部節點最大個數值。
             ... ) 
####Boston dataset實例示範 Bagging trees、隨機森林 Random Forest Regression Example####
#這邊打算去預測房價中位數medv:
## 載入、觀察 Boston dataset
library(MASS) #Boston dataset
data('Boston')
dim(Boston)
names(Boston)

set.seed (123)
index.train = sample(1:nrow(Boston), size=ceiling(0.8*nrow(Boston))) # training dataset index
train = Boston[index.train, ] # trainind data
test = Boston[-index.train, ] # test data

#  Bagging trees: All predictors should be considered for each split of the tree.
library(randomForest)
set.seed (123)
bag.boston <- randomForest (medv ~ ., data = Boston ,
                            subset = index.train ,  
                            mtry = ncol(Boston)-1, # 14variables - 1(medv)=13 
                            importance = TRUE)
bag.boston

# Perform on the test set
test <- Boston[-index.train  , ]
yhat.bag <- predict (bag.boston , newdata = Boston[-index.train , ])
plot (yhat.bag , test$medv)
abline (0, 1)
mean ((yhat.bag - test$medv)^2) #MSE
#隨機森林 Random Forest Regression Example
#因為這裡是 Regression trees 所以一開始嘗試選擇mtry時會建議選擇 p/3 variables
library(randomForest)
set.seed (123)
rf.boston <- randomForest (medv ~ ., data = Boston ,
                           subset = index.train , 
                           mtry = 4,           #13/3
                           importance = TRUE)
rf.boston
###接著我們可以試著挑選參數，首先從ntree 開始挑選，選擇RF要建立幾棵樹
## Observe that what is the best number of trees(ntree)
plot(rf.boston) # MSE on OOB samples (OOB error) 
#可以看到ntree=200左右，模型的平均誤差OOB(out-of-bag)MSE 穩定平緩，所以選擇ntree=200。
#接著使用 tuneRF(x.train.data, y.train.data, ntree)，來tune mtry，決定抽取多少個多少個變數去建每棵決策樹。
# x.train.data= train[,-14]= training data without Y(medv)   
# y.train.data=train[,14]= Y(medv)
tuneRF(x=train[,-14], y=train[,14], 
       ntreeTry= 200)
#選擇OOB(out-of-bag)erro 最低的mtry=8
##最終模型
# Set mtry=8, ntree=200 to build the model.
rf.tune.boston <- randomForest (medv ~ ., data = Boston ,
                                subset = index.train , 
                                mtry = 8, 
                                ntree = 200,
                                importance = TRUE)
rf.tune.boston

## 預測結果
yhat.tune.rf <- predict (rf.tune.boston, newdata = test)
mean ((yhat.tune.rf - test$medv)^2)#MSE

###建完模型後，我們可以看看什麼是比較重要的變數:
# Importance of each variable
importance (rf.tune.boston)        # %Increase in MSE(); Increase in node purity
importance (rf.tune.boston,type=1) # %IncMSE
varImpPlot (rf.tune.boston)
