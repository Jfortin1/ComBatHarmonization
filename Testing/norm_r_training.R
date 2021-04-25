library(neuroCombat)
data <- read.csv("inputData/testdata.csv")
scanner = c(1,1,1,1,1,2,2,2,2,2)
pheno <- rep(0, ncol(data))
pheno[c(1,3,5,7,9)] <- 1
mod=model.matrix(~pheno)


# Defining test and training:
indices.training <- c(1:10)
indices.test     <- c(1,2,6,7)
data.training    <- data[, indices.training]
data.test        <- data[, indices.test]
scanner.training <- scanner[indices.training]
scanner.test     <- scanner[indices.test]

## Scenario 1:
## - no covariates adjustment in training dataset
## - no covariates adjustment in test dataset
## --> Results should be identical
data.training.harmonized <- neuroCombat(data.training,
                                        batch=scanner.training)
data.test.harmonized <- neuroCombat:::neuroCombatFromTraining(data.test,
                                                              batch=scanner.test,
                                                              estimates=data.training.harmonized$estimates)
x=data.training.harmonized$dat.combat[, indices.test]
y=data.test.harmonized$dat.combat
stopifnot(all.equal(x,y))



## Scenario 2: 
## - covariates adjustment in training dataset
## - no covariates adjustment in test dataset
## --> Results should differ
data.training.harmonized <- neuroCombat(data.training,
                                        batch=scanner.training,
                                        mod=mod)
data.test.harmonized <- neuroCombat:::neuroCombatFromTraining(data.test,
                                                              batch=scanner.test,
                                                              estimates=data.training.harmonized$estimates)
x=data.training.harmonized$dat.combat[, indices.test]
y=data.test.harmonized$dat.combat
stopifnot(is.character(all.equal(x,y))) #Should differ
write.csv(data.test.harmonized$dat.combat,
          quote=FALSE,
          file="outputData/training_test_scenario2_r.csv",
          row.names=FALSE)

mod=NULL
dat=data.test
batch=scanner.test
estimates=data.training.harmonized$estimates
info=data.training.harmonized$info


