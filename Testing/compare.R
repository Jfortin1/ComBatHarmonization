library(tidyverse)
tol <- 10e-10
types <- c("parametric_adjusted",
	"parametric_unadjusted",
	"nonparametric_adjusted",
	"nonparametric_unadjusted"
)
files.r <- paste0("testdata_combat_", types, "_r.csv")
files.matlab <- paste0("testdata_combat_", types, "_matlab.csv")

for (i in 1:length(types)){
	data_r <- read.csv(file.path("data", files.r[i])) %>% as.matrix
	data_matlab <- read.csv(file.path("data", files.matlab[i]), head=FALSE) %>% as.matrix
	similarity <- sum((data_r-data_matlab)<tol)/ncol(data_r)/nrow(data_r)*100
	print(similarity)
}