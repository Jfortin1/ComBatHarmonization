library(neuroCombat)
data <- read.csv("inputData/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)


norm.parametric.adjusted      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE)$dat.combat
norm.nonparametric.adjusted   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE)$dat.combat
norm.parametric.unadjusted    <- neuroCombat(data, batch=batch, parametric=TRUE)$dat.combat
norm.nonparametric.unadjusted <- neuroCombat(data, batch=batch, parametric=FALSE)$dat.combat
write.csv(norm.parametric.adjusted, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_r.csv", row.names=FALSE)

# No eb:
norm.parametric.adjusted.noeb      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, eb=FALSE)$dat.combat
norm.nonparametric.adjusted.noeb   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, eb=FALSE)$dat.combat
norm.parametric.unadjusted.noeb    <- neuroCombat(data, batch=batch, parametric=TRUE, eb=FALSE)$dat.combat
norm.nonparametric.unadjusted.noeb <- neuroCombat(data, batch=batch, parametric=FALSE, eb=FALSE)$dat.combat
write.csv(norm.parametric.adjusted.noeb, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_noeb_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted.noeb, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_noeb_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted.noeb, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_noeb_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted.noeb, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_noeb_r.csv", row.names=FALSE)

# EB+ mean.only
norm.parametric.adjusted      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, mean.only=TRUE)$dat.combat
norm.nonparametric.adjusted   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, mean.only=TRUE)$dat.combat
norm.parametric.unadjusted    <- neuroCombat(data, batch=batch, parametric=TRUE, mean.only=TRUE)$dat.combat
norm.nonparametric.unadjusted <- neuroCombat(data, batch=batch, parametric=FALSE, mean.only=TRUE)$dat.combat
write.csv(norm.parametric.adjusted, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_meanonly_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_meanonly_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_meanonly_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_meanonly_r.csv", row.names=FALSE)

# No eb: + mean.only
norm.parametric.adjusted.noeb      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, eb=FALSE, mean.only=TRUE)$dat.combat
norm.nonparametric.adjusted.noeb   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, eb=FALSE, mean.only=TRUE)$dat.combat
norm.parametric.unadjusted.noeb    <- neuroCombat(data, batch=batch, parametric=TRUE, eb=FALSE, mean.only=TRUE)$dat.combat
norm.nonparametric.unadjusted.noeb <- neuroCombat(data, batch=batch, parametric=FALSE, eb=FALSE, mean.only=TRUE)$dat.combat
write.csv(norm.parametric.adjusted.noeb, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_noeb_meanonly_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted.noeb, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_noeb_meanonly_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted.noeb, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_noeb_meanonly_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted.noeb, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_noeb_meanonly_r.csv", row.names=FALSE)



############  with batch ref
ref.batch=1
norm.parametric.adjusted.batchref      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.adjusted.batchref   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE,ref.batch=ref.batch)$dat.combat
norm.parametric.unadjusted.batchref    <- neuroCombat(data, batch=batch, parametric=TRUE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.unadjusted.batchref <- neuroCombat(data, batch=batch, parametric=FALSE,ref.batch=ref.batch)$dat.combat
write.csv(norm.parametric.adjusted.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_batchref_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_batchref_r.csv", row.names=FALSE)



# No eb:
norm.parametric.adjusted.noeb.batchref      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, eb=FALSE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.adjusted.noeb.batchref   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, eb=FALSE,ref.batch=ref.batch)$dat.combat
norm.parametric.unadjusted.noeb.batchref    <- neuroCombat(data, batch=batch, parametric=TRUE, eb=FALSE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.unadjusted.noeb.batchref <- neuroCombat(data, batch=batch, parametric=FALSE, eb=FALSE,ref.batch=ref.batch)$dat.combat
write.csv(norm.parametric.adjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_noeb_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_noeb_batchref_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_noeb_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_noeb_batchref_r.csv", row.names=FALSE)

# EB+ mean.only
norm.parametric.adjusted.batchref      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.adjusted.batchref   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
norm.parametric.unadjusted.batchref    <- neuroCombat(data, batch=batch, parametric=TRUE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.unadjusted.batchref <- neuroCombat(data, batch=batch, parametric=FALSE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
write.csv(norm.parametric.adjusted.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_meanonly_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_meanonly_batchref_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_meanonly_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_meanonly_batchref_r.csv", row.names=FALSE)

# No eb: + mean.only
norm.parametric.adjusted.noeb.batchref      <- neuroCombat(data, batch=batch, mod=mod, parametric=TRUE, eb=FALSE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.adjusted.noeb.batchref   <- neuroCombat(data, batch=batch, mod=mod, parametric=FALSE, eb=FALSE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
norm.parametric.unadjusted.noeb.batchref    <- neuroCombat(data, batch=batch, parametric=TRUE, eb=FALSE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
norm.nonparametric.unadjusted.noeb.batchref <- neuroCombat(data, batch=batch, parametric=FALSE, eb=FALSE, mean.only=TRUE,ref.batch=ref.batch)$dat.combat
write.csv(norm.parametric.adjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_adjusted_noeb_meanonly_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.adjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_adjusted_noeb_meanonly_batchref_r.csv", row.names=FALSE)
write.csv(norm.parametric.unadjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_parametric_unadjusted_noeb_meanonly_batchref_r.csv", row.names=FALSE)
write.csv(norm.nonparametric.unadjusted.noeb.batchref, quote=FALSE, file="outputData/testdata_combat_nonparametric_unadjusted_noeb_meanonly_batchref_r.csv", row.names=FALSE)




