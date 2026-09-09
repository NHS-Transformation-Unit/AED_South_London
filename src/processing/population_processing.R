
# Add age bands to population

pop_proc <- population_data |>
  mutate('Age_band' = case_when(`Age (86 categories) Code` < 12 ~ 'Under 12',
                                `Age (86 categories) Code` < 18 ~ '12 to 17',
                                `Age (86 categories) Code` < 26 ~ '18 to 25',
                                `Age (86 categories) Code` < 36 ~ '26 to 35',
                                `Age (86 categories) Code` < 46 ~ '36 to 45',
                                `Age (86 categories) Code` < 56 ~ '46 to 55',
                                `Age (86 categories) Code` < 66 ~ '56 to 65',
                                `Age (86 categories) Code` < 76 ~ '66 to 75',
                                `Age (86 categories) Code` < 86 ~ '76 to 85',
                                `Age (86 categories) Code` > 85 ~ 'Over 85',
                                TRUE ~ 'NA')) |>
  filter(`Upper tier local authorities` %in% c("Bexley",
                                               "Bromley",
                                               "Greenwich",
                                               "Lambeth",
                                               "Lewisham",
                                               "Southwark",
                                               "Croydon",
                                               "Kingston upon Thames",
                                               "Merton",
                                               "Richmond upon Thames",
                                               "Sutton",
                                               "Wandsworth")) |>
  mutate('SL Side' = case_when(`Upper tier local authorities` %in% c("Bexley",
                                                                     "Bromley",
                                                                     "Greenwich",
                                                                     "Lambeth",
                                                                     "Lewisham",
                                                                     "Southwark",
                                                                     "Croydon") ~ 'South East',
                               TRUE ~ 'South West'))


# Age banding of population

pop_age_LA <- pop_proc |>
  group_by(`Upper tier local authorities`,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))

pop_age_SL <- pop_proc |>
  group_by(`SL Side`,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "SL Side")

pop_age_tot <- pop_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")


# Ethnicity banding of population

pop_eth_LA <- pop_proc |>
  group_by(`Upper tier local authorities`,
           `Ethnic group (8 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))

pop_eth_SL <- pop_proc |>
  group_by(`SL Side`,
           `Ethnic group (8 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "SL Side")

pop_eth_tot <- pop_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           `Ethnic group (8 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")


# Gender of population

pop_gen_LA <- pop_proc |>
  group_by(`Upper tier local authorities`,
           `Sex (2 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))

pop_gen_SL <- pop_proc |>
  group_by(`SL Side`,
           `Sex (2 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "SL Side")

pop_gen_tot <- pop_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           `Sex (2 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")



# Totals ------------------------------------------------------------------

pop_LA <- pop_proc |>
  group_by(`Upper tier local authorities`) |>
  summarise('LAD_Population' = sum(`Observation`, na.rm = TRUE))

pop_SL <- pop_proc |>
  group_by(`SL Side`) |>
  summarise('LAD_Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "SL Side")

pop_tot <- pop_proc |>
  mutate("Total" = "London") |>
  group_by(Total) |>
  summarise('LAD_Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")



# Age - Population percentages --------------------------------------------------

pop_LA_per <- left_join(pop_age_LA, pop_LA, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_SL_per <- left_join(pop_age_SL, pop_SL, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_tot_per <- left_join(pop_age_tot, pop_tot, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)


pop_age_per <- rbind(pop_LA_per,pop_SL_per,pop_tot_per)



# Ethnicity - Population percentages --------------------------------------

pop_eth_LA_per <- left_join(pop_eth_LA, pop_LA, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_eth_SL_per <- left_join(pop_eth_SL, pop_SL, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_eth_tot_per <- left_join(pop_eth_tot, pop_tot, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)


pop_eth_per <- rbind(pop_eth_LA_per,pop_eth_SL_per,pop_eth_tot_per)



# Gender - Population percentages --------------------------------------

pop_gen_LA_per <- left_join(pop_gen_LA, pop_LA, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_gen_SL_per <- left_join(pop_gen_SL, pop_SL, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_gen_tot_per <- left_join(pop_gen_tot, pop_tot, by = c('Upper tier local authorities' = 'Upper tier local authorities')) |>
  mutate("Percentage" = Population/LAD_Population)


pop_gen_per <- rbind(pop_gen_LA_per,pop_gen_SL_per,pop_gen_tot_per)

