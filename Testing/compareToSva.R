library(neuroCombat)
data <- read.csv("inputData/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)

norm.parametric.adjusted         <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE)$dat.combat
norm.nonparametric.adjusted      <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE)$dat.combat
norm.parametric.unadjusted       <- neuroCombat(data, batch=batch, parametric=TRUE)$dat.combat
norm.nonparametric.unadjusted    <- neuroCombat(data, batch=batch, parametric=FALSE)$dat.combat
norm.parametric.adjusted.mo      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, mean.only=TRUE)$dat.combat
norm.nonparametric.adjusted.mo   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, mean.only=TRUE)$dat.combat
norm.parametric.unadjusted.mo    <- neuroCombat(data, batch=batch, parametric=TRUE, mean.only=TRUE)$dat.combat
norm.nonparametric.unadjusted.mo <- neuroCombat(data, batch=batch, parametric=FALSE, mean.only=TRUE)$dat.combat

# With reference batch:
norm.parametric.adjusted.ref         <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, ref.batch=1)$dat.combat
norm.nonparametric.adjusted.ref      <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, ref.batch=1)$dat.combat
norm.parametric.unadjusted.ref       <- neuroCombat(data, batch=batch, parametric=TRUE, ref.batch=1)$dat.combat
norm.nonparametric.unadjusted.ref    <- neuroCombat(data, batch=batch, parametric=FALSE, ref.batch=1)$dat.combat
norm.parametric.adjusted.mo.ref      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, mean.only=TRUE, ref.batch=1)$dat.combat
norm.nonparametric.adjusted.mo.ref   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, mean.only=TRUE, ref.batch=1)$dat.combat
norm.parametric.unadjusted.mo.ref    <- neuroCombat(data, batch=batch, parametric=TRUE, mean.only=TRUE, ref.batch=1)$dat.combat
norm.nonparametric.unadjusted.mo.ref <- neuroCombat(data, batch=batch, parametric=FALSE, mean.only=TRUE, ref.batch=1)$dat.combat


library(sva)
data <- as.matrix(data)
sva.norm.parametric.adjusted         <- ComBat(data, batch=batch, mod=mod, par.prior=TRUE)
sva.norm.nonparametric.adjusted      <- ComBat(data, batch=batch, mod=mod, par.prior=FALSE)
sva.norm.parametric.unadjusted       <- ComBat(data, batch=batch, par.prior=TRUE)
sva.norm.nonparametric.unadjusted    <- ComBat(data, batch=batch, par.prior=FALSE)
sva.norm.parametric.adjusted.mo      <- ComBat(data, batch=batch, mod=mod, par.prior=TRUE, mean.only=TRUE)
sva.norm.nonparametric.adjusted.mo   <- ComBat(data, batch=batch, mod=mod, par.prior=FALSE, mean.only=TRUE)
sva.norm.parametric.unadjusted.mo    <- ComBat(data, batch=batch, par.prior=TRUE, mean.only=TRUE)
sva.norm.nonparametric.unadjusted.mo <- ComBat(data, batch=batch, par.prior=FALSE, mean.only=TRUE)

sva.norm.parametric.adjusted.ref         <- ComBat(data, batch=batch, mod=mod, par.prior=TRUE, ref.batch=1)
sva.norm.nonparametric.adjusted.ref      <- ComBat(data, batch=batch, mod=mod, par.prior=FALSE, ref.batch=1)
sva.norm.parametric.unadjusted.ref       <- ComBat(data, batch=batch, par.prior=TRUE, ref.batch=1)
sva.norm.nonparametric.unadjusted.ref    <- ComBat(data, batch=batch, par.prior=FALSE, ref.batch=1)
sva.norm.parametric.adjusted.mo.ref      <- ComBat(data, batch=batch, mod=mod, par.prior=TRUE, mean.only=TRUE, ref.batch=1)
sva.norm.nonparametric.adjusted.mo.ref   <- ComBat(data, batch=batch, mod=mod, par.prior=FALSE, mean.only=TRUE, ref.batch=1)
sva.norm.parametric.unadjusted.mo.ref    <- ComBat(data, batch=batch, par.prior=TRUE, mean.only=TRUE, ref.batch=1)
sva.norm.nonparametric.unadjusted.mo.ref <- ComBat(data, batch=batch, par.prior=FALSE, mean.only=TRUE, ref.batch=1)





all.equal(sva.norm.parametric.adjusted, norm.parametric.adjusted)
all.equal(sva.norm.parametric.unadjusted, norm.parametric.unadjusted)
all.equal(sva.norm.nonparametric.adjusted, norm.nonparametric.adjusted)
all.equal(sva.norm.nonparametric.unadjusted, norm.nonparametric.unadjusted)
all.equal(sva.norm.parametric.adjusted.mo, norm.parametric.adjusted.mo)
all.equal(sva.norm.parametric.unadjusted.mo, norm.parametric.unadjusted.mo)
all.equal(sva.norm.nonparametric.adjusted.mo, norm.nonparametric.adjusted.mo)
all.equal(sva.norm.nonparametric.unadjusted.mo, norm.nonparametric.unadjusted.mo)

all.equal(sva.norm.parametric.adjusted.ref, norm.parametric.adjusted.ref)
all.equal(sva.norm.parametric.unadjusted.ref, norm.parametric.unadjusted.ref)
all.equal(sva.norm.nonparametric.adjusted.ref, norm.nonparametric.adjusted.ref)
all.equal(sva.norm.nonparametric.unadjusted.ref, norm.nonparametric.unadjusted.ref)
all.equal(sva.norm.parametric.adjusted.mo.ref, norm.parametric.adjusted.mo.ref)
all.equal(sva.norm.parametric.unadjusted.mo.ref, norm.parametric.unadjusted.mo.ref)
all.equal(sva.norm.nonparametric.adjusted.mo.ref, norm.nonparametric.adjusted.mo.ref)
all.equal(sva.norm.nonparametric.unadjusted.mo.ref, norm.nonparametric.unadjusted.mo.ref)







