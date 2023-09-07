####1 Introduction to Random Forests with R####
#Running Example: Spam Detection
data("spam", package = "kernlab")
set.seed(9146301)
#yTable <- table(spam$type)
levels(spam$type) <- c("ok", "spam")
yTable <- table(spam$type)
indApp <- c(sample(1:yTable[2], yTable[2]/2),
              sample((yTable[2] + 1):nrow(spam), yTable[1]/2))
spamApp <- spam[indApp, ]
spamTest <- spam[-indApp, ]
#Ozone Pollution
data("Ozone", package = "mlbench")
#Genomic Data for a Vaccine Study
data("vac18", package = "mixOmics")
#Dust Pollution
data("jus", package = "VSURF")