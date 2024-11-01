# Load necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)

# Define the UI
ui <- fluidPage(
  titlePanel("Death Rate Analysis from Infectious and Parasitic Diseases (Asian Countries)"),

  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select a Country:",
                  choices = unique(infectious_parasitic_diseases_death_rate$Entity),
                  selected = "Sri Lanka"),

      selectInput("compare_countries", "Select Countries to Compare:",
                  choices = unique(infectious_parasitic_diseases_death_rate$Entity),
                  multiple = TRUE,
                  selected = c("Sri Lanka", "Japan")),

      p("Select a country to see the death rate trend over time, or choose multiple countries for comparison.")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Country Trend", plotOutput("countryTrend")),
        tabPanel("Country Comparison", plotOutput("countryComparison"))
      )
    )
  )
)

# Define the server
server <- function(input, output) {

  # Country Trend Plot (Bar Graph)
  output$countryTrend <- renderPlot({
    req(input$country)
    country_data <- infectious_parasitic_diseases_death_rate %>%
      filter(Entity == input$country)

    ggplot(country_data, aes(x = Year, y = `death rate per 100,000 population`)) +
      geom_col(fill = "skyblue") +
      labs(title = paste("Death Rate Trend for", input$country),
           x = "Year",
           y = "Death Rate per 100,000 Population") +
      theme_minimal()
  })

  # Country Comparison Plot (Line Graph)
  output$countryComparison <- renderPlot({
    req(input$compare_countries)
    comparison_data <- infectious_parasitic_diseases_death_rate %>%
      filter(Entity %in% input$compare_countries)

    ggplot(comparison_data, aes(x = Year, y = `death rate per 100,000 population`, color = Entity)) +
      geom_line(size = 1) +
      labs(title = "Death Rate Comparison",
           x = "Year",
           y = "Death Rate per 100,000 Population") +
      theme_minimal() +
      scale_color_brewer(palette = "Set1")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
