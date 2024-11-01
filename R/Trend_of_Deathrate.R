#' Plot Death Rate Trend for a Country
#'
#'This function generates a line plot showing the trend of death rates from infectious and parasitic diseases for a
#' specified country over time. The plot displays years on the x-axis and death rate per 100,000 population on the y-axis,
#' allowing users to visualize changes in death rates over the years.
#'
#' @param data A data frame containing death rate information, with columns for "Entity" (country name),
#'            "Code" (country code), "Year", and "death rate per 100,000 population".
#' @param country A character string specifying the country for which to plot the death rate trend.
#'
#' @return A ggplot2 line plot showing the death rate trend for the specified country over time.
#' @export
#'
#' @examples
#' plot_death_rate_trend(infectious_parasitic_diseases_death_rate, "Sri Lanka")
#'
plot_death_rate_trend <- function(data, country) {

  country_data <- dplyr::filter(data, Entity == country)


  p <- ggplot2::ggplot(country_data, ggplot2::aes(x = Year, y = `death rate per 100,000 population`)) +
    ggplot2::geom_line(color = "#1f77b4", size = 1.2) +
    ggplot2::labs(title = paste("Death Rate Trend for", country),
                  x = "Year",
                  y = "Death Rate per 100,000 Population") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.background = ggplot2::element_rect(fill = "#f0f8ff", color = NA),
      plot.background = ggplot2::element_rect(fill = "#f0f8ff", color = NA),
      axis.text = ggplot2::element_text(size = 10),
      axis.title = ggplot2::element_text(size = 12, face = "bold"),
      plot.title = ggplot2::element_text(size = 14, face = "bold", hjust = 0.5)
    )
  print(p)
}
