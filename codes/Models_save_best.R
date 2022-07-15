# Re-run best models, save objects
library(quantregForest)

# load best models key
best_models_final <- read.csv('data/parsimonious_best_models_by_disease_and_region.csv')

# directory paths
smote_dir <- 'data/smote_data/'
model_objects_dir <- 'models/'

# run models and save model objects
for(i in 1:nrow(best_models_final)){
  # format filenames for best models
  thsh <- ifelse(nchar(best_models_final$threshold[i]) == 2, best_models_final$threshold[i], paste0('0', best_models_final$threshold[i]))
  dz_name <- ifelse(best_models_final$name[i] == 'ws_pac', 'ws_pac_acr', best_models_final$name[i])
  train_name <- paste0(smote_dir, dz_name, '_smote_train_', thsh, '.csv')

  # load data
  df_train <- read.csv(train_name)

  # format data for quantile regression
  dz_vars <- unlist(strsplit(best_models_final$Model_variables[i], split=', '))
  yVar <- ifelse(dz_name == 'ga_gbr' | dz_name == 'ws_gbr', 'Y', 'p')
  
  x_train <- df_train[, dz_vars] 
  y_train <- df_train[, yVar]

  # run best model
  final_mod <- quantregForest(x_train, y_train, importance = TRUE)
  
  # save model
  modFileName <- paste0(model_objects_dir, best_models_final$name[i], ".rds")
  saveRDS(final_mod, file = modFileName)
}