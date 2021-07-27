# ComBat harmonization in Matlab

## Table of content
- [1. Installation](#id-section1)
- [2. Harmonization](#id-section2)

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
addpath('path/to/the/scripts/folder');
```

<div id='id-section2'/>

## 2. Multi-Site Harmonization

ComBat estimates scanner-specific location and scale parameters, for each feature separately, and pools information across features using empirical Bayes to improve the estimation of those parameters for small sample size studies.  

### 2.1 Full ComBat with empirical Bayes

The  `combat` function is the main function. It requires two mandatory arguments:
- a data matrix (p x n) `dat` for which the p rows are features, and the n columns are participants. 
- a numeric or character vector `batch` of length n indicating the site/scanner/study id.

The ComBat algorithm also accepts an optional argument `mod`, which is a matrix containing the outcome of interest and other biological covariates. This is recommended when the goal of the downstream statistical analyses is to quantify associations between imaging data and biological variables; this will make sure to preserve the biological variability while removing the variability associated with site/scanner. 

For illustration purpose, let's simulate an imaging dataset with n=10 participants, acquired on 2 scanners, with 5 participants each, with p=10000 voxels per scan. 

```matlab
p=10000;
n=10;
batch = [1 1 1 1 1 2 2 2 2 2]; %Batch variable for the scanner id
dat = randn(p,n); %Random data matrix
```
and let simulate two biological covariates, age and sex:
```matlab
age = [82 70 68 66 80 69 72 76 74 80]'; % Continuous variable
sex = [1 2 1 2 1 2 1 2 1 2]'; % Categorical variable (1 for females, 2 for males)
```

To model biological covariates, a model matrix that will be used to fit coefficients in the linear regression framework has to be provided. To build such a model matrix, continuous variables can be used as they are as columns in the model matrix. For categorical variables, a chosen reference group has to be omitted in the model matrix for identifiability as the intercept will be already included in the ComBat model. 

The following code will create a model matrix with age as the first column, and a dummy variable for males as a second column:

```matlab
sex = dummyvar(sex);
mod = [age sex(:,2)];
```


We use the function `combat` to harmonize the data across the 2 scanners using parametric adjustements:
```matlab
data_harmonized = combat(dat, batch, mod, 1);
```
The fourth argument, ```1```, indicates parametric adjustements. To perform non-parametric adjustments, replace ```1``` by ```0``` as follows:

```matlab
data_harmonized = combat(dat, batch, mod, 0);
```

To use ComBat without adjusting for biological variables, simply set
```matlab
mod=[];
```

### 2.2 Examples for specifying biological covariates using `mod`


Supposed we have 3 biological covariates: age, sex (males of females) and disease (healthy, mci, or AD).

```matlab
age = [82 70 68 66 80 69 72 76 74 80]'; % Continuous variable
sex = [1 2 1 2 1 2 1 2 1 2]'; % Categorical variable (1 for females, 2 for males)
sex = dummyvar(sex)
disease = {'ad'; 'healthy';'healthy';'healthy';'mci';'mci';'healthy'; 'ad'; 'ad';'mci'};
disease = categorical(disease)
disease = dummyvar(disease)
```

To build the model matrix, we need to omit one category (reference group) for each of the categorical variables (sex and disease):

```matlab
mod = [age sex(:,2) disease(:,2:3)]
```

Here, we only omitted the first catergoy for sex and disease. Note that the choice of the reference groups will not impact the harmonization results. 



