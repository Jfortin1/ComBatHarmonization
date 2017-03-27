# ComBat harmonization in R

## 1. Installation

- Load the two scripts `/scripts/combat.R` and `scripts/utils.R` into R

## 2. Multi-Site Harmonization

The  `combat` function is the main function. It requires two mandatory arguments:
- a data matrix (p x n) `dat` for which the p rows are features, and the n columns are participants. 
- a numeric or character vector `batch` of length n indicating the site/scanner/study id. 

For illustration purpose, let's simulate an imaging dataset with n=10 participants, acquired on 2 scanners, with 5 participants each, with p=10000 voxels per scan. 

```{r}
source("combat.R"); source("utils.R");
p=10000
n=10
batch = c(1,1,1,1,1,2,2,2,2,2) #Batch variable for the scanner id
dat = matrix(runif(p*n), p, n) #Data matrix
```
To harmonize the data across the 2 scanners:

```{r}
data.harmonized <- combat(dat=dat, batch=batch)
```
The harmonized matrix is stored in
```{r}
data.harmonized$dat.combat
```
The `data.harmonized` object also contains the different parameters estimated by ComBat:
- `gamma.hat` and `delta.hat`: Estimated location and shift (L/S) parameters before empirical Bayes.
- `gamma.star` and `delta.star`: Empirical Bayes estimated L/S parameters.
- `gamma.bar`, `t2`, `a.prior` and `b.prior`: esimated prior distributions parameters.






