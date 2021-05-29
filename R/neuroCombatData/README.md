# neuroComBatData


## Table of content
- [1. Installation](#id-section1)
- [2. Harmonization](#id-section2)
- [3. Visualization](#id-section3)

<div id='id-section1'/>



## 1. Installation
 
neuroCombat can be installed in R by typing the following commands:

```{r}
library(devtools)
install_github("jfortin1/CombatHarmonization/R/neuroCombatData")
```

This also required to have neuroCombat installed:

```{r}
install_github("jfortin1/CombatHarmonization/R/neuroCombat")
```


<div id='id-section2'/>

## 2. Simulated dataset

The neuroCombatData package contains a dataset called `seCorticalThickness`


that contains simulated multi-site cortical thickness measurements (263 subjects across
9 sites).Data were simulated based on a subset of the UCSF FreeSurfer 
cross-sectional cortical thickness processed data.The goal of
the simulation was to create a dataset that mimics both
the technical variability and biological variability observed
in a in real-world study. Imaging features (ROIs)
correspond to the featured measured in the FreeSurfer software (v6.0).

The data can be accessed using the following code:


```{r}
library(neuroCombatData)
load(seCorticalThickess)
```

