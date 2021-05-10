#程式碼來源https://blog.alantsai.net/posts/2018/01/data-science-series-16-r-hello-world-with-stock-analysis-using-quantmod
#覺得作者介紹得超棒
install.packages("quantmod")#安裝套件
library("quantmod")#呼叫套件

# 取得google的股票，並且看看前6筆資料
getSymbols("GOOG")
head(GOOG)

# 畫出走勢
chartSeries(GOOG)
chartSeries(GOOG["2017-11-03::2018-01-03",])

# 計算 20日和60日均線
ma20<-runMean(GOOG[,4],n=20)
ma60<-runMean(GOOG[,4],n=60)
head(ma20, 25)

# 畫上線
chartSeries(GOOG["2017-01-03::2018-01-03",], theme = "white")
addTA(ma20,on=1,col="blue")
addTA(ma60,on=1,col="red") 
#-------------------------------------------------------#
#台灣的股票
#台股的取的方式很簡單，用我們的股票代碼+TW就可以了，
#像這樣。上市: 股票代碼.TW。上櫃: 股票代碼.TWO
stock <- getSymbols("2317.TW", auto.assign = FALSE, from="2017-01-01" ,to="2018-01-30")#auto.assign若為T則從2007開始抓
stock2<- na.omit(stock)
head(stock2)
chartSeries(stock2)
chartSeries(stock2["2017-01-01::2018-01-30",])#劃出趨勢線
chartSeries(stock2["2017-01-01::2018-01-30",], theme="white")
ma5<-runMean(stock2[,4],n=5)
ma20<-runMean(stock2[,4],n=20)#ma為均線
ma60<-runMean(stock2[,4],n=60)
head(ma20)
#一般來說當短期均線（如5日線）由下向上穿過長期均線（如60日均線），形成金叉，則是買入點。 
#反之，當短期均線（如5日線）由上向下穿過長期均線（如60日均線），形成死叉，則是賣出點
chartSeries(stock2["2017-01-01::2018-01-30",], theme = "white")
addTA(ma20,on=1,col="blue")#畫上均線
addTA(ma60,on=1,col="red") 
chartSeries(stock2["2017-01-01::2018-01-30",], theme = "black")
addTA(ma20,on=1,col="blue")
addTA(ma60,on=1,col="red") 
addTA(ma5, on=1, col="yellow")

#---------comparing two and tw-----------------------------------
tsmc1<- getSymbols("2330.TW", auto.assign = FALSE, from="2021-01-01" ,to="2021-05-01")
tsmc2<- na.omit(tsmc1)
head(tsmc2)
chartSeries(tsmc2)
chartSeries(tsmc2["2021-01-01::2021-05-01",])#劃出趨勢線
chartSeries(tsmc2["2021-01-01::2021-05-01",], theme="white")
ma5<-runMean(tsmc2[,4],n=5)
ma20<-runMean(tsmc2[,4],n=20)#ma為均線
ma60<-runMean(tsmc2[,4],n=60)
head(ma20)
#一般來說當短期均線（如5日線）由下向上穿過長期均線（如60日均線），形成金叉，則是買入點。 
#反之，當短期均線（如5日線）由上向下穿過長期均線（如60日均線），形成死叉，則是賣出點
chartSeries(tsmc2["2021-01-01::2021-05-01",], theme = "black")
addTA(ma20,on=1,col="blue")#畫上均線
addTA(ma60,on=1,col="red") 
addTA(ma5, on=1, col="yellow")
