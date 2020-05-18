source("../R/scripts/utils.R")
source("../R/scripts/combat.R")
data <- read.csv("inputData/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)

norm.parametric.adjusted <- combat(data, batch=batch, mod=mod, parametric=TRUE)$dat.combat
norm.nonparametric.adjusted <- combat(data, batch=batch, mod=mod, parametric=FALSE)$dat.combat
norm.parametric.unadjusted <- combat(data, batch=batch, parametric=TRUE)$dat.combat
norm.nonparametric.unadjusted <- combat(data, batch=batch, parametric=FALSE)$dat.combat
norm.parametric.adjusted.mo <- combat(data, batch=batch, mod=mod, parametric=TRUE, mean.only=TRUE)$dat.combat
norm.nonparametric.adjusted.mo <- combat(data, batch=batch, mod=mod, parametric=FALSE, mean.only=TRUE)$dat.combat
norm.parametric.unadjusted.mo <- combat(data, batch=batch, parametric=TRUE, mean.only=TRUE)$dat.combat
norm.nonparametric.unadjusted.mo <- combat(data, batch=batch, parametric=FALSE, mean.only=TRUE)$dat.combat

library(sva)
data <- as.matrix(data)
sva.norm.parametric.adjusted <- ComBat(data, batch=batch, mod=mod, par.prior=TRUE)
sva.norm.nonparametric.adjusted <- ComBat(data, batch=batch, mod=mod, par.prior=FALSE)
sva.norm.parametric.unadjusted <- ComBat(data, batch=batch, par.prior=TRUE)
sva.norm.nonparametric.unadjusted <- ComBat(data, batch=batch, par.prior=FALSE)
sva.norm.parametric.adjusted.mo <- ComBat(data, batch=batch, mod=mod, par.prior=TRUE, mean.only=TRUE)
sva.norm.nonparametric.adjusted.mo <- ComBat(data, batch=batch, mod=mod, par.prior=FALSE, mean.only=TRUE)
sva.norm.parametric.unadjusted.mo <- ComBat(data, batch=batch, par.prior=TRUE, mean.only=TRUE)
sva.norm.nonparametric.unadjusted.mo <- ComBat(data, batch=batch, par.prior=FALSE, mean.only=TRUE)

all.equal(sva.norm.parametric.adjusted, norm.parametric.adjusted)
all.equal(sva.norm.parametric.unadjusted, norm.parametric.unadjusted)
all.equal(sva.norm.nonparametric.adjusted, norm.nonparametric.adjusted)
all.equal(sva.norm.nonparametric.unadjusted, norm.nonparametric.unadjusted)
all.equal(sva.norm.parametric.adjusted.mo, norm.parametric.adjusted.mo)
all.equal(sva.norm.parametric.unadjusted.mo, norm.parametric.unadjusted.mo)
all.equal(sva.norm.nonparametric.adjusted.mo, norm.nonparametric.adjusted.mo)
all.equal(sva.norm.nonparametric.unadjusted.mo, norm.nonparametric.unadjusted.mo)



