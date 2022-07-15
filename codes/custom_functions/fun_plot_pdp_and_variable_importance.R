library(tidyverse)
library(edarf) # devtools::install_github("zmjones/edarf", subdir = "pkg")
library(ggplot2)
library(patchwork)

# plotting function
var_imp_with_pdp_plot <- function(mod, vars, smote_data, plotTitle){
  
  # format data
  x <- as.data.frame(mod$importance)
  x$covars <- rownames(x)
  x <- x %>% left_join(covar_names)
  x$VarImp <- x$`%IncMSE`
  
  # create covariate levels in descending order based on variable importance
  newLevels <- x$covars[order(-x$VarImp)]  
  
  # create variable importance plot
  var_imp_plt <- ggplot(x, aes(x = reorder(covar_labels, VarImp), y = VarImp)) + 
    geom_point(size = 3) +
    ggtitle(plotTitle) +
    ylab('Variable importance (% increase MSE)') +
    xlab('') +
    # ylim(20, 70) +
    scale_x_discrete(expand = expansion(mult = c(.05, .2))) + # add space to top of plot within border
    coord_flip() +
    theme_bw() +
    theme(
      panel.grid.major.x = element_blank()
      , panel.grid.minor.x = element_blank()
      , axis.text.y = element_blank()
      , axis.ticks.y = element_blank()
    )
  
  # create partial dependence data and plots
  pd_df <- partial_dependence(fit = mod,
                              vars = vars,
                              data = smote_data,
                              n = c(100, 200))
  
  # format reshape data
  colsToKeep <- colnames(pd_df)[!grepl('quantile', colnames(pd_df))]
  pd_df2 <- pd_df[, colsToKeep]
  
  pd_df2 <- pd_df2 %>%
    gather(key = covars, value = value, -prediction) %>%
    drop_na() %>% 
    left_join(covar_names)
  
  # set covariate levels determined above
  pd_df2$covars <- factor(pd_df2$covars, levels = newLevels)
  
  # create minimal PDP plots
  pd_plts <- ggplot(pd_df2, aes(x = value, y = prediction)) + 
    geom_line() +
    theme_void() +
    theme(
      panel.border = element_rect(colour = 'black', fill = NA)
      , strip.text.x = element_text(angle = 0, hjust = 0)
    ) + 
    facet_wrap(~covar_labels, scales = 'free', ncol = 1) 
  
  # inset pdp plots within variable importance plot
  var_imp_plt + inset_element(p = pd_plts, left = 0.015, bottom = 0.05, right = 0.35, top = 0.95)
  
}
