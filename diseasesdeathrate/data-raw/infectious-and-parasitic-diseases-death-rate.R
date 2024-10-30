## code to prepare `infectious-and-parasitic-diseases-death-rate` dataset goes here

library(readr)
library(dplyr)

infectious_parasitic_diseases_death_rate<- read_csv("data-raw/infectious-and-parasitic-diseases-death-rate-who-mdb.csv")|>

          rename(`death rate per 100,000 population`
                  =`Age-standardized deaths that are from infectious and parasitic diseases per 100,000 people, in both sexes aged all ages`)|>

          filter(Entity %in% c("Armenia", "Azerbaijan", "Bahrain", "Cyprus",
                       "Georgia", "Iraq", "Israel", "Japan", "Jordan",
                       "Kazakhstan", "Kuwait", "Kyrgyzstan", "Lebanon",
                       "Malaysia", "Maldives", "Mongolia", "Oman",
                       "Philippines", "Qatar", "Singapore", "Sri Lanka",
                       "Tajikistan", "Thailand", "Turkey", "Turkmenistan",
                       "United Arab Emirates", "Uzbekistan"))

usethis::use_data(infectious_parasitic_diseases_death_rate, overwrite = TRUE)

