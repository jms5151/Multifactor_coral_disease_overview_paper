# load libraries
library(ggplot2)
library(cowplot)
library(wesanderson)

# load data
forec_forecasts_agg <- read.csv('data/validation_data/v3_forecasts_aggregated.csv')

# format group name labels 
forec_forecasts_agg$groupLabels <- paste(forec_forecasts_agg$Disease, forec_forecasts_agg$Region, sep = ', ')
forec_forecasts_agg$groupLabels <- gsub('GBR', 'Great Barrier Reef', forec_forecasts_agg$groupLabels)
forec_forecasts_agg$groupLabels <- gsub('Pacific', 'U.S. Pacific', forec_forecasts_agg$groupLabels)

# Accuracy plots 
accuracy_plot <- ggplot(forec_forecasts_agg, aes(x = Lead_time, y = Prediction_accuracy, group = Lead_time, fill = groupLabels)) +
  geom_boxplot() +
  scale_fill_manual(values = wes_palette('Zissou1', n = 4)) +
  facet_wrap(~groupLabels, scales = 'free', ncol = 1) + 
  # set unique ylimits by facet, with equal below and above one
  scale_y_continuous(limits = function(x){c(-max(x, 1), max(x, 1))}) +
  theme_bw() +
  theme(
    legend.position = 'none'
    , panel.spacing = unit(2, "lines")
    , strip.text.x = element_blank()
  ) +
  ggtitle('') + #Accuracy
  xlab('') +
  ylab('Prediction accuracy\n(75th percentile prediction - observed)\n') +
  scale_x_reverse(labels = as.character(forec_forecasts_agg$Lead_time), breaks = forec_forecasts_agg$Lead_time) +
  geom_hline(yintercept = 0, linetype = 'dashed')

# Precision plots 
precision_plot <- ggplot(forec_forecasts_agg, aes(x = Lead_time, y = Prediction_precision, group = Lead_time, fill = groupLabels)) +
  geom_boxplot() +
  facet_wrap(~groupLabels, scales = 'free', ncol = 1) + 
  scale_fill_manual(values = wes_palette('Zissou1', n = 4)) +
  # set unique ylimits and position axis on right side of plot
  scale_y_continuous(position = 'right', limits = function(x){c(0, max(x, 1))}) +
  theme_bw() +
  theme(
    legend.position = 'none'
    , panel.spacing = unit(2, "lines")
    , strip.text.x = element_blank()
  ) +
  ggtitle('') + #Precision
  xlab('') +
  ylab('Prediction precision\n(90th - 50th percentile predictions)\n') +
  scale_x_reverse(labels = as.character(forec_forecasts_agg$Lead_time), breaks = forec_forecasts_agg$Lead_time) +
  geom_hline(yintercept = 0, linetype = 'dashed')

# combine and annotate plots
ap_plot <- plot_grid(accuracy_plot, precision_plot, ncol = 2)

# set margins and add text
ap_plot_final <- ap_plot + 
  annotate("text", x = 0.28, y = 1.03, size = 6, label = 'Accuracy') +
  annotate("text", x = 0.72, y = 1.03, size = 6, label = 'Precision') +
  annotate("text", x = 0.5, y = 0.98, size = 5, label = 'Growth anomalies, Great Barrier Reef') +
  annotate("text", x = 0.5, y = 0.74, size = 5, label = 'Growth anomalies, U.S. Pacific') +
  annotate("text", x = 0.5, y = 0.49, size = 5, label = 'White syndromes, Great Barrier Reef') +
  annotate("text", x = 0.5, y = 0.25, size = 5, label = 'White syndromes, U.S. Pacific') +
  annotate("text", x = 0.5, y = 0, size = 4, label = 'Lead time') +
  theme(plot.margin = unit(c(1, 0.1, 1, 0.1), "cm")) 

# save plot
ggsave(filename = 'figures/v3_lead_time_forecasts.pdf', height = 8, width = 8.5, plot = ap_plot_final)


