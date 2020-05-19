# Author: Jean-Philippe Fortin, fortin946@gmail.com
# This is a modification of the ComBat function code from the sva package that can be found at
# https://bioconductor.org/packages/release/bioc/html/sva.html 
# The original and present code is under the Artistic License 2.0.
# If using this code, make sure you agree and accept this license. 
# Code optimization improved by Richard Beare 


combat <- function(dat, 
  batch, 
  mod=NULL, 
  eb=TRUE, 
  parametric=TRUE,
  mean.only=FALSE,
  verbose=TRUE
){
  dat <- as.matrix(dat)
  .checkConstantRows(dat)
  .checkNARows(dat)
   ## Check for missing values
  hasNAs <- any(is.na(dat))
  if (hasNAs & verbose){
    cat(paste0("[combat] Found ", sum(is.na(dat)), " missing data values. \n"))
  }
  if(mean.only){
      if (verbose) cat("[combat] Performing ComBat with mean only\n")
  }
  if (eb){
      if (verbose) cat("[combat] Performing ComBat with empirical Bayes\n")
  } else {
      if (verbose) cat("[combat] Performing ComBat without empirical Bayes (L/S model)\n")
  }

  ##################### Getting design ############################
  design    <- getDesignMatrix(batch, mod, verbose=verbose, mean.only=mean.only)
  batchDict <- getBatchDict(batch, design)
  ####################################################################


  ##################### Data standardization #######################
  if (verbose) cat('[combat] Standardizing Data across features\n')
  stdObjects <- getStandardizedData(dat=dat, 
    batchDict=batchDict,
    design=design,
    hasNAs=hasNAs
  )
  s.data <- stdObjects[["s.data"]]
  ####################################################################



  ##################### Getting L/S estimates #######################
  if (verbose) cat("[combat] Fitting L/S model and finding priors\n")
  naiveEstimators <- getNaiveEstimators(s.data=s.data,
      batchDict=batchDict, 
      hasNAs=hasNAs,
      mean.only=mean.only
  )
  ####################################################################


  ######################### Getting final estimators ####################
  if (eb){
      if (parametric){
        if (verbose) cat("[combat] Finding parametric adjustments\n")}else{
        if (verbose) cat("[combat] Finding non-parametric adjustments\n")
      }
      estimators <- getEbEstimators(naiveEstimators=naiveEstimators, 
          s.data=s.data, 
          batchDict=batchDict,
          parametric=parametric,
          mean.only=mean.only
      )
  } else {
      estimators <- getNonEbEstimators(naiveEstimators=naiveEstimators)
  }
  ####################################################################
 


  ######################### Correct data #############################
  if (verbose) cat("[combat] Adjusting the Data\n")
  bayesdata <- getCorrectedData(s.data=s.data,
      batchDict=batchDict,
      estimators=estimators,
      naiveEstimators=naiveEstimators,
      stdObjects=stdObjects,
      eb=eb
  )
  ####################################################################


  return(list(dat.combat=bayesdata, 
    gamma.hat=naiveEstimators[["gamma.hat"]], 
    delta.hat=naiveEstimators[["delta.hat"]], 
    gamma.star=estimators[["gamma.star"]],
    delta.star=estimators[["delta.star"]], 
    gamma.bar=estimators[["gamma.bar"]], 
    t2=estimators[["t2"]], 
    a.prior=estimators[["a.prior"]], 
    b.prior=estimators[["b.prior"]], 
    batch=batch, mod=mod, 
    stand.mean=stdObjects[["stand.mean"]], 
    stand.sd=sqrt(stdObjects[["var.pooled"]])
  ))
}