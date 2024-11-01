
library(dplyr)
library(ggplot2)

plot_death_rate_trend <- function(data, country) {

  country_data <- data %>%
    filter(Entity == country)


  p <- ggplot(country_data, aes(x = Year, y = `death rate per 100,000 population`)) +
    geom_line(color = "#1f77b4", size = 1.2) +
    labs(title = paste("Death Rate Trend for", country),
         x = "Year",
         y = "Death Rate per 100,000 Population") +
    theme_minimal() +
    theme(
      panel.background = element_rect(fill = "#f0f8ff", color = NA),
      plot.background = element_rect(fill = "#f0f8ff", color = NA),
      axis.text = element_text(size = 10),
      axis.title = element_text(size = 12, face = "bold"),
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5)
    )


  print(p)
}
