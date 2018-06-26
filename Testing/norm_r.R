source("../R/scripts/utils.R")
source("../R/scripts/combat.R")
data <- read.csv("data/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)
norm <- combat(data, batch=batch, mod=mod)
norm <- norm$dat.combat
write.csv(norm, quote=FALSE, file="data/testdata_combat_r.csv", row.names=FALSE)


#col <- pheno+1
#plot(colMeans(data), col=col)
#plot(colMeans(norm), col=col)


