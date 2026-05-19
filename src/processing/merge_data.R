
# Merge of population data with referrals for comparison

unified_age <- left_join(pop_age, ref_new_age, by = c("Upper tier local authorities" = "LAD16NM", "Age_band" = "Age_band"))

