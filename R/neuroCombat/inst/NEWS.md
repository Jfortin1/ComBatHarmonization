Changes in Version 1.0.13
	- Added neuroCombatData package in Remotes

Changes in Version 1.0.12
    - Suggested dependency of newly-created package neuroCombatData
	- Added vignette using neuroCombatData data

Changes in Version 1.0.11
	- Added neuroCombatFromTraining (development version)

Changes in Version 1.0.8
	- Fixed a bug related to imaging features for which values are constant within a scanner/batch for EB=FALSE option. 

Changes in Version 1.0.7
	- Package now depends on BiocParallel. Parellel options available for non-parametric adjustments to speed up computations.
	- Fixed a bug related to imaging features for which values are constant within a scanner/batch. 
	
Changes in Version 1.0.6
	- Changing MIT license to Artistic-2.0 license

Changes in Version 1.0.5
	- Started adding training/test functionalities
	  
Changes in Version 1.0.4
	- All objects in output have now consistent names (colnames and rownames)
	
Changes in Version 1.0.3
	- In the internal code, we now decouple the standardized mean into two components: intercept (stand.mean) and model mean (mod.mean). 
	  The reason is to be able to use stand.mean only when applying scanner correction on a test dataset without making assumption for biological covariates.


Changes in Version 1.0.1:
	- ComBat now accepts missing values. Note: our way of calculating feature variances (rows) differs from the SVA package. 
		SVA: Variance denominator used when there is no missing values: n
		SVA: Variance denominator used when there are missing values: m-1 (m=total number of non-missing values)
		ComBatHarmonization: Variance denominator used when there is no missing values: n
		ComBatHarmonization: Variance denominator used when there are missing values: m (m=total number of non-missing values)
		By simulating missing values, we have shown that there is much more better agreement between the datasets. 