# Function to split data into training and testing datasets 
library(caTools)

split_train_test_dfs <- function(df, yVar){
  # split sample
  sample = sample.split(unlist(df[, yVar]), SplitRatio = .75)
  train = subset(df, sample == TRUE)
  test  = subset(df, sample == FALSE)
  # output
  list(train, test)
}
