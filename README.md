# ComBatHarmonization
### Harmonization of multi-site imaging data with ComBat

--------
**Maintainer**: Jean-Philippe Fortin, fortin946@gmail.com

**License**: Artistic License 2.0

**References**: If you are using ComBat for the harmonization of multi-site imaging data, please cite the following two papers:

|       | Citation     | Paper Link
| -------------  | -------------  | -------------  |
| ComBat for multi-site DTI data    | Jean-Philippe Fortin, Drew Parker, Birkan Tunc, Takanori Watanabe, Mark A Elliott, Kosha Ruparel, David R Roalf, Theodore D Satterthwaite, Ruben C Gur, Raquel E Gur, Robert T Schultz, Ragini Verma, Russell T Shinohara. **Harmonization Of Multi-Site Diffusion Tensor Imaging Data**. bioRxiv, 2017  |[Link](http://biorxiv.org/content/early/2017/03/22/116541)| 
| Original ComBat paper for gene expression array    |  W. Evan Johnson and Cheng Li, **Adjusting batch effects in microarray expression data using empirical Bayes methods**. Biostatistics, 8(1):118-127, 2007.      | [Link](https://academic.oup.com/biostatistics/article/8/1/118/252073/Adjusting-batch-effects-in-microarray-expression) |


## Table of content
- [1. Introduction](#id-section1)
- [2. Software](#id-section2)
- [3. Testing](#id-section3)

<div id='id-section1'/>

## 1. Introduction

Imaging data suffer from technical between-scanner variation that hinders comparisons of images across imaging sites, scanners and over time. This includes common imaging modalities, such as MRI, fMRI and DTI, as well as measurements derived from those modalities, for instance ROI volumes, RAVENS maps, cortical thickness measurements, connectome matrices, etc. To maximize statistical power, post-processing data harmonization is a powerful technique to remove unwanted variation when combining data across scanners and sites. In a recent [manuscript](http://biorxiv.org/content/early/2017/03/22/116541), we have shown that [ComBat](https://academic.oup.com/biostatistics/article/8/1/118/252073/Adjusting-batch-effects-in-microarray-expression), a popular batch-effect correction tool used in genomics, succesffuly removes inter-site technical variability while preserving inter-site biological variability. We showed that ComBat performs well for multi-site imaging studies that only have a few participants per site. We also showed that ComBat was robust to unbalanced studies, that is studies for which the biological covariate of interest is not balanced across sites. 

We recommend to use the ComBat harmonization method after imaging processing, just right before the statistical analysis. The ComBat harmonization requires the imaging data to be represented in a matrix where rows are the imaging features (for instance voxels, ROIs or connectome edges) and columns are the participants. For example, for voxel-level analyses, this usually requires the images to be registered to a common template space. 

The ComBat algorithm needs two mandatory inputs:
- ***The data matrix***. Rows are features and columns are participants. 
- ***The site, study or scanner variable***. The algorithm can only handle one variable. You should provide the smallest unit of the study that you believe introduces unwanted variable. For instance, for a study with 2 sites and 3 scanners (1 site with 1 scanner, 1 site with 2 scanners), the variable for scanner should be used. 

The ComBat algorithm also accepts an optional input:
- ***Biological variables***. You can provide biological covariates, such as disease status, age, gender, to ensure that the harmonization technique does not remove the effects of those variables on the imaging data. The algorithm will take the variability associated with those variables in the estimation of the site/scanner effects. 

<div id='id-section2'/>

## 2. Software

The reference implementation (Standard Version) of ComBat, developed for gene expression analyses, is written in R and is part of the `sva` package available through the Bioconductor project [here](https://bioconductor.org/packages/release/bioc/html/sva.html). We include here a reimplementation of ComBat in both R and Matlab for the harmonization of imaging data. Our implementation extends the original code for more flexibility and additional visualization of the internal components of the algorithm. We are also currently working on several extensions of the original method that will be included here as well. We use the same open-source license as the `sva` package, that is the Artistic License 2.0. 

**Tutorials, instructions and examples for using ComBat:**
- [R implementation](https://github.com/Jfortin1/ComBatHarmonization/tree/master/R)
- [Matlab implementation](https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab)

<div id='id-section2'/>

## 3. Testing

The `Testing` directory contains code for comparing and testing the outputs from R and Matlab. 





