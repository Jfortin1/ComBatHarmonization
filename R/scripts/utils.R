# This is a copy of the original code from the standard version of the
# sva package that can be found at
# https://bioconductor.org/packages/release/bioc/html/sva.html 
# The original and present code is under the Artistic 2.0 license.

# Following four find empirical hyper-prior values
aprior <- function(gamma.hat){
	m=mean(gamma.hat)
	s2=var(gamma.hat)
	(2*s2+m^2)/s2
}
bprior <- function(gamma.hat){
	m=mean(gamma.hat)
	s2=var(gamma.hat)
	(m*s2+m^3)/s2
}
postmean <- function(g.hat,g.bar,n,d.star,t2){
	(t2*n*g.hat+d.star*g.bar)/(t2*n+d.star)
}
postvar <- function(sum2,n,a,b){
	(.5*sum2+b)/(n/2+a-1)
}


# Pass in entire data set, the design matrix for the entire data, the batch means, the batch variances, priors (m, t2, a, b), columns of the data  matrix for the batch. Uses the EM to find the parametric batch adjustments

it.sol  <- function(sdat,g.hat,d.hat,g.bar,t2,a,b,conv=.0001){
	n <- apply(!is.na(sdat),1,sum)
	g.old <- g.hat
	d.old <- d.hat
	change <- 1
	count <- 0
	while(change>conv){
		g.new  <- postmean(g.hat,g.bar,n,d.old,t2)
		sum2   <- apply((sdat-g.new%*%t(rep(1,ncol(sdat))))^2, 1, sum,na.rm=T)
		d.new  <- postvar(sum2,n,a,b)
		change <- max(abs(g.new-g.old)/g.old,abs(d.new-d.old)/d.old)
		g.old <- g.new
		d.old <- d.new
		count <- count+1
		}
	#cat("This batch took", count, "iterations until convergence\n")
	adjust <- rbind(g.new, d.new)
	rownames(adjust) <- c("g.star","d.star")
	adjust
}
