# Parametric:
data_r <- as.matrix(read.csv("data/testdata_combat_parametric_r.csv"))
data_matlab <- as.matrix(read.csv("data/testdata_combat_parametric_matlab.csv", head=FALSE))
tol <- 10e-14
similarity <- sum((data_r-data_matlab)<tol)/ncol(data_r)/nrow(data_r)*100
similarity


data_r <- as.matrix(read.csv("data/testdata_combat_nonparametric_r.csv"))
data_matlab <- as.matrix(read.csv("data/testdata_combat_nonparametric_matlab.csv", head=FALSE))
tol <- 10e-14
similarity <- sum((data_r-data_matlab)<tol)/ncol(data_r)/nrow(data_r)*100
similarity