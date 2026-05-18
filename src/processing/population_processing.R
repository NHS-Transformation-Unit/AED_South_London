
# Age banding of population

pop_age <- population_data |>
  group_by(`Upper tier local authorities`,
           `Age (9 categories)`) |>
  summarise('population' = sum(`Observation`, na.rm = TRUE))


# Ethnicity banding of population

pop_eth <- population_data |>
  group_by(`Upper tier local authorities`,
           `Ethnic group (8 categories)`) |>
  summarise('population' = sum(`Observation`, na.rm = TRUE))

