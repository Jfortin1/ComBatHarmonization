nrow <- 10000;
ncol <- 10;
data <- matrix(rnorm(nrow*ncol), nrow, ncol)
data[,6:10] <- (data[,6:10]+5)*1.5
write.csv(data, quote=FALSE, file="testdata.csv", row.names=FALSE)