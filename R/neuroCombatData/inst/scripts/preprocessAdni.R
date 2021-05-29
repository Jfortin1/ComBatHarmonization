# The following files need to be donwloaded from ADNI first:
#UCSFFSX51_11_08_19.csv
#ADNIMERGE.csv
#UCSFFSX51_DICT_08_01_14.csv
adni_dir <- "adni"
freesurfer_file <- file.path(adni_dir, "UCSFFSX51_11_08_19.csv")
adni_info_file  <- file.path(adni_dir, "ADNIMERGE.csv")
ucsf_info_file  <- file.path(adni_dir, "UCSFFSX51_DICT_08_01_14.csv")

library(SummarizedExperiment)
data <- read.csv(freesurfer_file)
cols <- colnames(data)
roi_columns <- cols[grepl("^ST[0-9]+", cols)]
Y <- data[, roi_columns]
Y <- t(Y)

# Creating a alphanumerical ID:
data$ID <- paste0("img", data[, "IMAGEUID"])
colnames(Y) <- data$ID

# Creating pheno data.frame:
pheno <- data[, !colnames(data) %in% roi_columns]
rownames(pheno) <- pheno$ID
pheno <- pheno[, union("ID", colnames(pheno))]


# Supplementing with more info:
demo <- read.csv(adni_info_file)
demo <- demo[demo$RID %in% pheno$RID,]
wh <- match(pheno$RID, demo$RID)
pheno$age <- demo$AGE[wh]
pheno$gender <- demo$PTGENDER[wh]
pheno$disease <- demo$DX_bl[wh]
pheno$site <- as.character(demo$SITE[wh])

# creating feature data.frame:
ann <- read.csv(ucsf_info_file)
metadata <- ann[!ann$FLDNAME %in% rownames(Y),]
ann <- ann[ann$FLDNAME %in% rownames(Y),]
rownames(ann) <- ann$FLDNAME
ann <- ann[rownames(Y),]

# Creating a data container:
se <- SummarizedExperiment(assays=list(freesurfer=Y),
                           colData=pheno,
                           rowData=ann,
                           metadata=list(info=metadata))


# Only keeping data that pass QC:
se <- se[,colData(se)$OVERALLQC=="Pass"]

# Only keeping data that have demo data:
se <- se[, !is.na(colData(se)$age)]
se <- se[, !is.na(colData(se)$site)]
se <- se[, !is.na(colData(se)$gender)]
se <- se[, !is.na(colData(se)$disease)]

# Saving data:
seAdniFs <- se
dir.create("temp")
save(seAdniFs, file="temp/seAdniFs.rda")
