library(mzR)

fl <- system.file("threonine", "threonine_i2_e35_pH_tree.mzXML",
                  package = "msdata")
ms_fl <- openMSfile(fl, backend = "pwiz", verbose = TRUE)
## Get the spectra
pks <- spectra(ms_fl)
## Get the header
hdr <- header(ms_fl)

write.csv(hdr, file = "threonine-header.csv")
