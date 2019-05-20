source("../R/scripts/utils.R")
source("../R/scripts/combat.R")
data <- read.csv("data/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)
norm.parametric <- combat(data, batch=batch, mod=mod, parametric=TRUE)
norm.parametric <- norm.parametric$dat.combat
norm.nonparametric <- combat(data, batch=batch, mod=mod, parametric=FALSE)
norm.nonparametric <- norm.nonparametric$dat.combat
write.csv(norm.parametric, quote=FALSE, file="data/testdata_combat_parametric_r.csv", row.names=FALSE)
write.csv(norm.nonparametric, quote=FALSE, file="data/testdata_combat_nonparametric_r.csv", row.names=FALSE)