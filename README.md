# ComBatHarmonization
### Harmonization of multi-site imaging data with ComBat

--------
**Maintainer**: Jean-Philippe Fortin, fortin946@gmail.com

**Licenses**: 

- R code: Artistic 2.0 License
- Python code: MIT License
- Matlab code: MIT License

**References**: If you are using ComBat for the harmonization of multi-site imaging data, please cite the following papers:


|       | Citation     | Paper Link
| -------------  | -------------  | -------------  |
| ComBat for multi-site DTI data    | Jean-Philippe Fortin, Drew Parker, Birkan Tunc, Takanori Watanabe, Mark A Elliott, Kosha Ruparel, David R Roalf, Theodore D Satterthwaite, Ruben C Gur, Raquel E Gur, Robert T Schultz, Ragini Verma, Russell T Shinohara. **Harmonization Of Multi-Site Diffusion Tensor Imaging Data**. NeuroImage, 161, 149-170, 2017  |[Link](https://www.sciencedirect.com/science/article/pii/S1053811917306948?via%3Dihub#!)| 
| ComBat for multi-site cortical thickness measurements    | Jean-Philippe Fortin, Nicholas Cullen, Yvette I. Sheline, Warren D. Taylor, Irem Aselcioglu, Philip A. Cook, Phil Adams, Crystal Cooper, Maurizio Fava, Patrick J. McGrath, Melvin McInnis, Mary L. Phillips, Madhukar H. Trivedi, Myrna M. Weissman, Russell T. Shinohara. **Harmonization of cortical thickness measurements across scanners and sites**. NeuroImage, 167, 104-120, 2018  |[Link](https://www.sciencedirect.com/science/article/pii/S105381191730931X)| 
| Original ComBat paper for gene expression array    |  W. Evan Johnson and Cheng Li, **Adjusting batch effects in microarray expression data using empirical Bayes methods**. Biostatistics, 8(1):118-127, 2007.      | [Link](https://academic.oup.com/biostatistics/article/8/1/118/252073/Adjusting-batch-effects-in-microarray-expression) |


## Table of content
- [1. Introduction](#id-section1)
- [2. Software implementations](#id-section2)
- [3. Missing values](#id-section3)
- [4. FAQs](#id-section3)
- [5. News](#id-section3)

<div id='id-section1'/>

## 1. Introduction

Imaging data suffer from technical between-scanner variation that hinders comparisons of images across imaging sites, scanners and over time. This includes common imaging modalities, such as MRI, fMRI and DTI, as well as measurements derived from those modalities, for instance ROI volumes, RAVENS maps, cortical thickness measurements, connectome matrices, etc. To maximize statistical power, post-processing data harmonization is a powerful technique to remove unwanted variation when combining data across scanners and sites. 

In two recent papers ([harmonization of DTI data](https://www.sciencedirect.com/science/article/pii/S1053811917306948?via%3Dihub#!) and [harmonization of cortical thickness measurements](https://www.sciencedirect.com/science/article/pii/S105381191730931X)) we have shown that [ComBat](https://academic.oup.com/biostatistics/article/8/1/118/252073/Adjusting-batch-effects-in-microarray-expression), a popular batch-effect correction tool used in genomics, succesffuly removes inter-site technical variability while preserving inter-site biological variability. We showed that ComBat performs well for multi-site imaging studies that only have a few participants per site. We also showed that ComBat was robust to unbalanced studies, in which the biological covariate of interest is not balanced across sites. 

We recommend to use the ComBat harmonization method after imaging processing before downstream statistical analyses. The ComBat harmonization requires the imaging data to be represented in a matrix where rows are the imaging features (for instance voxels, ROIs or connectome edges) and columns are the participants. For example, for voxel-level analyses, this usually requires images to be registered to a common template space. 

### Input and parameters

Data inputs for ComBat are:
- ***A data matrix***. The data to harmonize. Rows are features (for instance voxels or brain regions) and columns are participants. 
- ***A batch id vector***. A vector (length should be equal to the number of columns in the data matrix) that specifies the id for the batch, site, or scanner to correct for. ComBat only accepts one batch vector. You should provide the smallest unit of the study that you believe introduces unwanted variation. For instance, for a study with 2 sites and 3 scanners (1 site with 1 scanner, 1 site with 2 scanners), the id for scanner should be used. 
- ***Biological variables***. Optional design matrix specifying biological covariates that should be protected for during the removal of scanner/site effects, such as disease status, age, gender, etc. 

There are several alternative modes of running ComBat:
- ```parametric=FALSE```: will instead use a non-parametric prior method in the empirical Bayes procedure (default uses parametric priors).
- ```eb=FALSE```: will not run the empirical Bayes procedure, and therefore location and scale parameters are not shrunk towards common factors averaged across features. This is equivalent to running a location-and-scale correction method for each feature separately. This is particularly useful for debugging and method development. 
- ```mean.only=TRUE```: will only adjust the mean of the site effects across sites (default adjusts for mean and variance). This option is recommended for studies where the variances are expected to be different across sites due to the biology. 


<div id='id-section2'/>

## 2. Software implementations

The reference implementation (Standard Version) of ComBat, developed for gene expression analyses, is written in R and is part of the `sva` package available through the Bioconductor project [here](https://bioconductor.org/packages/release/bioc/html/sva.html). We include here a reimplementation of ComBat in R, Matlab and Python (neuroCombat) for the harmonization of imaging data. Our R implementation extends the original code for more flexibility and additional visualization of the internal components of the algorithm. We are also currently working on several extensions of the original method that will be included here as well. We use the MIT license for the Python and Matlab code, and an Artistic License 2.0 for the R code to be compatible with the `sva` package. 

- [R implementation webpage](https://github.com/Jfortin1/ComBatHarmonization/tree/master/R)
- [Python implementation webpage](https://github.com/Jfortin1/ComBatHarmonization/tree/master/Python) (neuroCombat)
- [Matlab implementation webpage](https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab)

### Current implemented features

|                | R | Python | Matlab |
|----------------|---|--------|--------|
| Parametric adjustments     | x | x      | x      |
| Non-parametric adjustments | x | x      | x      |
| Empirical Bayes   | x |   x     | x      |
| No empirical Bayes   | x |    x    |       |
| Mean adjustment only | x |    x    |        |
| Reference batch | x |    x    |        |
| Can handle missing values | x |        |        |


### Testing and comparing the different implementations

The `Testing` directory contains code for testing and comparing the outputs from the R, Matlab and Python implementations. We routinely perform the analyses to make sure that all versions and implementations agree with each other, as well as with the ```sva``` implementation of ComBat, for all modes of running ComBat (parametric/non-parametric/eb/mean.only).  

<div id='id-section3'/>

## 3. Handling of missing values

- For R, the current implementation accepts missing values. Constant rows, and rows with missing values only, need to be removed before running ComBat. Not removing such rows will results in an error, or a matrix of NaN values. 

- For Matlab and Python, the input data can only contain finite values (no NA or Nan). Constant rows, and rows with missing values only, need to be removed before running ComBat. Not removing such rows will results in an error, or a matrix of NaN values. 

<div id='id-section4'/>

## 4. FAQs

<div id='id-section5'/>

## 5. News

05-23-2020: Reference batch option (```ref.batch```) now implemented in Python.

05-19-2020: Reference batch option (```ref.batch```) now implemented in R. 

05-17-2020: Mean adjustment only option (```mean.only=True```) now implemented in both Python and R.

05-15-2020: Non-parametric adjustments (```parametric=False```), and ```eb=False``` now implemented in both Python and R.

05-14-2020: We migrated our official Python implementation (neuroCombat) here for maintainability. 

03-06-2020: ComBat in R now accepts missing values.

05-19-2019: Added the option of running the non-parametric version of ComBat in the R implementation. 

05-19-2019: Added the option of running the non-parametric version of ComBat in the Matlab implementation. 









