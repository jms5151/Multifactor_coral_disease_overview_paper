# load custom functions
source('codes/custom_functions/fun_plot_pdp_and_variable_importance.R')

# load model objects
source('codes/Final_covariates_by_disease_and_region.R')

# load training data for PDP plots
ga_gbr_data <- read.csv('data/smote_data/ga_gbr_smote_train_15.csv')
ga_pac_data <- read.csv('data/smote_data/ga_pac_smote_train_20.csv')
ws_gbr_data <- read.csv('data/smote_data/ws_gbr_smote_train_10.csv')
ws_pac_acr_data <- read.csv('data/smote_data/ws_pac_acr_smote_train_10.csv')

# Create figure friendly covariate names
covar_names <- unique(c(ga_gbr_vars, ga_pac_vars, ws_gbr_vars, ws_pac_acr_vars))
covar_names <- data.frame('covars' = covar_names)
covar_names$covar_labels <- gsub('_', ' ', covar_names$covars)
covar_names$covar_labels <- gsub('Three Week ', 'Seasonal ', covar_names$covar_labels)
covar_names$covar_labels <- gsub('Long Term ', 'Chronic ', covar_names$covar_labels)
covar_names$covar_labels <- gsub('Kd ', 'turbidity ', covar_names$covar_labels)
covar_names$covar_labels <- gsub('Variability', 'variability', covar_names$covar_labels)
covar_names$covar_labels <- gsub('Median$', 'median', covar_names$covar_labels)
covar_names$covar_labels <- gsub('abund', 'density', covar_names$covar_labels)
covar_names$covar_labels <- gsub('^H ', 'Fish ', covar_names$covar_labels)
covar_names$covar_labels <- gsub('^Black.*', 'Coastal development', covar_names$covar_labels)
covar_names$covar_labels <- gsub('^SST.*', 'SST (90-day mean)', covar_names$covar_labels)

# Run (save) plots for each disease-region -----------------------------------
# easiest to manually adjust plot inset spacing in Inkscape/Illustrator

# GA GBR
gagbr <- var_imp_with_pdp_plot(
  mod = GA_GBR_Model
  , vars = ga_gbr_vars
  , smote_data = ga_gbr_data
  , plotTitle = 'Growth anomalies\nGreat Barrier Reef, Australia'
)

# ggsave(filename = 'figures/ga_gbr_covariates.pdf', width = 5, height = 7)

# GA Pacific
gapac <- var_imp_with_pdp_plot(
  mod = GA_Pacific_Model
  , vars = ga_pac_vars
  , smote_data = ga_pac_data
  , plotTitle = 'Growth anomalies\nU.S. Pacific'
)

# ggsave(filename = 'figures/ga_pacific_covariates.pdf', width = 5, height = 7)

# WS GBR
wsgbr <- var_imp_with_pdp_plot(
  mod = WS_GBR_Model
  , vars = ws_gbr_vars
  , smote_data = ws_gbr_data
  , plotTitle = 'White syndromes\nGreat Barrier Reef, Australia'
)

# ggsave(filename = 'figures/ws_gbr_covariates.pdf', width = 4, height = 6)

# WS Pacific
wspac <- var_imp_with_pdp_plot(
  mod = WS_Pacific_Model
  , vars = ws_pac_acr_vars
  , smote_data = ws_pac_acr_data
  , plotTitle = 'White syndromes\nU.S. Pacific'
)

# ggsave('figures/ws_pacific_covariates.pdf', width = 6, height = 10)


