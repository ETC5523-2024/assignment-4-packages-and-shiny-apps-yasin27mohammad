
<!-- README.md is generated from README.Rmd. Please edit that file -->

## diseasesdeathrate

<!-- badges: start -->
<!-- badges: end -->

The `diseasesdeathrate` package provides access to age-standardized
death rate data for infectious and parasitic diseases across multiple
Asian countries. Sourced from the `World Health Organization` (WHO),
this package enables users to analyze and visualize health trends
related to infectious diseases, providing insights into public health
challenges and policy implications within Asia. It is designed for
analysts, researchers, and policymakers interested in examining disease
impacts over time and across different countries in the region.
[Website](https://etc5523-2024.github.io/assignment-4-packages-and-shiny-apps-yasin27mohammad/)

## Installation

You can install the development version of diseasesdeathrate from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("ETC5523-2024/assignment-4-packages-and-shiny-apps-yasin27mohammad")
```

## Example

This basic example demonstrates how to calculate and visualize the
average death rate from infectious and parasitic diseases for each Asian
country in the dataset.

``` r
library(diseasesdeathrate)
library(ggplot2)
library(dplyr)


avg_death_rate <- infectious_parasitic_diseases_death_rate |>
  group_by(Entity) |>
  summarize(avg_death_rate = mean(`death rate per 100,000 population`, na.rm = TRUE))


ggplot(avg_death_rate, aes(x = reorder(Entity, -avg_death_rate), y = avg_death_rate, fill = avg_death_rate)) +
  geom_col() +
  scale_fill_gradient(low = "skyblue", high = "darkblue") +
  labs(
    title = "Average Death Rate from Infectious and Parasitic Diseases by Country (Asia)",
    x = "Country",
    y = "Average Death Rate per 100,000 Population"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, size = 8),
    plot.title = element_text(size = 10, face = "bold"),
    axis.title = element_text(size = 9.5),
    legend.position = "right"
  ) +
  guides(fill = guide_colorbar(title = "Avg Death Rate"))
```

<img src="man/figures/README-example-1.png" width="100%" />

## Overview of Key Functions in `diseasesdeathrate` package

The `diseasesdeathrate` package includes two essential functions that
allow users to explore infectious and parasitic disease data across
Asian countries:

- `avg_Deathrate()`: This function calculates the average death rate for
  infectious and parasitic diseases in a specified Asian country. By
  filtering the data for the selected country, it computes a single
  average value that reflects the overall impact of these diseases over
  time. This is useful for gaining a quick understanding of a country’s
  long-term disease burden.

- `plot_death_rate_trend()`: This function generates a line plot that
  shows how death rates from infectious and parasitic diseases have
  changed over time for a particular Asian country. The trend line
  offers a clear visual of increases, decreases, or stability in death
  rates, helping users identify patterns and assess the effects of
  public health measures.
