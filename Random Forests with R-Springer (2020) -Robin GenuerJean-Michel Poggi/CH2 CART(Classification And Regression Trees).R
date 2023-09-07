####Classification And Regression Trees,CART####
library(rpart)
library(kernlab)
data("spam", package = "kernlab")
set.seed(9146301)
#yTable <- table(spam$type)
levels(spam$type) <- c("ok", "spam")
yTable <- table(spam$type)
indApp <- c(sample(1:yTable[2], yTable[2]/2),
            sample((yTable[2] + 1):nrow(spam), yTable[1]/2))
spamApp <- spam[indApp, ]
spamTest <- spam[-indApp, ]
treeDef <- rpart(type ~ ., data = spamApp)
print(treeDef, digits = 2)
plot(treeDef)
text(treeDef, xpd = TRUE)
set.seed(601334)
treeMax <- rpart(type ~ ., data = spamApp, minsplit = 2, cp = 0)
plot(treeMax)
treeMax$cptable
plotcp(treeMax)
cpOpt <- treeMax$cptable[which.min(treeMax$cptable[, 4]), 1]
treeOpt <- prune(treeMax, cp = cpOpt)
plot(treeOpt)
text(treeOpt, xpd = TRUE, cex = 0.8)
thres1SE <- sum(treeMax$cptable[
  which.min(treeMax$cptable[, 4]), 4:5])
cp1SE <- treeMax$cptable[
  min(which(treeMax$cptable[, 4] <= thres1SE)), 1]
tree1SE <- prune(treeMax, cp = cp1SE)
plot(tree1SE)
text(tree1SE, xpd = TRUE, cex = 0.8)
errTestTreeMax <- mean(
  predict(treeMax, spamTest, type = "class") != spamTest$type)
errEmpTreeMax <- mean(
  predict(treeMax, spamApp, type = "class") != spamApp$type)
treeStump <- rpart(type ~ ., data = spamApp, maxdepth = 1)
summary(treeStump)
par(mar = c(7, 3, 1, 1) + 0.1)
barplot(treeMax$variable.importance, las = 2, cex.names = 0.8)
