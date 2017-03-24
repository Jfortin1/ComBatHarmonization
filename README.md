# ComBatHarmonization
### Multi-site harmonization with ComBat

--------
**Maintainer**: Jean-Philippe Fortin, fortin946@gmail.com

##### References

| Method      | Citation     | Paper Link
| -------------  | -------------  | -------------  |
| RAVEL    |  Jean-Philippe Fortin, Elizabeth M Sweeney, John Muschelli, Ciprian M Crainiceanu, Russell T Shinohara, Alzheimer's Disease Neuroimaging Initiative, et al. **Removing inter-subject technical variability in magnetic resonance imaging studies**. NeuroImage, 132:198–212, 2016.      | [Link](http://www.sciencedirect.com/science/article/pii/S1053811916001452) |
| WhiteStripe    | Russell T Shinohara, Elizabeth M Sweeney, Jeff Goldsmith, Navid Shiee, Farrah J Mateen, Peter A Calabresi, Samson Jarso, Dzung L Pham, Daniel S Reich, Ciprian M Crainiceanu, Australian Imaging Biomarkers Lifestyle Flagship Study of Ageing, and Alzheimer’s Disease Neuroimaging Initiative. **Statistical normalization techniques for magnetic resonance  imaging**. Neuroimage Clin, 6:9–19, 2014.    |[Link](http://www.sciencedirect.com/science/article/pii/S221315821400117X)| 



## Table of content
- [1. Introduction](#id-section1)
- [2. Image preprocessing](#id-section2)


<div id='id-section1'/>
## 1. Introduction

RAVEL is an R package that combines the preprocessing and statistical analysis of magnetic resonance imaging (MRI) datasets within one framework. Users can start with raw images in the NIfTI format, and end up with a variety of statistical results associated with voxels and regions of interest (ROI) in the brain. RAVEL stands for _Removal of Artificial Voxel Effect by Linear regression_, the main preprocessing function of the package that allows an effective removal of between-scan unwanted variation. We have shown in [a recent paper](http://www.sciencedirect.com/science/article/pii/S1053811916001452) that RAVEL improves significantly population-wide statistical inference. The vignette is divided into several sections. In Section 1, we present a pre-normalization preprocessing pipeline from raw images to processed images ready for intensity normalization. In Section 2, we explain how to use the RAVEL algorithm as well as other intensity normalization techniques. In Section 3, we present different tools for post-normalization statistical analysis. In Section 4, we present additional functions that help the visualization of images and statistical results. 

##### Installation

```{r}
library(devtools)
install_github("jfortin1/RAVEL")
```


<div id='id-section2'/>
## 2. Image preprocessing 





