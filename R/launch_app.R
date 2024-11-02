#' @export
launch_app <- function() {
  app_dir <- system.file("Deathrate-app", package = "diseasesdeathrate")
  shiny::runApp(app_dir, display.mode = "normal")
}
