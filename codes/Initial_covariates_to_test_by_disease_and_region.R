# Initial covariates to test in models for each disease and region

# Growth anomalies GBR --------------------------
ga_gbr_vars <- c("Y",
                 "Month",
                 "Coral_cover",
                 "Fish_abund",
                 "SST_90dMean",
                 "BlackMarble_2016_3km_geo.3",
                 "Long_Term_Kd_Median",
                 "Long_Term_Kd_Variability",
                 "Three_Week_Kd_Median",
                 "Three_Week_Kd_Variability"
                 )

# Growth anomalies Pacific -----------------------
ga_pac_vars <- c("p",
                 "Month",
                 "Median_colony_size",
                 "CV_colony_size",
                 "Poritidae_mean_cover",
                 "H_abund",
                 "SST_90dMean",
                 "BlackMarble_2016_3km_geo.3",
                 "Long_Term_Kd_Median",
                 "Long_Term_Kd_Variability",
                 "Three_Week_Kd_Median",
                 "Three_Week_Kd_Variability"
                 )

# White syndromes GBR -------------------------
ws_gbr_vars <- c("Y", 
                 "Month", 
                 "Coral_cover", 
                 "Fish_abund", 
                 "Winter_condition",
                 "Hot_snaps",
                 "Long_Term_Kd_Median",
                 "Long_Term_Kd_Variability",
                 "Three_Week_Kd_Median",
                 "Three_Week_Kd_Variability"
                 )

# White syndromes Pacific (Acroporidae) -------
ws_pac_acr_vars <- c("p",
                     "Month",
                     "Median_colony_size",
                     "H_abund",
                     "Parrotfish_abund",
                     "Butterflyfish_abund",
                     "Acroporidae_mean_cover",
                     "Winter_condition",
                     "Hot_snaps",
                     "Long_Term_Kd_Median",
                     "Long_Term_Kd_Variability",
                     "Three_Week_Kd_Median",
                     "Three_Week_Kd_Variability"
                     )


