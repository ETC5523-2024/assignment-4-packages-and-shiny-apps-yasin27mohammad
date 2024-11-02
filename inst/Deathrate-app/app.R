library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(tidyverse)
library(plotly)
library(DT)
library(diseasesdeathrate)

custom_css <- "
  .skin-blue .main-header .logo {
    background-color: #2a3f54;
    color: white;
  }
  .skin-blue .main-header .navbar {
    background-color: #2a3f54;
  }
  .skin-blue .main-sidebar {
    background-color: #1a2732;
  }
  .skin-blue .main-sidebar .sidebar-menu > li.active > a {
    background-color: #4b6584;
    color: white;
  }
  .content-wrapper, .right-side {
    background: linear-gradient(to bottom, #e6f7ff, #ffffff);
  }
  .box {
    background: #ffffff;
    border-top: solid 3px #3498db;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  .sidebar-menu > li > a {
    color: #bfc9ca;
  }
  .sidebar-menu > li > a:hover {
    background-color: #34495e;
    color: white;
  }
  h1, h2, h3, h4 {
    font-family: 'Arial', sans-serif;
    color: #2c3e50;
  }
  .description-box {
    background-color: #d1ecf1;
    padding: 15px;
    border-radius: 5px;
    margin: 15px 0;
    font-size: 16px;
  }
"

# Define UI for application
ui <- dashboardPage(
  dashboardHeader(title = "Infectious and Parasitic Diseases Death Rate Analysis"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard Home", tabName = "home", icon = icon("home")),
      menuItem("Country Analysis", tabName = "country_analysis", icon = icon("globe-asia"))
    )
  ),

  dashboardBody(
    tags$head(tags$style(HTML(custom_css))),

    tabItems(

      tabItem(tabName = "home",
              h1("Welcome to the Infectious and Parasitic Diseases Death Rate Analysis Dashboard",
                 style = "text-align: center; font-weight: bold"),
              h3("Explore Trends and Compare Data Across Asian Countries",
                 style = "text-align: center"),
              br(),
              p("This dashboard provides insights into the death rates from infectious and parasitic diseases
                 across selected Asian countries. You can view individual country trends or compare multiple
                 countries to understand how death rates have evolved over time. Use the tabs on the left to
                 navigate through the different analysis options.",
                style = "font-size: 18px; text-align: center;")
      ),

      tabItem(tabName = "country_analysis",
              h2("Infectious and Parasitic Diseases Death Rate Analysis by Country in Asia",
                 style = "text-align: center; font-weight: bold"),


              radioButtons("analysis_type", "Select Analysis Type:",
                           choices = c("Single Country Trend" = "single", "Country Comparison" = "compare"),
                           inline = TRUE),
              br(),

              # UI for Single Country Trend
              conditionalPanel(
                condition = "input.analysis_type == 'single'",
                fluidRow(
                  column(4,
                         selectInput("country", "Select a Country:",
                                     choices = unique(infectious_parasitic_diseases_death_rate$Entity),
                                     selected = "Sri Lanka")),
                  column(8,
                         sliderInput("year_range", "Select Year Range:",
                                     min = min(infectious_parasitic_diseases_death_rate$Year),
                                     max = max(infectious_parasitic_diseases_death_rate$Year),
                                     value = range(infectious_parasitic_diseases_death_rate$Year),
                                     sep = ""))
                ),
                div(class = "description-box",
                    strong("How to Interpret the Trend:"),
                    p("This trend shows the death rate due to infectious and parasitic diseases for the selected country over time.
                      Rising bars suggest an increase in disease-related deaths, while decreasing bars indicate improvements
                      in health measures or disease control. Consistent heights imply stability in the health outcomes over
                      the years.")
                ),
                plotlyOutput("country_trend_plot")
              ),

              # UI for Country Comparison
              conditionalPanel(
                condition = "input.analysis_type == 'compare'",
                fluidRow(
                  column(4,
                         selectInput("countries", "Select Countries to Compare:",
                                     choices = unique(infectious_parasitic_diseases_death_rate$Entity),
                                     selected = c("Japan", "Sri Lanka"), multiple = TRUE)),
                  column(8,
                         sliderInput("year_range_compare", "Select Year Range for Comparison:",
                                     min = min(infectious_parasitic_diseases_death_rate$Year),
                                     max = max(infectious_parasitic_diseases_death_rate$Year),
                                     value = range(infectious_parasitic_diseases_death_rate$Year),
                                     sep = ""))
                ),
                div(class = "description-box",
                    strong("How to Interpret the Comparison:"),
                    p("This plot compares the death rates of selected countries over the chosen year range.
                      Higher lines indicate higher death rates, suggesting more significant health challenges.
                      Parallel lines imply similar health outcomes, while diverging lines show varying responses
                      to health crises or improvements in public health measures.")
                ),
                plotlyOutput("country_comparison_plot"),
                br(),
                h4("Summary Statistics for Selected Countries in Asia:",
                   style = "font-weight: bold"),
                DTOutput("summary_table")
              )
      )
    )
  )
)

# Define server logic required to draw plots and generate summaries

server <- function(input, output) {

  # Plot for single country trend
  output$country_trend_plot <- renderPlotly({
    req(input$country)


    trend_data <- infectious_parasitic_diseases_death_rate |>
      filter(Entity == input$country,
             Year >= input$year_range[1], Year <= input$year_range[2])

    # Create a bar plot for the trend of death rate over time

    p <- ggplot(trend_data, aes(x = Year, y = `death rate per 100,000 population`)) +
      geom_col(fill = "#5DADE2") +
      scale_x_continuous(breaks = seq(min(trend_data$Year), max(trend_data$Year), by = 10)) +
      labs(title = paste("Death Rate Trend for", input$country),
           x = "Year",
           y = "Death Rate per 100,000 Population") +
      theme_minimal()

    ggplotly(p)
  })

  # Plot for multiple country comparison
  output$country_comparison_plot <- renderPlotly({
    req(input$countries)


    comparison_data <- infectious_parasitic_diseases_death_rate |>
      filter(Entity %in% input$countries,
             Year >= input$year_range_compare[1], Year <= input$year_range_compare[2])

    # Create a line plot for death rate comparison between countries
    p <- ggplot(comparison_data, aes(x = Year, y = `death rate per 100,000 population`, color = Entity)) +
      geom_line(size = 1.5) +
      scale_x_continuous(breaks = seq(min(comparison_data$Year), max(comparison_data$Year), by = 10)) +
      labs(title = "Death Rate Comparison Between Selected Countries",
           x = "Year",
           y = "Death Rate per 100,000 Population",
           color = "Country") +
      theme_minimal()

    ggplotly(p)
  })

  # Generate summary statistics table for selected countries
  output$summary_table <- renderDT({
    req(input$countries)


    summary_data <- infectious_parasitic_diseases_death_rate |>
      filter(Entity %in% input$countries,
             Year >= input$year_range_compare[1], Year <= input$year_range_compare[2]) |>
      group_by(Entity) |>
      summarise(
        Year_Range = paste(input$year_range_compare[1], "-", input$year_range_compare[2]),
        Mean_Death_Rate = round(mean(`death rate per 100,000 population`, na.rm = TRUE), 2),
        Min_Death_Rate = round(min(`death rate per 100,000 population`, na.rm = TRUE), 2),
        Min_Death_Rate_Year = Year[which.min(`death rate per 100,000 population`)],
        Max_Death_Rate = round(max(`death rate per 100,000 population`, na.rm = TRUE), 2),
        Max_Death_Rate_Year = Year[which.max(`death rate per 100,000 population`)]
      )

    datatable(summary_data, options = list(pageLength = 5))
  })
}


shinyApp(ui = ui, server = server)
