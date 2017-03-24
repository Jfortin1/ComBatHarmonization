nrow <- 10000;
ncol <- 10;
data <- matrix(rnorm(nrow*ncol), nrow, ncol)
data[,6:10] <- (data[,6:10]+5)*1.5
write.csv(data, quote=FALSE, file="testdata.csv", row.names=FALSE)


dat =  csvread('testdata.csv',1);
batch = [1 1 1 1 1 2 2 2 2 2];
mod = [1 1 1 1 1 1 1 1 1 1 ;1 2 1 2 1 2 1 2 1 2]';
a = combat(dat,batch,mod);

mean(a)
var(a)

a <- ComBat(data, batch=c(1,1,1,1,1,2,2,2,2,2), mod=model.matrix(~c(1,2,1,2,1,2,1,2,1,2)))


library(sva)
library(matrixStats)
colMeans(a)
colVars(a)