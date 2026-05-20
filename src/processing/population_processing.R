
# Add age bands to referrals

pop_proc <- population_data |>
  mutate('Age_band' = case_when(`Age (86 categories) Code` < 12 ~ 'Under 12',
                                `Age (86 categories) Code` < 19 ~ '12 to 18',
                                `Age (86 categories) Code` < 26 ~ '19 to 25',
                                `Age (86 categories) Code` < 36 ~ '26 to 35',
                                `Age (86 categories) Code` < 46 ~ '36 to 45',
                                `Age (86 categories) Code` < 56 ~ '46 to 55',
                                `Age (86 categories) Code` < 66 ~ '56 to 65',
                                `Age (86 categories) Code` < 76 ~ '66 to 75',
                                `Age (86 categories) Code` < 86 ~ '76 to 85',
                                `Age (86 categories) Code` > 85 ~ 'Over 85',
                                TRUE ~ 'NA'))


# Age banding of population

pop_age_LA <- pop_proc |>
  group_by(`Upper tier local authorities`,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))

pop_LA <- pop_proc |>
  group_by(`Upper tier local authorities`) |>
  summarise('LAD_Population' = sum(`Observation`, na.rm = TRUE))

pop_LA_per <- left_join(pop_age_LA, pop_LA, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)


pop_age_tot <- pop_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")

pop_tot <- pop_proc |>
  mutate("Total" = "London") |>
  group_by(Total) |>
  summarise('London_Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")

pop_tot_per <- left_join(pop_age_tot, pop_tot, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/London_Population)


pop_age <- rbind(pop_age_LA,pop_age_tot)


# Ethnicity banding of population

pop_eth <- pop_proc |>
  group_by(`Upper tier local authorities`,
           `Ethnic group (8 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))

