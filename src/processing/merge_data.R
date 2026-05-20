
# Merge of population data with referrals for comparison

unified_age <- left_join(pop_age, ref_new_age, by = c("Upper tier local authorities" = "LAD16NM", "Age_band" = "Age_band"))

unified_age_LA_per <- left_join(pop_LA_per, ref_new_LA_per, by = c("Upper tier local authorities" = "LAD16NM", 
                                                                "Age_band" = "Age_band")) |>
  rename("Pop_per" = "Percentage.x",
         "Ref_per" = "Percentage.y")

unified_age_per <- left_join(pop_age_per, ref_new_per, by = c("Upper tier local authorities" = "LAD16NM", 
                                                                   "Age_band" = "Age_band")) |>
  rename("Pop_per" = "Percentage.x",
         "Ref_per" = "Percentage.y") |>
  select(`Upper tier local authorities`,
         `Age_band`,
         `Pop_per`,
         `Ref_per`,
         `Confidence`) |>
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
                                               "Wandsworth"),
         Age_band != "Under 12")


unified_age_LON_per <- left_join(pop_age_per, ref_new_per, by = c("Upper tier local authorities" = "LAD16NM", 
                                                              "Age_band" = "Age_band")) |>
  rename("Pop_per" = "Percentage.x",
         "Ref_per" = "Percentage.y") |>
  select(`Upper tier local authorities`,
         `Age_band`,
         `Pop_per`,
         `Ref_per`,
         `Confidence`) |>
  filter(`Upper tier local authorities` == "London",
         Age_band != "Under 12")

