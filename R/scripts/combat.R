# Author: Jean-Philippe Fortin, fortin946@gmail.com
# This is a modification of the ComBat function code from the sva package that can be found at
# https://bioconductor.org/packages/release/bioc/html/sva.html 
# The original and present code is under the Artistic License 2.0.
# If using this code, make sure you agree and accept this license. 
# Code optimization improved by Richard Beare 


combat <- function(dat, batch, mod=NULL, eb=TRUE, verbose=TRUE, parametric=TRUE){
  dat <- as.matrix(dat)
  
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
  
  # A few other characteristics on the batches
  n.batch <- nlevels(batch)
  batches <- lapply(levels(batch), function(x)which(batch==x))
  n.batches <- sapply(batches, length)
  n.array <- sum(n.batches)
  #combine batch variable and covariates
  design <- cbind(batchmod,mod)
  # check for intercept in covariates, and drop if present
  check <- apply(design, 2, function(x) all(x == 1))
  design <- as.matrix(design[,!check])
  
  # Number of covariates or covariate levels
  if (verbose) cat("[combat] Adjusting for",ncol(design)-ncol(batchmod),'covariate(s) or covariate level(s)\n')
  
  # Check if the design is confounded
  if(qr(design)$rank<ncol(design)){
    if(ncol(design)==(n.batch+1)){
      stop("[combat] The covariate is confounded with batch. Remove the covariate and rerun ComBat.")
    }
    if(ncol(design)>(n.batch+1)){
      if((qr(design[,-c(1:n.batch)])$rank<ncol(design[,-c(1:n.batch)]))){
        stop('The covariates are confounded. Please remove one or more of the covariates so the design is not confounded.')
      } else {
        stop("At least one covariate is confounded with batch. Please remove confounded covariates and rerun ComBat.")
      }
    }
  }
    
  
  ##Standardize Data across features
  if (verbose) cat('[combat] Standardizing Data across features\n')
  B.hat1 <- solve(crossprod(design))
  B.hat1 <- tcrossprod(B.hat1, design)
  B.hat <- tcrossprod(B.hat1, dat)
  #Standarization Model
  grand.mean <- crossprod(n.batches/n.array, B.hat[1:n.batch,])
  var.pooled <- ((dat-t(design%*%B.hat))^2)%*%rep(1/n.array,n.array)
  stand.mean <- crossprod(grand.mean, t(rep(1,n.array)))
  
  if(!is.null(design)){
    tmp <- design;tmp[,c(1:n.batch)] <- 0
    stand.mean <- stand.mean+t(tmp%*%B.hat)
  }	
  s.data <- (dat-stand.mean)/(tcrossprod(sqrt(var.pooled), rep(1,n.array)))
  
  ##Get regression batch effect parameters
  if (eb){
      if (verbose) cat("[combat] Fitting L/S model and finding priors\n")
  } else {
      if (verbose) cat("[combat] Fitting L/S model\n")
  }
  batch.design <- design[,1:n.batch]
  gamma.hat <- tcrossprod(solve(crossprod(batch.design, batch.design)), batch.design)
  gamma.hat <- tcrossprod(gamma.hat, s.data)
  delta.hat <- NULL
  for (i in batches){
    delta.hat <- rbind(delta.hat,rowVars(s.data, cols=i, na.rm=TRUE))
  }

  # Empirical Bayes correction:
  gamma.star <- delta.star <- NULL
  gamma.bar <- t2 <- a.prior <- b.prior <- NULL
  if (eb){
      ##Find Priors
      #gamma.bar <- apply(gamma.hat, 1, mean)
      #t2 <- apply(gamma.hat, 1, var)
      gamma.bar <- rowMeans(gamma.hat)
      t2 <- rowVars(gamma.hat)
      a.prior <- apriorMat(delta.hat)
      b.prior <- bpriorMat(delta.hat)
      
      ##Find EB batch adjustments
      if (parametric){
        if (verbose) cat("[combat] Finding parametric adjustments\n")
        for (i in 1:n.batch){
            temp <- it.sol(s.data[,batches[[i]]],gamma.hat[i,],delta.hat[i,],gamma.bar[i],t2[i],a.prior[i],b.prior[i])
            gamma.star <- rbind(gamma.star,temp[1,])
            delta.star <- rbind(delta.star,temp[2,])
        }
      } else {
        if (verbose) cat("[combat] Finding non-parametric adjustments\n")
        for (i in 1:n.batch){
            temp <- int.eprior(as.matrix(s.data[, batches[[i]]]),gamma.hat[i,], delta.hat[i,])
            gamma.star <- rbind(gamma.star,temp[1,])
            delta.star <- rbind(delta.star,temp[2,])
        }
      }
      
  } 



  
  ### Normalize the Data ###
  if (verbose) cat("[combat] Adjusting the Data\n")
  bayesdata <- s.data
  j <- 1
  for (i in batches){
    if (eb){
        bayesdata[,i] <- (bayesdata[,i]-t(batch.design[i,]%*%gamma.star))/tcrossprod(sqrt(delta.star[j,]), rep(1,n.batches[j]))
    } else {
        bayesdata[,i] <- (bayesdata[,i]-t(batch.design[i,]%*%gamma.hat))/tcrossprod(sqrt(delta.hat[j,]), rep(1,n.batches[j]))
    }
    j <- j+1
  }
  
  bayesdata <- (bayesdata*(tcrossprod(sqrt(var.pooled), rep(1,n.array))))+stand.mean
  return(list(dat.combat=bayesdata, 
    gamma.hat=gamma.hat, delta.hat=delta.hat, 
    gamma.star=gamma.star, delta.star=delta.star, 
    gamma.bar=gamma.bar, t2=t2, a.prior=a.prior, b.prior=b.prior, batch=batch, mod=mod, 
    stand.mean=stand.mean, stand.sd=sqrt(var.pooled)[,1])
  )
}