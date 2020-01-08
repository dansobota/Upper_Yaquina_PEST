# January 8, 2020

# Processing QUAL2Kw outputs for evaluation against Cold Water Criteria for delisting

# Dan Sobota, Oregon DEQ, sobota.daniel@deq.state.or.us

# Source data script to load data----
source("Extracting_QUAL2Kw_continuous_DO.R")

# Get dataframe into date and numeric format----
# Get data into numeric format
Q2K.df.num <- as.data.frame(
                            apply(subset(Q2K.df, select = c("Reach", "Time", "Dissolved Oygen")),
                                  2,
                                  as.numeric
                                  )
                            )

# Need Reach to be an integer
Q2K.df.num$Reach <- as.integer(Q2K.df.num$Reach)
Q2K.df.num$MeetDO <- ifelse(Q2K.df.num$`Dissolved Oygen` < 8, FALSE, TRUE)


# Apply binomial test to model output----
# First define parameters of the test

prob.meet <- 0.9
meet.confid <- 0.9

# Performing the binomial test by Reach
Q2K.binom.results <- binom.test(x = sum(Q2K.df.num[Q2K.df.num$Reach == 1, ]$MeetDO),
                                n = length(Q2K.df.num[Q2K.df.num$Reach == 1, ]$MeetDO),
                                p = prob.meet,
                                alternative = "two.sided",
                                conf.level = meet.confid
                                )

Q2K.binom.results[[3]]
