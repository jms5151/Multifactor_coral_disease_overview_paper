# Create SMOTE datasets for unbalanced data

# set random seed
set.seed(12093248)

# set destination directory for smote datasets
dest_dir <- 'data/smote_data/'

# load survey data
GA_data_with_all_predictors <- read.csv('data/survey_data/GA_data_with_all_predictors.csv')
WS_data_with_all_predictors <- read.csv('data/survey_data/WS_data_with_all_predictors.csv')

# load full set of covariates to test in models
source('codes/Initial_covariates_to_test_by_disease_and_region.R')

# load custom functions
source('codes/custom_functions/fun_subset_df.R')
source('codes/custom_functions/fun_filter_pseudo_replicates.R')
source('codes/custom_functions/fun_create_smote_datasets.R')
source('codes/custom_functions/fun_split_df_train_test.R')

# combine custom functions for work flow
surveys_to_test_train <- function(df, regionGBR, family, dz_vars, yVar, threshold){
  # Step 1. Subset all surveys
  x <- subset_df(
    df = df
    , regionGBR = regionGBR
    , family = family
    , dz_vars = c(dz_vars, 'cold_snaps') # add cold snaps for validation of V2 product
    )
  # Step 2. Remove surveys that are conducted too closely in space and time
  x2 <- filter_pseudo_replicates(df = x)
  # Step 3. Create SMOTE datasets
  x3 <- create_smote_df(df = x2, yVar = yVar, threshold = threshold)
  # Step 4. Split data into training and testing datasets
  x4 <- split_train_test_dfs(df = x3, yVar = yVar)
  # return df
  x4
}

# function to loop through thresholds
smote_across_thresholds <- function(df, regionGBR, family, dz_vars, yVar, thresholds, fileName){
  for(i in thresholds){
    smote_df = surveys_to_test_train(
      df = df
      , regionGBR = regionGBR
      , family = family
      , dz_vars = c(dz_vars, 'cold_snaps') # add cold snaps for validation of V2 product
      , yVar = yVar
      , threshold = i
      )
    
    # create filenames
    if(regionGBR == FALSE){
      thsh = i * 100
    } else {
      thsh = i
    }
    
    # add leading zero if needed so same number of digits in filename
    if(nchar(thsh) == 1){
      thsh <- as.character(paste0('0', thsh))
    }
    
    # filepaths
    trainfilename = paste0(dest_dir, fileName, '_smote_train_', thsh, '.csv')
    testfilename = paste0(dest_dir, fileName, '_smote_test_', thsh, '.csv')
    
    # save data
    write.csv(smote_df[[1]], trainfilename, row.names = F)
    write.csv(smote_df[[2]], testfilename, row.names = F)
  }
}

# Create train/test SMOTE datasets for each disease-region-threshold combination  

# GA GBR 
smote_across_thresholds(
  df = GA_data_with_all_predictors
  , regionGBR = TRUE
  , family = NA
  , dz_vars = ga_gbr_vars
  , yVar = 'Y'
  , thresholds = c(1, 5, 10, 15) 
  , fileName = 'ga_gbr'
)

# GA Pacific 
smote_across_thresholds(
  df = GA_data_with_all_predictors
  , regionGBR = FALSE
  , family = 'Poritidae'
  , dz_vars = ga_pac_vars
  , yVar = 'p'
  , thresholds = c(0.01, 0.05, 0.10, 0.15, 0.20)
  , fileName = 'ga_pac'
)

# WS GBR 
smote_across_thresholds(
  df = WS_data_with_all_predictors
  , regionGBR = TRUE
  , family = ''
  , dz_vars = ws_gbr_vars
  , yVar = 'Y'
  , thresholds = c(1, 5, 10)
  , fileName = 'ws_gbr'
)

# WS Pacific 
smote_across_thresholds(
  df = WS_data_with_all_predictors
  , regionGBR = FALSE
  , family = 'Acroporidae'
  , dz_vars = ws_pac_acr_vars
  , yVar = 'p'
  , thresholds = c(0.01, 0.05, 0.10)
  , fileName = 'ws_pac_acr'
)

