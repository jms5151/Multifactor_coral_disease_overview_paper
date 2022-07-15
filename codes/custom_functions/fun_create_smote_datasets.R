# custom function for creating synthetic datasets
library(tidyverse)
library(smotefamily)

create_smote_df <- function(df, yVar, threshold){
  # remove data and separate datasets according to response variable and threshold
  df <- df %>% select(-c(Date))
  df$Health_status <- ifelse((df[, yVar] <= threshold), 0, 1)
  # create smote dataset
  dz_smote = SMOTE(
    df
    , target = df$Health_status
    , K = 3
    )
  # format
  dz_smote <- as.data.frame(dz_smote$data)
  dz_smote$Day <- as.integer(round(dz_smote$Day))
  dz_smote$Month <- as.integer(round(dz_smote$Month))
  dz_smote$Year <- as.integer(round(dz_smote$Year))
  dz_smote <- dz_smote %>% select(-c(Health_status, class))
  dz_smote
}

