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
