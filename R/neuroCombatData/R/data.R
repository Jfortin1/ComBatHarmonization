#' Simulated multi-site cortical thickness measurements
#'
#' SummarizedExperiment containing simulated multi-site
#'     cortical thickness measurements (263 subjects across 9 sites).
#'     Data were simulated based on a subset of the UCSF FreeSurfer 
#'     cross-sectional cortical thickness processed data.The goal of
#'     the simulation was to create a dataset that mimics both
#'     the technical variability and biological variability observed
#'     in a in real-world study. Imaging features (ROIs)
#'     correspond to the featured measured in the FreeSurfer software (v6.0).
#'
#' @format A SummarizedExperiment with 341 rows (ROIs) and 
#'     263 columns (subjects) 
#' 
#' @references 
#' Dale AM, Fischl B, Sereno MI. Cortical surface-based analysis:
#'     I. Segmentation and surface reconstruction.
#'     Neuroimage.1999 Feb 1;9(2):179-94.
#'     \url{https://doi.org/10.1006/nimg.1998.0395}
#' 
#' 
"seCorticalThickness"
