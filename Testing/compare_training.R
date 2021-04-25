library(tidyverse)
tol <- 10e-4
files.python <- "training_test_scenario2_python.csv"
files.r <- "training_test_scenario2_r.csv"

for (i in 1:length(files.python)){
	data_r <- read.csv(file.path("outputData", files.r[i])) %>% as.matrix
	data_python <- read.csv(file.path("outputData", files.python[i]), head=FALSE) %>% as.matrix
	similarity <- sum((data_r-data_python)<tol)/ncol(data_r)/nrow(data_r)*100
	print(similarity)
}
