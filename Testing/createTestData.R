set.seed(10)
nrow <- 200
ncol <- 10
data <- matrix(rnorm(nrow*ncol), nrow, ncol)
# Let's introduce a biological effect:
data[,c(1,3,5,7,9)] <- data[,c(1,3,5,7,9)]+3
# Let's introduce a batch effect:
data[,6:10] <- (data[,6:10]+5)*1.5
write.csv(data, quote=FALSE, file="data/testdata.csv", row.names=FALSE)