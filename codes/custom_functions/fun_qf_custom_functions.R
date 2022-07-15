# load libraries
library(data.table)
library(quantregForest)

# function to run variable selection ----------------------
var_selection <- function(x_train, y_train, x_test, y_test){
  qtrain <- quantregForest(x_train, y_train, importance = TRUE)
  
  quant <- predict(qtrain,
                   what = c(0.05, 0.75, 0.95),
                   newdata = x_test)
  
  list((sort(qtrain$importance[,1])), (summary(lm(quant[,2] ~ y_test))))
}

# function to update variables in selection process -------
updated_vars <- function(x, namesToKeep){
  x2 <- x[!grepl(namesToKeep, names(x))] 
  namesToAdd <- unlist(strsplit(namesToKeep, split='\\|'))
  c(namesToAdd, names(x2[2:length(x2)])) # remove variable of lowest importance
}

# model selection function --------------------------------
mod_select <- function(x_train, y_train, x_test, y_test, dz_vars, DFfileName){
  create_data_frame(DFfileName, c("AdjR2", "Num_vars", "Model_variables"))
  
  while(length(dz_vars) > 2){
    x <- var_selection(x_train, 
                       y_train, 
                       x_test, 
                       y_test)

    tmp_df <- data.frame(x[[2]]$adj.r.squared, length(dz_vars), toString(names(x[[1]])))
    
    write.table(tmp_df, 
                file = DFfileName, 
                row.names = F, 
                sep = ",", 
                col.names = !file.exists(DFfileName), 
                append = T)
    
    dz_vars <- updated_vars(x[[1]], 'Month')
    
    # update data
    x_train <- x_train[, dz_vars]
    x_test <- x_test[, dz_vars]
    
    # print progress
    cat('finished', dz_name, 'with', length(dz_vars), 'vars\n')
  }
}