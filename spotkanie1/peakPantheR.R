# instalacja BiocManager, niezbędny aby wykorzystywać paczki z Bioconductora

install.packages("BiocManager")

# instalacja peakPantheR

BiocManager::install("phenomecentre/peakPantheR")

# można też BiocManager::install("phenomecentre/peakPantheR") - jaka jest różnica?

# ładujemy peakPantheR

library(peakPantheR)

# uruchamiamy GUI

peakPantheR_start_GUI(browser = TRUE)
