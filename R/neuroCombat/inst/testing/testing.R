library(neuroCombat)
dat=combatExampleData
scanner=combatExampleScanner
dat[1,1:5] <- 2.5
dat[1,1:5+5] <- 10
norm=neuroCombat(dat, batch=scanner)$dat.combat

library(neuroCombat)
dat=combatExampleData
scanner=combatExampleScanner
dat[1,1:5] <- 10
dat[1,1:5+5] <- 10
norm=neuroCombat(dat, batch=scanner)$dat.combat
