####Predicting Ozone Concentration####
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

####Analyzing Genomic Data####
library(randomForest)
data("vac18", package = "mixOmics")
#create an object geneExpr containing the gene expressions 
#and an object stimu containing the stimuli to be predicted
geneExpr <- vac18$genes
stimu <- vac18$stimulation
#The training of a random forest is done with the following commands. 
#Dealing with high-dimensional data, we set the value from mtry to p/3.
#We recommend this value of mtry in this case because the default value
#√p (i.e., 31 in this example)
#generally leads to consider too few informative variables in each node
VacRFpsur3 <- randomForest(x = geneExpr, y = stimu,
                           mtry = ncol(geneExpr)/3)
VacRFpsur3
plot(VacRFpsur3)


###Analyzing Dust Pollution####
install.packages("VSURF")
library(randomForest)
data("jus", package = "VSURF")
jusComp <- na.omit(jus)
jusRF <- randomForest(PM10 ~ ., data = jusComp)
partialPlot(jusRF, pred.data = jusComp, x.var = "NO",
            main = "Marginal effect - NO")
