
# Add age bands to referrals

pop_proc <- population_data |>
  mutate('Age_band' = case_when(`Age (86 categories) Code` < 12 ~ 'Under 12',
                                between(`Age (86 categories) Code`,12,18) ~ '12 to 18',
                                between(`Age (86 categories) Code`,19,25) ~ '19 to 25',
                                between(`Age (86 categories) Code`,26,35) ~ '26 to 35',
                                between(`Age (86 categories) Code`,36,45) ~ '36 to 45',
                                between(`Age (86 categories) Code`,46,55) ~ '46 to 55',
                                between(`Age (86 categories) Code`,56,65) ~ '56 to 65',
                                between(`Age (86 categories) Code`,66,75) ~ '66 to 75',
                                between(`Age (86 categories) Code`,76,85) ~ '76 to 85',
                                `Age (86 categories) Code` > 85 ~ 'Over 85',
                                TRUE ~ 'NA'))


# Age banding of population

pop_age_LA <- pop_proc |>
  group_by(`Upper tier local authorities`,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))


pop_age_tot <- pop_proc |>
  mutate("Total" = "Total") |>
  group_by(Total,
           Age_band) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE)) |>
  rename("Upper tier local authorities" = "Total")


pop_age <- rbind(pop_age_LA,pop_age_tot)


# Ethnicity banding of population

pop_eth <- pop_proc |>
  group_by(`Upper tier local authorities`,
           `Ethnic group (8 categories)`) |>
  summarise('Population' = sum(`Observation`, na.rm = TRUE))

