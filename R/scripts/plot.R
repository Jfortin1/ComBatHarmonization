drawPriorGamma <- function(data, col=NULL, xlim=c(-3,1.5), ylim=c(0,3)){
  nn <- length(data$gamma.bar)
  if (is.null(col)){
    col <- 1:nn
  }
  gamma.hat <- data$gamma.hat
  t2 <- data$t2
  gamma.bar <- data$gamma.bar
  normal_data <- lapply(1:nn, function(i){rnorm(1000000, mean=gamma.bar[i], sd=sqrt(t2[i]))})
  plot(density(data$gamma.hat[1,]), 
    xlim=xlim, ylim=ylim, col="white", bty="n", 
    xlab="Gamma", ylab="Density", main=""
  )
  for (i in 1:nn){lines(density(data$gamma.hat[i,]), col=col[i], lwd=1.4, lty=3)}
  for (i in 1:nn){lines(density(normal_data[[i]]), col=col[i], lwd=2)}
}

drawPriorDelta <- function(data, col=NULL, xlim=c(-0.3,2), ylim=c(0,3)){
  nn <- length(data$gamma.bar)
  if (is.null(col)){
    col <- 1:nn
  }
  delta.hat <- data$delta.hat
  a.prior <- data$a.prior
  b.prior <- data$b.prior
  invgamma_data <- lapply(1:nn, function(i){1/rgamma(100000,a.prior[i],b.prior[i])})
  plot(density(data$gamma.hat[1,]), 
    xlim=xlim, ylim=ylim, col="white", bty="n", 
    xlab="Delta", ylab="Density", main=""
  )
  for (i in 1:nn){lines(density(data$delta.hat[i,]), col=col[i], lwd=1.4, lty=3)}
  for (i in 1:nn){lines(density(invgamma_data[[i]]), col=col[i], lwd=2)}
}