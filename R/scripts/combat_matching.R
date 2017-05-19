# Author: Jean-Philippe Fortin, fortin946@gmail.com
# This is a modification of the ComBat function code from the sva package that can be found at
# https://bioconductor.org/packages/release/bioc/html/sva.html 
# The original and present code is under the Artistic License 2.0.


# Devel branch of combat for matched samples:
combat_matching <- function(dat, batch, training.indices=1:length(batch), mod=NULL, eb=TRUE){
  training.yesno <- !isTRUE(all.equal(sort(training.indices), 1:length(batch)))
  if (training.yesno){
      cat("[combat] You chose to train ComBat on a subset of the data\n")
  }

  if (eb){
      cat("[combat] Performing ComBat with empirical Bayes\n")
  } else {
      cat("[combat] Performing ComBat without empirical Bayes (L/S model)\n")
  }
  # make batch a factor and make a set of indicators for batch
  batch <- as.factor(batch)
  batchmod <- model.matrix(~-1+batch)  
  cat("[combat] Found",nlevels(batch),'batches\n')
  
  # A few other characteristics on the batches
  n.batch <- nlevels(batch)
  batches <- list()
  for (i in 1:n.batch){
    batches[[i]] <- which(batch == levels(batch)[i])
  } # list of samples in each batch  
  n.batches <- sapply(batches, length)
  n.array <- sum(n.batches)
  
  #combine batch variable and covariates

  design <- cbind(batchmod,mod)
  # check for intercept in covariates, and drop if present
  check <- apply(design, 2, function(x) all(x == 1))
  design <- as.matrix(design[,!check])
  
  # Number of covariates or covariate levels
  cat("[combat] Adjusting for",ncol(design)-ncol(batchmod),'covariate(s) or covariate level(s)\n')
  
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
  cat('[combat] Standardizing Data across features\n')
  B.hat <- solve(t(design)%*%design)%*%t(design)%*%t(as.matrix(dat))
  
      
  #Standarization Model
  grand.mean <- t(n.batches/n.array)%*%B.hat[1:n.batch,]
  var.pooled <- ((dat-t(design%*%B.hat))^2)%*%rep(1/n.array,n.array)
  stand.mean <- t(grand.mean)%*%t(rep(1,n.array))
  if(!is.null(design)){
    tmp <- design;tmp[,c(1:n.batch)] <- 0
    stand.mean <- stand.mean+t(tmp%*%B.hat)
  }	
  s.data <- (dat-stand.mean)/(sqrt(var.pooled)%*%t(rep(1,n.array)))
  
  ##Get regression batch effect parameters
  if (eb){
      cat("[combat] Fitting L/S model and finding priors\n")
  } else {
      cat("[combat] Fitting L/S model\n")
  }
  
  batch.design <- design[,1:n.batch]
  gamma.hat <- solve(t(batch.design)%*%batch.design)%*%t(batch.design)%*%t(as.matrix(s.data))

  delta.hat <- NULL
  for (i in batches){
    delta.hat <- rbind(delta.hat,apply(s.data[,i], 1, var,na.rm=T))
  }
  
  # Empirical Bayes correction:
  gamma.star <- delta.star <- NULL
  gamma.bar <- t2 <- a.prior <- b.prior <- NULL
  if (eb){
      ##Find Priors
      gamma.bar <- apply(gamma.hat, 1, mean)
      t2 <- apply(gamma.hat, 1, var)
      a.prior <- apply(delta.hat, 1, aprior)
      b.prior <- apply(delta.hat, 1, bprior)


      ##Find EB batch adjustments
      cat("[combat] Finding parametric adjustments\n")
      for (i in 1:n.batch){
          temp <- it.sol(s.data[,batches[[i]]],gamma.hat[i,],delta.hat[i,],gamma.bar[i],t2[i],a.prior[i],b.prior[i])
          gamma.star <- rbind(gamma.star,temp[1,])
          delta.star <- rbind(delta.star,temp[2,])
      }
  } 
  
  ### Normalize the Data ###
  cat("[combat] Adjusting the Data\n")
  bayesdata <- s.data
  j <- 1
  for (i in batches){
    if (eb){
        bayesdata[,i] <- (bayesdata[,i]-t(batch.design[i,]%*%gamma.star))/(sqrt(delta.star[j,])%*%t(rep(1,n.batches[j])))
    } else {
        bayesdata[,i] <- (bayesdata[,i]-t(batch.design[i,]%*%gamma.hat))/(sqrt(delta.hat[j,])%*%t(rep(1,n.batches[j])))
    }
    j <- j+1
  }
  
  bayesdata <- (bayesdata*(sqrt(var.pooled)%*%t(rep(1,n.array))))+stand.mean
  return(list(dat.combat=bayesdata, 
    gamma.hat=gamma.hat, delta.hat=delta.hat, 
    gamma.star=gamma.star, delta.star=delta.star, 
    gamma.bar=gamma.bar, t2=t2, a.prior=a.prior, b.prior=b.prior, batch=batch, mod=mod)
  )
}



