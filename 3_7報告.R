#介紹dataframe
x <- 10:1
y <- -4:5
q <- c("游泳", "足球", "籃球", "桌球", "騎腳踏車",
       "耍廢", "棒球", "網球", "羽球", "橄欖球")
theDF <- data.frame(First=x, Second=y, Sport=q)
theDF
theDF <- data.frame(First=x, Second=y, Sport=q)
#指定列的名稱
rownames(theDF)
rownames(theDF) <- c("One", "Two", "Three", "Four", "Five", "Six",
                     "Seven", "Eight", "Nine", "Ten")
rownames(theDF)
theDF
#還原回預設值
rownames(theDF) <- NULL
rownames(theDF)
theDF
#--------------------------------------------------------------
#介紹List(清單)
# 建立三個元素的list
list(1, 2, 3)
# 建立一個元素的list,且其唯一的元素為一個含有三個元素的vector
list(c(1, 2, 3))
# 建立兩個元素的list，第一個元素為含有三個元素的vector，第二個元素為含有五個元素的vector
(list2 <- list(c(1, 2, 3), 3:7))
# 兩個元素的list，第一元素為 data.frame，第二元素為含有10個元素的vector
list(theDF, 1:10)
# 三個元素的list，第一個為data.frame，第二個為vector，第三個為含有兩個vector的list,名為list3
list3 <- list(theDF, 1:10, list2)
list3
names(list3)
names(list3) <- c("data.frame", "vector", "list")
names(list3)
list3
list4 <- list(TheDataFrame = theDF, TheVector = 1:10, TheList = list3)
names(list4)
list4
#-----------------------------------------------------------
#介紹矩陣
# 建立一個5x2 matrix
A <- matrix(1:10, nrow = 5)

# 建立另一個5x2 matrix
B <- matrix(21:30, nrow = 5)

# 建立另一個5x2 matrix
C <- matrix(21:40, nrow = 2)

A
B
C

nrow(A)
ncol(A)
dim(A)

# 把它們加起來
A + B

# 把它們互相乘起來
A * B

# 查看元素是否一樣
A == B

#承上反矩陣
A %*% t(B)
#命名
colnames(A)
rownames(A)
colnames(A) <- c("Left", "Right")
rownames(A) <- c("1st", "2nd", "3rd", "4th", "5th")

colnames(B)
rownames(B)
colnames(B) <- c("First", "Second")
rownames(B) <- c("One", "Two", "Three", "Four", "Five")

colnames(C)
rownames(C)
colnames(C) <- LETTERS[1:10]
rownames(C) <- c("Top", "Bottom")
#------------------------------------------------------------
#3-7內容
#先讀取檔案
congress <- read.csv("congress.csv ")
#製作3x4的矩陣，依據列來填滿
x <- matrix(1:12, nrow = 3, ncol = 4, byrow = TRUE)
rownames(x) <- c("a", "b", "c")
colnames(x) <- c("d", "e", "f", "g")
dim(x) # 確認大小
x

## data frame 可以儲存不同的資料形式
y <- data.frame(y1 = as.factor(c("a", "b", "c")), y2 = c(0.1, 0.2, 0.3))
class(y$y1)
class(y$y2)
y
## as.matrix() 把變數變成字元
z <- as.matrix(y)
z

## 行的總和
colSums(x)  
## 列的平均
rowMeans(x) 
## 行的總和2
apply(x, 2, sum) 
## 列的平均2
apply(x, 1, mean)
## 各列的標準差
apply(x, 1, sd)

## ------------------------------------------------------------------------
## 生成清單
x <- list(y1 = 1:10, y2 = c("hi", "hello", "hey"),
          y3 = data.frame(z1 = 1:3, z2 = c("good", "bad", "ugly"))) 
## 3個找出list中元素的方法
x$y1 
x[[2]] 
x[["y3"]] 

## ------------------------------------------------------------------------
names(x)  # 所有元素的明子
length(x) # 有多少個元素

dwnom80 <- cbind(congress$dwnom1[congress$congress == 80], 
                 congress$dwnom2[congress$congress == 80])
dwnom112 <- cbind(congress$dwnom1[congress$congress == 112], 
                 congress$dwnom2[congress$congress == 112])

## kmeans with 2 clusters
k80two.out <- kmeans(dwnom80, centers = 2, nstart = 5)
k112two.out <- kmeans(dwnom112, centers = 2, nstart = 5)

## elements of a list
names(k80two.out)

## final centroids
k80two.out$centers
k112two.out$centers

## number of observations for each cluster by party
table(party = congress$party[congress$congress == 80], 
      cluster = k80two.out$cluster)
table(party = congress$party[congress$congress == 112], 
      cluster = k112two.out$cluster)

## kmeans with 4 clusters
k80four.out <- kmeans(dwnom80, centers = 4, nstart = 5)
k112four.out <- kmeans(dwnom112, centers = 4, nstart = 5)

## plotting the results using the labels and limits defined earlier
plot(dwnom80, col = k80four.out$cluster + 1, 
     xlab = "Economic liberalism/conservatism",
     ylab ="Racial liberalism/conservatism",
     xlim =c(-1.5, 1.5), ylim = c(-1.5, 1.5), main = "80th Congress")

## plotting the centroids
points(k80four.out$centers, pch = 8, cex = 2)

## 112th congress
plot(dwnom112, col = k112four.out$cluster+1 ,
     xlab = "Economic liberalism/conservatism", 
     ylab = "Racial liberalism/conservatism", xlim =c(-1.5, 1.5), 
     ylim = c(-1.5, 1.5), main = "112th Congress")
points(k112four.out$centers, pch = 8, cex = 2)

palette()

