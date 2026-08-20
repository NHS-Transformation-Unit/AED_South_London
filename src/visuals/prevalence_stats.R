
# Table of prevalence

prev_pop <- data.frame(pop_tot_per$Age_band,
                       pop_tot_per$Population,
                       Estimate_Prevalence = c(0.043/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.081/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                               0.013/0.448),      # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                       BEAT_Prevalence = c(0.043/0.488,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                           0.081/0.488,       # research prevalence / proportion of existing diagnoses as Anorexia, atypical anorexia or bulimia
                                           0.026,       # BEAT prevalence
                                           0.026,       # BEAT prevalence
                                           0.026,       # BEAT prevalence
                                           0.026,       # BEAT prevalence
                                           0.026,       # BEAT prevalence
                                           0.026,       # BEAT prevalence
                                           0.026)) |>   # BEAT prevalence
  
  filter(pop_tot_per.Age_band != "Under 12") |>
  mutate(Estimate_Population = pop_tot_per.Population * Estimate_Prevalence,
         T3_referral = Estimate_Population * 0.2,
         BEAT_Population = pop_tot_per.Population * BEAT_Prevalence,
         BEAT_T3_referral = BEAT_Population * 0.2) |>
  rename("Age_band" = pop_tot_per.Age_band,
         "Population" = pop_tot_per.Population)

prev_tbl <- left_join(prev_pop, ref_new_age_tot, by = c("Age_band" = "Age_band")) |>
  mutate(Estimate_Population = round(Estimate_Population),
         T3_referral = round(T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         Estimate_Prevalence,
         Estimate_Population,
         T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "Estimate_Prevalence",
         "Estimate Population" = "Estimate_Population",
         "Requiring T3 Service Referrals (12 months)" = "T3_referral",
         "36 months of Referrals" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `36 months of Referrals`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "Estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


prev_tbl_y1 <- left_join(prev_pop, ref_new_age_tot_yr1, by = c("Age_band" = "Age_band")) |>
  mutate(Estimate_Population = round(Estimate_Population),
         T3_referral = round(T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         Estimate_Prevalence,
         Estimate_Population,
         T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "Estimate_Prevalence",
         "Estimate Population" = "Estimate_Population",
         "Requiring T3 Service Referrals (12 months)" = "T3_referral",
         "Referrals (year 1)" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `Referrals (year 1)`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "Estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


prev_tbl_y2 <- left_join(prev_pop, ref_new_age_tot_yr2, by = c("Age_band" = "Age_band")) |>
  mutate(Estimate_Population = round(Estimate_Population),
         T3_referral = round(T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         Estimate_Prevalence,
         Estimate_Population,
         T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "Estimate_Prevalence",
         "Estimate Population" = "Estimate_Population",
         "Requiring T3 Service Referrals (12 months)" = "T3_referral",
         "Referrals (year 2)" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `Referrals (year 2)`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "Estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


prev_tbl_y3 <- left_join(prev_pop, ref_new_age_tot_yr3, by = c("Age_band" = "Age_band")) |>
  mutate(Estimate_Population = round(Estimate_Population),
         T3_referral = round(T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         Estimate_Prevalence,
         Estimate_Population,
         T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "Estimate_Prevalence",
         "Estimate Population" = "Estimate_Population",
         "Requiring T3 Service Referrals (12 months)" = "T3_referral",
         "Referrals (year 3)" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `Referrals (year 3)`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "Estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# BEAT Prevalence

prev_beat_tbl <- left_join(prev_pop, ref_new_age_tot, by = c("Age_band" = "Age_band")) |>
  mutate(BEAT_Population = round(BEAT_Population),
         BEAT_T3_referral = round(BEAT_T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         BEAT_Prevalence,
         BEAT_Population,
         BEAT_T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "BEAT_Prevalence",
         "Estimate Population" = "BEAT_Population",
         "Requiring T3 Service Referrals (12 months)" = "BEAT_T3_referral",
         "36 months of Referrals" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `36 months of Referrals`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "BEAT report estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


prev_beat_tbl_y1 <- left_join(prev_pop, ref_new_age_tot_yr1, by = c("Age_band" = "Age_band")) |>
  mutate(BEAT_Population = round(BEAT_Population),
         BEAT_T3_referral = round(BEAT_T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         BEAT_Prevalence,
         BEAT_Population,
         BEAT_T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "BEAT_Prevalence",
         "Estimate Population" = "BEAT_Population",
         "Requiring T3 Service Referrals (12 months)" = "BEAT_T3_referral",
         "Referrals (year 1)" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `Referrals (year 1)`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "BEAT report estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


prev_beat_tbl_y2 <- left_join(prev_pop, ref_new_age_tot_yr2, by = c("Age_band" = "Age_band")) |>
  mutate(BEAT_Population = round(BEAT_Population),
         BEAT_T3_referral = round(BEAT_T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         BEAT_Prevalence,
         BEAT_Population,
         BEAT_T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "BEAT_Prevalence",
         "Estimate Population" = "BEAT_Population",
         "Requiring T3 Service Referrals (12 months)" = "BEAT_T3_referral",
         "Referrals (year 2)" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `Referrals (year 2)`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "BEAT report estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


prev_beat_tbl_y3 <- left_join(prev_pop, ref_new_age_tot_yr3, by = c("Age_band" = "Age_band")) |>
  mutate(BEAT_Population = round(BEAT_Population),
         BEAT_T3_referral = round(BEAT_T3_referral),
         Referrals = if_else(Referrals < 5,
                             NA_real_,
                             round(Referrals / 5) * 5)) |>
  select(Age_band,
         Population,
         BEAT_Prevalence,
         BEAT_Population,
         BEAT_T3_referral,
         Referrals) |>
  rename("Age band" = "Age_band",
         "Estimate Prevalence" = "BEAT_Prevalence",
         "Estimate Population" = "BEAT_Population",
         "Requiring T3 Service Referrals (12 months)" = "BEAT_T3_referral",
         "Referrals (year 3)" = "Referrals") |>
  gt() |>
  fmt_number(columns = c(`Population`, `Estimate Population`, `Requiring T3 Service Referrals (12 months)`, `Referrals (year 3)`),
             decimals = 0,
             use_seps = TRUE) |>
  fmt_percent(columns = c(`Estimate Prevalence`),
              decimals = 1) |>
  tab_header(title = "BEAT report estimated referral prevalence compared to received referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))
