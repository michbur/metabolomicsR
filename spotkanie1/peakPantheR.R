# instalacja BiocManager, niezbędny aby wykorzystywać paczki z Bioconductora

install.packages("BiocManager")

# instalacja peakPantheR

BiocManager::install("phenomecentre/peakPantheR")

# ładujemy peakPantheR

library(peakPantheR)

# uruchamiamy GUI

peakPantheR_start_GUI(browser = TRUE)
