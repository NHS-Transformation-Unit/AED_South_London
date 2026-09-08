
deprivation_data <- read_csv(here("data",
                                 "reference_data",
                                 "Deprivation.csv")) |>
  filter(`Local Authority District code (2024)` %in% c('E09000004', # Bexley
                          'E09000006', # Bromley
                          'E09000008', # Croydon
                          'E09000011', # Greenwich
                          'E09000021', # Kingston upon Thames
                          'E09000022', # Lambeth
                          'E09000023', # Lewisham
                          'E09000024', # Merton
                          'E09000027', # Richmond
                          'E09000028', # Southwark
                          'E09000029', # Sutton
                          'E09000032')) # Wandsworth
