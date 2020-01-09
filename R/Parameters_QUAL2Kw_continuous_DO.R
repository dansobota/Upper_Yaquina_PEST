# January 8, 2020

# Script to identify model parameters to be adjusted for meeting DO criteria in the QUAL2Kw model

# Dan Sobota, Oregon DEQ, sobota.daniel@deq.state.or.us

# Define working directories and files----
filePath <- "\\\\deqhq1\\tmdl\\TMDL_WR\\MidCoast\\Models\\Dissolved Oxygen\\Upper Yaquina River - 1710020401\\Upper Yaquina DO TMDL\\4. Modeling\\QUAL2Kw\\Model_Scenarios\\MOS\\"
input <- dir(path = filePath, pattern = ".q2k")

# Q2K file----
tmp.file <- scan(file = paste0(filePath, input), what = "character", sep = "\n")

# Effective shade along main reach----
