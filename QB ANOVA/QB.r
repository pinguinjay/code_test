NL1_v1v2v3 <- read.csv(file = "D:\\給周\\NL1_v1v2v3.csv")
NL1 <- subset(NL1_v1v2v3, select = c(Group, V1,V2,V3,V4,V5,V6,V7,V8,V9,
                                     V10,V11,V12,V13,V14,V15,V16,V17,V18,V19))
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

##ANOVA

formula <- as.formula(paste0("cbind(", paste(names(NL1)[-1], collapse = ","), ") ~ Group"))
fit<- aov(formula,data = NL1)
summary(fit)
#把ANOVA寫成word檔案(.doc)
#注意，目前只知道可以一個一個更改變數用
#雖然麻煩，但比一個字一個字打還方便了
library(apaTables)
V19_ANOVA<- lm(V19~Group, data = NL1)
apa.aov.table(V19_ANOVA, filename = "D:\\V19_ANOVA.doc")
#TD.r%  Y/C  Int%  Y.r/rush  Y.r/G  rush/G  Sk%  Sk/G  SckYds/G  GWD/G	
#V1  V2  V3  V4  V5  V6  V7  V8  V9  V10
#Cmp%  PR  TD.p%  Y/A  NY/A  Pro_bowler  GS/year  1D/rush  Fmb/G
#V11  V12  V13  V14  V15  V16  V17  V18  V19
