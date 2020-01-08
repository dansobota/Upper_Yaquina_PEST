# January 7, 2020

# Script to extract continuous dissolved oxygen output from QUAL2Kw model

# Dan Sobota, Oregon DEQ, sobota.daniel@deq.state.or.us

# Define working directories and files----
filePath <- "\\\\deqhq1\\tmdl\\TMDL_WR\\MidCoast\\Models\\Dissolved Oxygen\\Upper Yaquina River - 1710020401\\Upper Yaquina DO TMDL\\4. Modeling\\QUAL2Kw\\Model_Scenarios\\MOS\\"
output <- dir(path = filePath, pattern = ".out")

# Read in file----
tmp.file <- scan(file = paste0(filePath, output), what = "character", sep = "\n")

# Map out the location of data in the file
header.ln <- grep("^.*Diel water quality in the main channel.*$", tmp.file)[1]  # Make sure just part 1 is identified
end.ln <- grep("^.*Diel water quality in the main channel.*$", tmp.file)[2]  # Part 2 is after the end of the data set

# Column header names, split on two spaces, create char vect, then get rid of spaces
header.nm <- gsub("(^+ )|( +$)",
                  "", 
                  do.call(cbind,
                          strsplit(tmp.file[header.ln + 1], 
                                   split=" {2,}")
                          )
                  )

# Grab numeric data
num.1st <- header.ln + 
           min(grep("^.*[0-9]",
           tmp.files[[j]][header.ln + 1:length(tmp.files[[j]])]))

tmp.data <- tmp.files[[j]][num.1st:length(tmp.files[[j]])]

tmp.list <- list()

# Seperate data on at least two spaces then create data frame using rbind
for (y in 1:length(tmp.data)) {
  tmp.list[[y]] <- as.data.frame(strsplit(tmp.data[y], split = " {2,}"))
  names(tmp.list[[y]]) <- y
  tmp.list[[y]] <- t(tmp.list[[y]])
}

# Set blank data frame
tmp.df <- data.frame(stringsAsFactors = F)

# Build dataframe with rbind fill so that empty cells don't repeat
for (z in 1:length(tmp.list)) {
  tmp.df <- bind_rows(tmp.df, as.data.frame(tmp.list[[z]], 
                                            stringsAsFactors = F))
}

# Give columns the appropriate names
names(tmp.df) <- header.nm

# Get data into numeric format except for time data
tmp.df[,-which(names(tmp.df) == "Date_time")] <-
  lapply(tmp.df[ , -which(names(tmp.df) == "Date_time")], as.numeric)
