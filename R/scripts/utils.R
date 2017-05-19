# This is a copy of the original code from the standard version of the
# sva package that can be found at
# https://bioconductor.org/packages/release/bioc/html/sva.html 
# The original and present code is under the Artistic License 2.0.
# If using this code, make sure you agree and accept this license.  

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


# Create indices for matched samples across sites, for one covariate.
#batch: site, study or scanner covariate
#x: continuous covariate
#xmin: minimum value for x to be considered
#xmax: maximum value for x to be considered
#step=1: step for the grid; must be a positive integer
createMatchingIndices <- function(x, batch, xmin=NULL, xmax=NULL, step=1){

	stopifnot(length(x)==length(batch))
	batches <- unique(batch)
	n.batches <- length(batches)
	x_per_batch <- split(x, f=batch)[batches]
	if (is.null(xmin)) xmin <- min(x)
	if (is.null(xmax)) xmax <- max(x)
	grid <- seq(xmin,xmax,step)
	n.bins <- length(grid)-1

	# Creating count matrix:
	counts <- matrix(0, n.bins, n.batches)
	for (i in 1:n.bins){
		counts[i,] <- unlist(lapply(x_per_batch, function(temp){
			sum(temp >= grid[i] & temp < grid[i+1])
		}))
	}
	mins <- unlist(apply(counts,1,min)) #Minimal count
	indices <- c()

	# Creating indices:
	for (i in 1:n.bins){
		for (j in 1:n.batches){
			min <- mins[i]
			if (min!=0){
				cand <- which(x >= grid[i] & x < grid[i+1] & batch==batches[j])

				if (length(cand) !=1){
					cand <- sample(cand,min) # Sampling at random	
				} 


				indices <- c(indices, cand)
			}
		}
	}
	return(indices)
}