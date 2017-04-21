# Create indices for matched samples across sites, for one covariate.
#batch: site, study or scanner covariate
#x: continuous covariate
#xmin: minimum value for x to be considered
#xmax: maximum value for x to be considered
#step=1: step for the grid; must be a positive integer
createMatchedIndices <- function(x, batch, xmin=NULL, xmax=NULL, step=1){

	stopifnot(length(x)==length(batch))
	batches <- unique(batch)
	n.batches <- length(batches)
	x_per_batch <- split(x, f=batch)[batches]
	if (is.null(xmin)) xmin <- min(x)
	if (is.null(xmax)) xmax <- max(x)
	grid <- seq(min,max,step)
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
				cand <- which(x >= grid[i] & x < grid[i+1] & ==batches[j])
				cand <- sample(cand,min) # Sampling at random
				indices <- c(indices, cand)
			}
		}
	}
	return(indices)
}