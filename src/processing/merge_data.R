
# Merge of age population data with referrals for comparison

unified_age_per <- left_join(pop_age_per, ref_new_per, by = c("Upper tier local authorities" = "LAD16NM", 
                                                                   "Age_band" = "Age_band")) |>
  rename("Pop_per" = "Percentage.x",
         "Ref_per" = "Percentage.y") |>
  select(`Upper tier local authorities`,
         `Age_band`,
         `Pop_per`,
         `Ref_per`,
         `Confidence`) |>
  filter(Age_band != "Under 12")


unified_age_LA_per <- unified_age_per |>
  filter(`Upper tier local authorities` != "London")

unified_age_LON_per <- unified_age_per |>
  filter(`Upper tier local authorities` == "London")


# Merge of ethnicity population data with referrals for comparison

unified_eth_per <- left_join(pop_eth_per, ref_new_eth_per, by = c("Upper tier local authorities" = "LAD16NM",
                                                                  "Ethnic group (8 categories)" = "Ethnic_group")) |>
  rename("Pop_per" = "Percentage.x",
         "Ref_per" = "Percentage.y") |>
  select(`Upper tier local authorities`,
         `Ethnic group (8 categories)`,
         `Pop_per`,
         `Ref_per`,
         `Confidence`)


unified_eth_LA_per <- unified_eth_per |>
  filter(`Upper tier local authorities` != "London")

unified_eth_LON_per <- unified_eth_per |>
  filter(`Upper tier local authorities` == "London")


# Merge of deprivation population data with referrals for comparison

unified_dep_per <- left_join(pop_dep_per, ref_new_dep_per, by = c("Upper tier local authorities" = "LAD16NM",
                                                                  "IMD Decile" = "IMD19dec")) |>
  rename("Pop_per" = "Percentage.x",
         "Ref_per" = "Percentage.y") |>
  select(`Upper tier local authorities`,
         `IMD Decile`,
         `Pop_per`,
         `Ref_per`,
         `Confidence`)


unified_dep_LA_per <- unified_dep_per |>
  filter(`Upper tier local authorities` != "London")

unified_dep_LON_per <- unified_dep_per |>
  filter(`Upper tier local authorities` == "London")
