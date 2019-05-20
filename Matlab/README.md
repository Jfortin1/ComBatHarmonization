# ComBat harmonization in Matlab

## Table of content
- [1. Installation](#id-section1)
- [2. Harmonization](#id-section2)
- [3. Visualization](#id-section3)

<div id='id-section1'/>

## 1. Installation
 
To use ComBat, the following scripts will need to be available in the Matlab path:
- `aprior.m`
- `bprior.m`
- `itSol.m`
- `postmean.m`
- `postvar.m`
- `inteprior.m`
- `combat.m`

The directory containing those scripts can be added to the Matlab path as follows:
```matlab
addPath('path/to/the/scripts/folder');
```

<div id='id-section2'/>

## 2. Multi-Site Harmonization

ComBat estimates scanner-specific location and scale parameters, for each feature separately, and pools information across features using empirical Bayes to improve the estimation of those parameters for small sample size studies.  

### 2.1 Full ComBat with empirical Bayes

The  `combat` function is the main function. It requires two mandatory arguments:
- a data matrix (p x n) `dat` for which the p rows are features, and the n columns are participants. 
- a numeric or character vector `batch` of length n indicating the site/scanner/study id.

The ComBat algorithm also accepts an optional argument `mod`, which is a matrix containing the outcome of interest and other biological covariates. This is recommended when the goal of the downstream statiatical analyses is to look for associations between the imaging data and the biological variables; this will make sure to preserve the biological variability while removing the variability associated with site/scanner. 

For illustration purpose, let's simulate an imaging dataset with n=10 participants, acquired on 2 scanners, with 5 participants each, with p=10000 voxels per scan. 

```matlab
p=10000;
n=10;
batch = [1 1 1 1 1 2 2 2 2 2]; %Batch variable for the scanner id
dat = randn(p,n); %Random data matrix
```
and let simulate an age and disease variable: 
```matlab
age = [82 70 68 66 80 69 72 76 74 80]'; % Continuous variable
disease = [1 2 1 2 1 2 1 2 1 2]'; % Categorical variable
```
We create a n x 2 model matrix with age as the first column, and the second disease group as a dummy variable for the second column (disease=1 being the baseline category):
```matlab
disease = dummyvar(disease);
mod = [age disease(:,2)];
```
We use the function `combat` to harmonize the data across the 2 scanners using parametric adjustements:
```matlab
data_harmonized = combat(dat, batch, mod, 1);
```

or using non-parametric adjustments:

```matlab
data_harmonized = combat(dat, batch, mod, 0);
```

To use ComBat without a model matrix, simply set
```matlab
mod=[];
```

<div id='id-section3'/>

## 3. Visualization

Coming soon.




