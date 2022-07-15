
###############################################################################
# Master code for University of Hawaii - NOAA Coral Reef Watch Fore-C project #
# Created by Jamie M. Caldwell. Contact: jamie.sziklay@gmail.com              #
# platform       x86_64-w64-mingw32                                           #
# arch           x86_64                                                       #
# os             mingw32                                                      #
# system         x86_64, mingw32                                              #
# year           2021                                                         #
# svn rev        80317                                                        #
# language       R                                                            #
# version.string R version 4.1.0 (2021-05-18)                                 #
# nickname       Camp Pontanezen                                              #
###############################################################################

# Load libraries
source('./codes/Install_packages.R')

# Unzip data and model files
unzip('data.zip')
unzip('models.zip')

# Create SMOTE datasets
source('./codes/Surveys_create_smote_datasets.R')

# Model selection
source('./codes/Model_selection_with_quantile_forests.R')

# Summarize results of model selection
source('./codes/Model_selection_summarize_results.R')

# Re-run final models and save model objects
source('./codes/Models_save_best.R')

# Model validation
source('./codes/Validation_for_paper_figures.R')

# Figures
source('./codes/Paper_figure_variable_importance_pdp.R')
source('./codes/Paper_figure_nowcast_validation.R')
source('./codes/Paper_figure_forecasts_precision_accuracy.R')
