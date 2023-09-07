####explaination####
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

library(randomForest)
set.seed(368915)
bagging <- randomForest(type ~ ., data = spamApp,
                          mtry = ncol(spamApp) - 1)
bagging
errTestBagging <- mean(
  predict(bagging, spamTest) != spamTest$type)
errEmpBagging <- mean(
  predict(bagging, spamApp) != spamApp$type)


RFDef <- randomForest(type ~ ., data = spamApp)
RFDef
RFDef <- randomForest(spamApp[, -58], spamApp[, 58])
errTestRFDef <- mean(predict(RFDef, spamTest) != spamTest$type)
errEmpRFDef <- mean(predict(RFDef, spamApp) != spamApp$type)
plot(RFDef)
RFDoTrace <- randomForest(type ~ ., data = spamApp, ntree = 250,
                          do.trace = 25)


nbvars <- 1:(ncol(spamApp) - 1)
oobsMtry <- sapply(nbvars, function(nbv) {
  RF <- randomForest(type ~ ., spamApp, ntree = 250, mtry = nbv)
  return(RF$err.rate[RF$ntree, "OOB"])
})


mean(replicate(n = 25, randomForest(type ~ ., spamApp,
                                    ntree = 250)$err.rate[250, "OOB"]))


bagStump <- randomForest(type ~ ., spamApp, ntree = 100,
                         mtry = ncol(spamApp) - 1, maxnodes = 2)

bagStumpbestvar <- table(bagStump$forest$bestvar[1, ])
names(bagStumpbestvar) <- colnames(spamApp)[
  as.numeric(names(bagStumpbestvar))]
sort(bagStumpbestvar, decreasing = TRUE)


RFStump <- randomForest(type ~ ., spamApp, ntree = 100,
                        maxnodes = 2)
RFStumpbestvar <- table(RFStump$forest$bestvar[1, ])
names(RFStumpbestvar) <- colnames(spamApp)[
  as.numeric(names(RFStumpbestvar))]
sort(RFStumpbestvar, decreasing = TRUE)


####Practice example####

library("randomForest") #randomForest 4.7-1.1
data("Ozone", package = "mlbench")
#• V1 Months: 1 = January, …, 12 = December.
#• V2 Day of the month 1 to 31.
#• V3 Day of the week: 1 = Monday, …, 7 = Sunday.
#• V4 Daily maximum of hourly average of ozone concentrations.
#• V5 500 millibar (m) pressure height measured at Vandenberg AFB.
#• V6 Wind speed (mph) at Los Angeles International Airport (LAX).
#• V7 Humidity (%) at LAX.
#• V8 Temperature (degrees F) measured at Sandburg, California.
#• V9 Temperature (degrees F) measured at El Monte, California.
#• V10 Inversion base height (feet) at LAX.
#• V11 Pressure gradient (mmHg) from LAX to Daggett, California.
#• V12 Inversion base temperature (degrees F) to LAX.
#• V13 Visibility (miles) measured at LAX.
OzRFDef <- randomForest(V4 ~ ., Ozone, na.action = na.omit)
OzRFDef
plot(OzRFDef)

bins <- c(0, 10, 20, 40)
V4bin <- cut(Ozone$V4, bins, include.lowest = TRUE, right = FALSE)
OzoneBin <- data.frame(Ozone, V4bin)
OzRFDefStrat <- randomForest(V4 ~ . - V9 - V4bin, OzoneBin,
                               strata = V4bin, sampsize = 200, na.action = na.omit)
OzRFDefStrat
