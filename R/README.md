# ComBat harmonization in R

## 1. Installation
 
To use ComBat, load the two scripts `/scripts/combat.R` and `scripts/utils.R` into an R session.

## 2. Multi-Site Harmonization

ComBat estimates scanner-specific location and scale parameters, for each feature separately, and pools information across features using empirical Bayes to improve the estimation of those parameters for small sample size studies.  

### 2.1 Full ComBat with empirical Bayes

The  `combat` function is the main function. It requires two mandatory arguments:
- a data matrix (p x n) `dat` for which the p rows are features, and the n columns are participants. 
- a numeric or character vector `batch` of length n indicating the site/scanner/study id. 

For illustration purpose, let's simulate an imaging dataset with n=10 participants, acquired on 2 scanners, with 5 participants each, with p=10000 voxels per scan. 

```r
source("scripts/utils.R");
source("scripts/combat.R")
p=10000
n=10
batch = c(1,1,1,1,1,2,2,2,2,2) #Batch variable for the scanner id
dat = matrix(runif(p*n), p, n) #Data matrix
```
We use the function `combat` to harmonize the data across the 2 scanners:

```r
data.harmonized <- combat(dat=dat, batch=batch)
```
The harmonized matrix is stored in `data.harmonized$dat.combat`. The `data.harmonized` object also contains the different parameters estimated by ComBat:
- `gamma.hat` and `delta.hat`: Estimated location and shift (L/S) parameters before empirical Bayes.
- `gamma.star` and `delta.star`: Empirical Bayes estimated L/S parameters.
- `gamma.bar`, `t2`, `a.prior` and `b.prior`: esimated prior distributions parameters.

The ComBat algorithm also accepts an optional argument `mod`, which is a matrix containing the outcome of interest and other biological covariates. This is recommended when the goal of the downstream statiatical analyses is to look for associations between the imaging data and the biological variables; this will make sure to preserve the biological variability while removing the variability associated with site/scanner. For instance, suppose we want to remove the inter-scanner variability in our simulated dataset, but we want to preserve the variability associated with age and disease:
```r
age <- c(82,70,68,66,80,69,72,76,74,80) # Continuous variable
disease <- as.factor(c(1,2,1,2,1,2,1,2,1,2)) # Categorical variable
```
We used `as.factor` to make sure that `disease` is a categorical variable. We create a model matrix using the `model.matrix` function:
```
mod <- model.matrix(~age+disease)
```
The matrix `mod` is a n x 3 matrix, containing an intercept, age and a dummy variable for the second disease group (the first disease group is taken as the baseline group). Note that including an intercept in the `mod` matrix does not change the results; ComBat automatically removes intercepts from the `mod` matrix. We now harmonize the data:

```r
combat.harmonized <- combat(dat=dat, batch=batch, mod=mod)
```

### 2.2 ComBat without empirical Bayes

Sometimes, it is preferable not to pool information across features, for instance if:
- (1) The number of features is substantially smaller than the number of participants (p << n) or
- (2) The prior distributions used in ComBat do not fit well the data

An example of (2) is when the site/scanner effects are highly heteregenous across features, for instance differential scanner effects between white matter (WM) or grey matter (GM) voxels exist. To run the ComBat model without empirical Bayes, which boils down to fitting a location/shift (L/S) model for each feature separately, the option `eb=FALSE` can be used:

```r
data.harmonized <- combat(dat=dat, batch=batch, eb=FALSE)
```






