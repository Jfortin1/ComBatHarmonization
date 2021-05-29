library(SummarizedExperiment)
load("temp/seAdniFs.rda")
se <- seAdniFs


se <- se[,!duplicated(se$RID)]
sites <- table(se$site)
sites <- names(sites[sites>=25])
se <- se[, se$site %in% sites]

#Renaming site:
site <- as.factor(colData(se)$site)
levels(site) <- paste0("Site", 1:length(levels(site)))
colData(se)$site <- as.character(site)

# Adding jitter to age:
colData(se)$age <- jitter(colData(se)$age, 200)

# Only keeping relevant columns:
colData(se) <- colData(se)[, c("ID", "age","gender", "site")]

# Renaming ID:
se <- se[,order(se$site)]
ids <- split(colData(se)$site, f=colData(se)$site)
ids <- lapply(ids, function(x){
    paste0(x, "_Scan",1:length(x))
}) 
se$ID <- do.call(c, ids)
colnames(se) <- se$ID

# Jittering data:
Y <- assays(se)[[1]]
for (i in 1:nrow(Y)){
    y <- Y[i,]
    sd <- mad(y, na.rm=TRUE)
    y <- jitter(y, amount=sd/4)
    Y[i, ] <- y
}
assays(se)[[1]] <- Y


#Modifying annotation:
ann <- rowData(se)
ann <- ann[, c("FLDNAME", "TEXT")]
colnames(ann) <- c("ID", "Description")
rowData(se) <- ann
metadata(se) <- list(NULL)
seCorticalThickness <- se
save(seCorticalThickness, file="../../data/seCorticalThickness.rda")



age <- colData(se)$age
col <- as.integer(as.factor(colData(se)$site))
tab=table(col)
sites <- names(tab)
good <- col %in% sites
Y <- assays(se)[[1]]
cors <- sapply(1:nrow(Y), function(i){
    cor(age, Y[i,], use="p")
})
wh=which.min(cors)
#wh=order(cors)[1:10][8]
plot(age, Y[wh,],col=col)






