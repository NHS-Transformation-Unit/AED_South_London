
# Rename columns for easier use

dep_proc <- deprivation_data |>
  rename("LA" = "Local Authority District name (2024)",
         "IMD Decile" = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOA") |>
  mutate('SL Side' = case_when(LA %in% c("Bexley",
                                         "Bromley",
                                         "Greenwich",
                                         "Lambeth",
                                         "Lewisham",
                                         "Southwark",
                                         "Croydon") ~ 'South East',
                               TRUE ~ 'South West'))

# Deprivation deciles of population

pop_dep_LA <- dep_proc |>
  group_by(LA,
           `IMD Decile`) |>
  summarise('Population' = sum(`Population`, na.rm = TRUE))

pop_dep_SL <- dep_proc |>
  group_by(`SL Side`,
           `IMD Decile`) |>
  summarise('Population' = sum(`Population`, na.rm = TRUE)) |>
  rename("LA" = "SL Side")

pop_dep_tot <- dep_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           `IMD Decile`) |>
  summarise('Population' = sum(`Population`, na.rm = TRUE)) |>
  rename("LA" = "Total")



# Totals ------------------------------------------------------------------

pop_LA_dep <- dep_proc |>
  group_by(LA) |>
  summarise('LAD_Population' = sum(`Population`, na.rm = TRUE))

pop_SL_dep <- dep_proc |>
  group_by(`SL Side`) |>
  summarise('LAD_Population' = sum(`Population`, na.rm = TRUE)) |>
  rename("LA" = "SL Side")

pop_tot_dep <- dep_proc |>
  mutate("Total" = "London") |>
  group_by(Total) |>
  summarise('LAD_Population' = sum(`Population`, na.rm = TRUE)) |>
  rename("LA" = "Total")



# Deprivation - Population percentages --------------------------------------------------

pop_dep_LA_per <- left_join(pop_dep_LA, pop_LA_dep, by = c('LA' = 'LA')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_dep_SL_per <- left_join(pop_dep_SL, pop_SL_dep, by = c('LA' = 'LA')) |>
  mutate("Percentage" = Population/LAD_Population)

pop_dep_tot_per <- left_join(pop_dep_tot, pop_tot_dep, by = c('LA' = 'LA')) |>
  mutate("Percentage" = Population/LAD_Population)


pop_dep_per <- rbind(pop_dep_LA_per,pop_dep_SL_per,pop_dep_tot_per) |>
  rename("Upper tier local authorities" = "LA")
