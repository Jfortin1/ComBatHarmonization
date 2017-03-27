datar <- as.matrix(read.csv("testdata_combat_r.csv"))
datamatlab <- as.matrix(read.csv("testdata_combat_matlab.csv", head=FALSE))
sum(datar-datamatlab<10e-20)/100000*100