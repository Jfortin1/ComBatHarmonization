#' @title neuroCombat harmonization using pre-trained estimates 
#' @description [UNDER DEVELOPMENT] neuroCombat harmonization using
#'     parameters estimated from a training dataset. Estimated parameters
#'     are applied to a new dataset, assuming scanners/batches in the 
#'     new dataset were also present in the training dataset.
#' 
#' @param dat Numeric matrix with imaging features as rows,
#'                and scans/images as columns.
#' @param batch Numeric or character vector specifying the batch/scanner 
#'     variable needed for harmonization. Length must be equal to the 
#'     number of columns in \code{dat}. 
#' @param estimates Prior neuroCombat estimates to be applied onto
#'     the new dataset. Usually obtained from the output of
#'     \code{neuroCombat} run on a training dataset. 
#' @param mod Optional model matrix for outcome of interest and 
#'     other covariates besides batch/scanner. 
#' @param verbose Should progress messages be printed? TRUE by default.
#' 
#' @return A named \code{list} of length 2. The first element (\code{dat.combat})
#'     contains the harmonized data. The second element (\code{estimates}) contains
#'     estimates and other parameters used during harmonization.
#' @export
neuroCombatFromTraining <- function(dat,
                                    batch,
                                    estimates,
                                    mod=NULL,
                                    verbose=TRUE
){
    cat("[neuroCombatFromTraining] In development ...\n")
    new.levels <- unique(batch)
    missing.levels <- new.levels[!new.levels %in% estimates$batch]
    if (length(missing.levels)!=0){
        stop(paste0("The batches ", missing.levels, " are not part of the training dataset\n"))
    }

    # Step 0: standardize data
    var.pooled <- estimates$var.pooled
    stand.mean <- estimates$stand.mean[,1]
    mod.mean   <- estimates$mod.mean
    gamma.star <- estimates$gamma.star
    delta.star <- estimates$delta.star
    n.array  <- ncol(dat)
    
    if (!is.null(estimates$mod)){
        if (verbose){
            cat("[neuroCombatFromTraining] Using mean imputation to account for previous covariates adjustment in training dataset\n")
        }
    }

    if (is.null(mod)){
        stand.mean <- stand.mean+rowMeans(mod.mean)
    } else {
        stop("Including covariates for ComBat correction on a new dataset is not supported yet\n")
    }
    # Step 1: standardize data
    bayesdata <- (dat-stand.mean)/sqrt(var.pooled)
    # Step 2: remove estimates
    gamma     <- t(gamma.star[batch,,drop=FALSE])
    delta     <- t(delta.star[batch,,drop=FALSE])
    bayesdata <- (bayesdata-gamma)/sqrt(delta)
    # Step 3: transforming to original scale
    bayesdata <- bayesdata*sqrt(var.pooled) + stand.mean
    out <- list(dat.combat=as.matrix(bayesdata),
                estimates=estimates)
    return(out)
}