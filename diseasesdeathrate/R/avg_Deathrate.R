#' Average Death Rate from Infectious and Parasitic Diseases for Specified Country
#'
#' @param country A character string specifying the name of the country. If NULL, calculates the average death rate for all countries.
#' @param data A data frame containing the death rate data, where \code{Entity} represents the country names.
#'
#' @return A numeric value representing the average death rate per 100,000 population for the specified country.
#'
#' @examples
#' avg_Deathrate("Japan")
#' @export
avg_Deathrate <- function(country = NULL, data = infectious_parasitic_diseases_death_rate) {
  # Filter data for the specified country if provided
  data_filtered <- data %>%
    dplyr::filter(is.null(country) | Entity == country)

  # Calculate and return the average death rate
  avg_rate <- mean(data_filtered$`death rate per 100,000 population`, na.rm = TRUE)

  return(avg_rate)
}







