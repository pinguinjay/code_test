####Iris dataset實例示範 隨機森林 Random Forest Classification Example####
library(randomForest)
NL1_v1v2v3 <- read.csv(file = "D:\\給周\\NL1_v1v2v3 _2.csv")
NL1 <- subset(NL1_v1v2v3, select = c(Group, V1,V2,V3,V4,V5,V6,V7,V8,V9,
                                     V10,V11,V12,V13,V14,V15,V16,V17,V18,V19))
NL1<- NL1[-c(62:69),]
NL1$Group <- factor(NL1$Group)
#分組計算平均值
meansdf <- data.frame(matrix(nrow = 5))
for (colnumber in c(2:length(NL1))) {
  columnName<-names(NL1[colnumber])
  print(columnName<-names(NL1[colnumber]))
  calculateResult <- aggregate(NL1[,colnumber],by = list(type = NL1$Group),mean)
  meansdf[columnName] <- calculateResult[,2]
  print(calculateResult)
}
#write.csv(meansdf,file="D:\\means.csv")
#計算標準差
SD.df<-data.frame(matrix(nrow = 5)) #5個row的空dataframe
for (colnumber in c(2:length(NL1))) { #length(NL1)，幾個變數
  columnName<-names(NL1[colnumber])
  print(columnName<-names(NL1[colnumber]))
  calculateResult <- aggregate(NL1[,colnumber],by = list(type = NL1$Group),sd)
  SD.df[columnName] <- calculateResult[,2]
  print(calculateResult)
}
#write.csv(SD.df,file="D:\\standarddev.csv")
#ANOVA
options(scipen=999)

formula <- as.formula(paste0("cbind(", paste(names(NL1)[-1], collapse = ","), ") ~ Group"))
fit<- aov(formula,data = NL1)
summary(fit)

library(apaTables)
V19_ANOVA<- lm(V19~Group, data = NL1)
#perform pairwise t-tests with Bonferroni's correction
V19_bonferroni<-pairwise.t.test(NL1$V18, NL1$Group, p.adjust.method="bonferroni")
write.csv(V19_bonferroni$p.value,file = "V19_bonferroni.csv")
apa.aov.table(V19_ANOVA, filename = "D:\\V19_ANOVA.doc")
pairwise.t.test(NL1$V1, NL1$Group, p.adjust.method="bonferroni")
#TD.r%	Y/C	Int%	Y.r/rush	Y.r/G	rush/G	Sk%	Sk/G	SckYds/G	GWD/G	Cmp%	PR	TD.p%	Y/A	NY/A	Pro_bowler	GS/year	1D/rush	Fmb/G
#V1	V2	V3	V4	V5	V6	V7	V8	V9	V10	V11	V12	V13	V14	V15	V16	V17	V18	V19
NL1_v1v2v3 <- read.csv(file = "D:\\給周\\NL1_v1v2v3 _2.csv")
#只找到對應到2 3 5 7 9 10 11 13 14 15 17 19
NL1 <- subset(NL1_v1v2v3, select = c(Group, V1,V2,V3,V4,V5,V6,
                                     V11,V12,V13,V14,V15,V17,V18))
NL1<- NL1[-c(62:69),]
NL1$Group <- factor(NL1$Group)
names(NL1)
dim(NL1)
sqrt(12) 
set.seed(123)
index.train.NL1 = sample(1:nrow(NL1), size=ceiling(0.7*nrow(NL1)))
train.NL1 = NL1[index.train.NL1, ]
test.NL1 = NL1[-index.train.NL1, ]

rf.NL1<-randomForest(Group ~.,  data=NL1, subset=index.train.NL1)
rf.NL1
plot(rf.NL1) #sqrt(19)=4.3588
legend("topright",colnames(rf.NL1$err.rate),cex=0.8,fill = 1:6)

#Important variables
importance(rf.NL1) # MeanDecreaseGini
imp <- sort(importance(rf.NL1))
imp
varImpPlot(rf.NL1, sort = TRUE)

## Perform on the testing data
# predict()
# type: response(預測的分類), prob(預測分為各種類的機率), vote(預測時各分類的獲得的投票數)
predict(rf.NL1, test.NL1, type="response")
predict(rf.NL1, test.NL1, type="prob")
predict(rf.NL1, test.NL1, type="vote")

NL1.pred <- predict(rf.NL1, test.NL1) # 預設為type="response"
NL1.pred

table(observed=test.NL1$Group , predicted = NL1.pred) # Confusion matrix
mean(test.NL1$Group==NL1.pred) # Accuracy
#只用下面的變數Accuracy一樣
#方法：不斷重複varImpPlot(rf.NL1, sort = TRUE) 找出權重更大的變數
NL1 <- subset(NL1_v1v2v3, select = c(Group, V1,V2,V3,V4,V5,V6,
                                     V11,V12,V13,V14,V15,V17,V18))
#用下面這個就夠準了
NL1 <- subset(NL1_v1v2v3, select = c(Group,V3,V4,V5,V6,V12,V15,V17,V18))
