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



old <- norm
#col <- pheno+1
#plot(colMeans(data), col=col)
#plot(colMeans(norm), col=col)



norm <- combat(data, batch=batch, mod=mod)

dat <- data
dat <- as.matrix(dat)
verbose=TRUE
   .checkConstantRows <- function(dat){
     
     sds <- rowSds(dat)
     ns <- sum(sds==0)
     if (ns>0){
       message <- paste0(ns, " rows (features) were found to be constant across samples. Please remove these rows before running ComBat.")
       stop(message)
     }
   }
   .checkConstantRows(dat)
   if (eb){
       if (verbose) cat("[combat] Performing ComBat with empirical Bayes\n")
   } else {
       if (verbose) cat("[combat] Performing ComBat without empirical Bayes (L/S model)\n")
   }
   # make batch a factor and make a set of indicators for batch
   batch <- as.factor(batch)
   batchmod <- model.matrix(~-1+batch)  
   if (verbose) cat("[combat] Found",nlevels(batch),'batches\n')

