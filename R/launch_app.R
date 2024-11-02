#' Launch the Death Rate Analysis App
#'
#' @description
#' This function launches the Shiny app for analyzing death rates from infectious and parasitic diseases.
#' The app provides insights into trends and comparisons across Asian countries.
#'
#' @export
launch_app <- function() {
  app_dir <- system.file("Deathrate-app", package = "diseasesdeathrate")
  shiny::runApp(app_dir, display.mode = "normal")
}
