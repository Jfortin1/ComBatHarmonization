source("../R/scripts/utils.R")
source("../R/scripts/combat.R")
data <- read.csv("data/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)
norm.parametric.adjusted <- combat(data, batch=batch, mod=mod, parametric=TRUE)$dat.combat
norm.nonparametric.adjusted <- combat(data, batch=batch, mod=mod, parametric=FALSE)$dat.combat
norm.parametric.unadjusted <- combat(data, batch=batch, parametric=TRUE)$dat.combat
norm.nonparametric.unadjusted <- combat(data, batch=batch, parametric=FALSE)$dat.combat
write.csv(norm.parametric.adjusted, quote=FALSE, file="data/testdata_combat_parametric_adjusted_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted, quote=FALSE, file="data/testdata_combat_nonparametric_adjusted_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted, quote=FALSE, file="data/testdata_combat_parametric_unadjusted_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted, quote=FALSE, file="data/testdata_combat_nonparametric_unadjusted_r.csv", row.names=FALSE)

#data[1:2,4] <- NA
#data[3,6] <- NA
#norm.parametric.adjustedd <- combat(data, batch=batch, mod=mod, parametric=TRUE)$dat.combat
#norm.nonparametric.adjustedd <- combat(data, batch=batch, mod=mod, parametric=FALSE)$dat.combat
#norm.parametric.unadjustedd <- combat(data, batch=batch, parametric=TRUE)$dat.combat
#norm.nonparametric.unadjustedd <- combat(data, batch=batch, parametric=FALSE)$dat.combat