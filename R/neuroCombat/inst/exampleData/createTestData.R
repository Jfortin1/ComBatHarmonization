set.seed(10)
nrow <- 200
ncol <- 10
data <- matrix(rnorm(nrow*ncol), nrow, ncol)
# Let's introduce a biological effect:
data[,c(1,3,5,7,9)] <- data[,c(1,3,5,7,9)]+3
# Let's introduce a batch effect:
data[,6:10] <- (data[,6:10]+5)*1.5
colnames(data) <- paste0("Scan_", 1:ncol(data))
rownames(data) <- paste0("Feature_", 1:nrow(data))
combatExampleData <- data
combatExampleScanner <- c(rep("Scanner1", 5), rep("Scanner2", 5))
combatExamplePheno <- rep(c("Control", "Disease"),5)
save(combatExampleData, file="../../data/combatExampleData.rda")
save(combatExampleScanner, file="../../data/combatExampleScanner.rda")
save(combatExamplePheno, file="../../data/combatExamplePheno.rda")