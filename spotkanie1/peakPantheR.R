# instalacja BiocManager, niezbędny aby wykorzystywać paczki z Bioconductora

install.packages("BiocManager")

# instalacja peakPantheR

BiocManager::install("peakPantheR")

# można też BiocManager::install("phenomecentre/peakPantheR")
# wtedy instalujemy wersję developerską

# ładujemy peakPantheR

library(peakPantheR)

# uruchamiamy GUI

peakPantheR_start_GUI(browser = TRUE)
