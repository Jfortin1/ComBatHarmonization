# ComBatHarmonization
### Multi-site harmonization with ComBat for imaging data

--------
**Maintainer**: Jean-Philippe Fortin, fortin946@gmail.com

**References**: If you are using ComBat for the harmonization of multi-site imaging data, please cite the following two papers:

|       | Citation     | Paper Link
| -------------  | -------------  | -------------  |
| ComBat for multi-site DTI data    | Jean-Philippe Fortin, Drew Parker, Birkan Tunc, Takanori Watanabe, Mark A Elliott, Kosha Ruparel, David R Roalf, Theodore D Satterthwaite, Ruben C Gur, Raquel E Gur, Robert T Schultz, Ragini Verma, Russell T Shinohara. **Harmonization Of Multi-Site Diffusion Tensor Imaging Data**. bioRxiv, 2017  |[Link](http://biorxiv.org/content/early/2017/03/22/116541)| 
| Original ComBat paper for gene expression array    |  W. Evan Johnson and Cheng Li, **Adjusting batch effects in microarray expression data using empirical Bayes methods**. Biostatistics, 8(1):118-127, 2007.      | [Link](https://academic.oup.com/biostatistics/article/8/1/118/252073/Adjusting-batch-effects-in-microarray-expression) |


## Table of content
- [1. Introduction](#id-section1)
- [2. Software](#id-section2)

<div id='id-section1'/>

## 1. Introduction

Imaging data suffer from technical between-scanner variation that hinders comparisons of images across imaging sites, scanners and over time. This includes common imaging modalities, such as MRI, fMRI and DTI, as well as measurements derived from those modalities, for instance ROI volumes, RAVENS maps, cortical thickness measurements, etc. To maximize statistical power, post-processing data harmonization is a powerful technique to remove unwanted variation when combining data across scanners and sites. In a recent [manuscript](http://biorxiv.org/content/early/2017/03/22/116541), we have shown that [ComBat](https://academic.oup.com/biostatistics/article/8/1/118/252073/Adjusting-batch-effects-in-microarray-expression), a popular batch-effect correction tool used in genomics, succesffuly removes inter-site technical variability while preserving inter-site biological variability. We showed that ComBat performs well for multi-site imaging studies that only have a few participants per site. We also showed that ComBat was robust to unbalanced studies, that is studies for which the biological covariate of interest is not balanced across sites. 

<div id='id-section2'/>

## 2. Software

The reference implementation of ComBat is written in R and is part of the `sva` package available through the Bioconductor project [here](https://bioconductor.org/packages/release/bioc/html/sva.html). We include here a reimplementation of ComBat in both R and Matlab for the harmonization of imaging data. Our implementation extends the original code for more flexibility and better visualization of the internal components of the algorithm. We are also currently working on several extensions of the original method that will be included here as well. 

**Tutorials, instructions and examples for using ComBat:**
- [R implementation](https://github.com/Jfortin1/ComBatHarmonization/tree/master/R)
- [Matlab implementation](https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab)






