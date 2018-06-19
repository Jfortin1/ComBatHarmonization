source("../R/scripts/utils.R")
source("../R/scripts/combat.R")
data <- read.csv("data/testdata.csv")
batch = c(1,1,1,1,1,2,2,2,2,2)
mod=model.matrix(~c(1,2,1,2,1,2,1,2,1,2))
norm <- combat(data, batch=batch, mod=mod)
norm <- norm$dat.combat
write.csv(norm, quote=FALSE, file="data/testdata_combat_r.csv", row.names=FALSE)