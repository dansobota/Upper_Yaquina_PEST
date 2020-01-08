# January 8, 2020

# Processing QUAL2Kw outputs for evaluation against Cold Water Criteria for delisting

# Dan Sobota, Oregon DEQ, sobota.daniel@deq.state.or.us

# Source data script to load data----
source("Extracting_QUAL2Kw_continuous_DO.R")

# Get dataframe into date and numeric format----
# Get data into numeric format
Q2K.df.num <- as.data.frame(
                            apply(Q2K.df[ , -which(names(Q2K.df) == "")],
                                  2,
                                  as.numeric
                                  )
                            )

# Need Reach to be an integer
Q2K.df.num$Reach <- as.integer(Q2K.df.num$Reach)

# Apply binomial test to model output----
