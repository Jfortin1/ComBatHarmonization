# Author: Jean-Philippe Fortin, fortin946@gmail.com
# Date: July 14 2020
# Projet repo: github.com/Jfortin1/ComBatHarmonization
# This is a modification of the ComBat function code from the sva package that can be found at
# https://bioconductor.org/packages/release/bioc/html/sva.html 
# The modified code is under the Artistic License 2.0.



#' @title neuroCombat harmonization
#' @description Main function to perform neuroCombat harmonization.
#' 
#' @param dat Numeric matrix with imaging features as rows,
#'                and scans/images as columns.
#' @param batch Numeric or character vector specifying the batch/scanner 
#'     variable needed for harmonization. Length must be equal to the 
#'     number of columns in \code{dat}. 
#' @param mod Optional model matrix for outcome of interest and 
#'     other covariates besides batch/scanner.
#' @param eb Should Empirical Bayes adjustements be performed? TRUE by default.
#'     Specifying \code{eb=FALSE} will perform location/scale (L/S) adjustments
#'     for each feature separately, that is without pooling information aross 
#'     features to estimate batch correction parameters. 
#' @param parametric Should parametric priors be used in the EB estimation?
#'     TRUE by default. Note that the non-parametric option (\code{parametric=FALSE})
#'     is usually very slow.
#' @param mean.only Should only correction factors be calculated for location?
#'     FALSE by default.
#' @param ref.batch NULL by default.
#' @param BPPARAM BiocParallelParam for parallel operation. 
#'     This is mostly useful when \code{parametric=FALSE}.
#' @param verbose Should progress messages be printed? TRUE by default.
#' 
#' @return A named \code{list} of length 5. The 1st element (\code{dat.combat})
#'     contains the harmonized data. The 2nd element (\code{estimates}) contains
#'     estimates and other parameters used during harmonization. The 3rd element
#'     (\code{dataDict}) contains information about the dataset and the batch 
#'     covariate information that were provided to the neuroCombat function.
#'     The 4th element (\code{data.original}) contains the raw data that were
#'     provided to neuroCombat. The 5th element (\code{data.standardized})
#'     contains the standardized original data: each feature is scaled and
#'     centered after adjusting for biological covariates).
#' 
#' 
#' @importFrom BiocParallel bpparam
#' @export
neuroCombat <- function(dat, 
                        batch, 
                        mod=NULL, 
                        eb=TRUE, 
                        parametric=TRUE,
                        mean.only=FALSE,
                        ref.batch=NULL,
                        verbose=TRUE,
                        BPPARAM=bpparam("SerialParam")
){
    dat <- as.matrix(dat)
    dat.original <- dat
    #dat <- .getUsableData(dat, batch)
    .checkConstantRows(dat)
    .checkNARows(dat)

    if (length(batch) !=ncol(dat)){
        stop("Length of 'batch' must be equal to the number of columns in 'dat'.")
    }
    if (any(is.na(batch))){
        stop("Missing values are not allowed in 'batch'. ")
    }

     ## Check for missing values
    hasNAs <- any(is.na(dat))
    if (hasNAs & verbose){
        cat(paste0("[neuroCombat] Found ", sum(is.na(dat)), " missing data values. \n"))
    }
    if(mean.only){
        if (verbose) cat("[neuroCombat] Performing ComBat with mean only\n")
    }
    if (eb){
        if (verbose) cat("[neuroCombat] Performing ComBat with empirical Bayes\n")
    } else {
        if (verbose) cat("[neuroCombat] Performing ComBat without empirical Bayes (L/S model)\n")
    }

    ##################### Getting design ############################
    dataDict <- getDataDict(batch,
                            mod,
                            mean.only=mean.only,
                            ref.batch=ref.batch,
                            verbose=verbose)
    design   <- dataDict[["design"]]
    ####################################################################


    ##################### Data standardization #######################
    if (verbose) cat('[neuroCombat] Standardizing Data across features\n')
    stdObjects <- getStandardizedData(dat=dat, 
                                      dataDict=dataDict,
                                      design=design,
                                      hasNAs=hasNAs)
    s.data <- stdObjects[["s.data"]]
    ####################################################################



    ##################### Getting L/S estimates #######################
    if (verbose) cat("[neuroCombat] Fitting L/S model and finding priors\n")
    naiveEstimators <- getNaiveEstimators(s.data=s.data,
                                          dataDict=dataDict, 
                                          hasNAs=hasNAs,
                                          mean.only=mean.only)
    ####################################################################


    ######################### Getting final estimators ####################
    if (eb){
        if (parametric){
            if (verbose) cat("[neuroCombat] Finding parametric adjustments\n")
        } else {
            if (verbose) cat("[neuroCombat] Finding non-parametric adjustments\n")
        }
        estimators <- getEbEstimators(naiveEstimators=naiveEstimators, 
                                      s.data=s.data, 
                                      dataDict=dataDict,
                                      parametric=parametric,
                                      mean.only=mean.only,
                                      BPPARAM=BPPARAM)
    } else {
        estimators <- getNonEbEstimators(naiveEstimators=naiveEstimators,
                                         dataDict=dataDict)
    }
    ####################################################################
   


    ######################### Correct data #############################
    if (verbose) cat("[neuroCombat] Adjusting the Data\n")
    bayesdata <- getCorrectedData(dat=dat,
                                  s.data=s.data,
                                  dataDict=dataDict,
                                  estimators=estimators,
                                  naiveEstimators=naiveEstimators,
                                  stdObjects=stdObjects,
                                  eb=eb)
    ####################################################################


    # List of estimates:
    estimates <- list(gamma.hat=naiveEstimators[["gamma.hat"]], 
                      delta.hat=naiveEstimators[["delta.hat"]], 
                      gamma.star=estimators[["gamma.star"]],
                      delta.star=estimators[["delta.star"]], 
                      gamma.bar=estimators[["gamma.bar"]], 
                      t2=estimators[["t2"]], 
                      a.prior=estimators[["a.prior"]], 
                      b.prior=estimators[["b.prior"]], 
                      stand.mean=stdObjects[["stand.mean"]], 
                      mod.mean=stdObjects[["mod.mean"]], 
                      var.pooled=stdObjects[["var.pooled"]],
                      beta.hat=stdObjects[["beta.hat"]],
                      mod=mod, 
                      batch=batch, 
                      ref.batch=ref.batch, 
                      eb=eb, 
                      parametric=parametric, 
                      mean.only=mean.only)

    out <- list(dat.combat=as.matrix(bayesdata),
                estimates=estimates,
                info=dataDict,
                dat.original=dat.original,
                dat.standardized=s.data)
    return(out)
}



