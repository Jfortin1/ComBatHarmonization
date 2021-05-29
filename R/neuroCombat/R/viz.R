#' @title Draw prior distributions of location parameters (gamma estimates)
#' @description Draw prior distributions of location parameters (gamma estimates).
#' @param combat.estimates estimates list from neuroCombat output
#' @param col Character or numeric vector specifying site colors. If NULL, default colors will be used. 
#' @param xlim x-axis limits
#' @param ylim y-axis limits#' 
#' @return Nothing. A plot will be produced as side effect.
#' @export
drawPriorGamma <- function(combat.estimates, col=NULL, xlim=c(-3,1.5), ylim=c(0,3)){
    gamma.hat   <- combat.estimates$gamma.hat
    t2          <- combat.estimates$t2
    gamma.bar   <- combat.estimates$gamma.bar
    nn <- length(gamma.bar)
    if (is.null(col)){
        col <- 1:nn
    }
    normal_data <- lapply(1:nn, function(i){
        rnorm(1000000, mean=gamma.bar[i], sd=sqrt(t2[i]))
    })
    plot(density(gamma.hat[1,], na.rm=TRUE), 
        xlim=xlim,
        ylim=ylim,
        col="white", 
        bty="n", 
        xlab="Gamma",
        ylab="Density",
        main=""
    )
  for (i in 1:nn){
      lines(density(gamma.hat[i,], na.rm=TRUE),
          col=col[i],
          lwd=1.4,
          lty=3
      )
  }
  for (i in 1:nn){
      lines(density(normal_data[[i]],na.rm=TRUE),
          col=col[i],
          lwd=2
      )
  }
}


#' @title Draw prior distributions of scale parameters (delta estimates)
#' @description Draw prior distributions of scale parameters (delta estimates).
#' @param combat.estimates estimates list from neuroCombat output
#' @param col Character or numeric vector specifying site colors. If NULL, default colors will be used. 
#' @param xlim x-axis limits
#' @param ylim y-axis limits#' 
#' @return Nothing. A plot will be produced as side effect.
#' @export
drawPriorDelta <- function(combat.estimates, col=NULL, xlim=c(-0.3,2), ylim=c(0,3)){
    delta.hat <- combat.estimates$delta.hat
    a.prior   <- combat.estimates$a.prior
    b.prior   <- combat.estimates$b.prior
    nn <- length(a.prior)
    if (is.null(col)){
        col <- 1:nn
    }
    invgamma_data <- lapply(1:nn, function(i){
        1/rgamma(100000, a.prior[i], b.prior[i])
    })
    plot(density(delta.hat[1,], na.rm=TRUE), 
        xlim=xlim,
        ylim=ylim, 
        col="white", 
        bty="n", 
        xlab="Delta",
        ylab="Density",
        main=""
    )
    for (i in 1:nn){
        lines(density(delta.hat[i,], na.rm=TRUE),
            col=col[i],
            lwd=1.4,
            lty=3
        )
    }
    for (i in 1:nn){
        lines(density(invgamma_data[[i]], na.rm=TRUE),
            col=col[i],
            lwd=2
        )
    }
}


#' @title Standardize data (feature standardization)
#' @description Standardize data (feature standardization). Optional
#'     covariates adjustment is provided. 
#' @param dat Numeric matrix with imaging features as rows,
#'                and scans/images as columns.
#' @param batch Numeric or character vector specifying the batch/scanner 
#'     variable needed for harmonization. Length must be equal to the 
#'     number of columns in \code{dat}. 
#' @param mod Optional model matrix for outcome of interest and 
#'     other covariates besides batch/scanner.
#' @param mean.only Should only correction factors be calculated for location?
#'     FALSE by default.
#' @return Standardized data.
#' @export
standardizeData <- function(dat,
                            batch,
                            mod,
                            mean.only=FALSE
){
    hasNAs   <- any(is.na(dat))
    dataDict <- getDataDict(batch,
                            mod=mod,
                            mean.only=mean.only)
    design   <- dataDict[["design"]]
    s.data   <- getStandardizedData(dat=dat,
                                    dataDict=dataDict,
                                    design=design,
                                    hasNAs=hasNAs)[["s.data"]]
    return(s.data)
}



