
# All referrals -----------------------------------------------------------

# Table of Year 1 conditions

ref_cond_tbl1 <- condition_summary |>
  filter(DataYear == "Y1")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Condition_flag = if_else(Condition_flag < 5,
                                  NA_real_,
                                  round(Condition_flag / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Indicators" = "Condition_flag",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions present in new referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Table of Year 2 conditions

ref_cond_tbl2 <- condition_summary |>
  filter(DataYear == "Y2")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Condition_flag = if_else(Condition_flag < 5,
                                  NA_real_,
                                  round(Condition_flag / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Indicators" = "Condition_flag",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions present in new referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Table of Year 3 conditions

ref_cond_tbl3 <- condition_summary |>
  filter(DataYear == "Y3")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Condition_flag = if_else(Condition_flag < 5,
                                  NA_real_,
                                  round(Condition_flag / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Indicators" = "Condition_flag",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions present in new referrals") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Pre referral ------------------------------------------------------------

# Table of Year 1 conditions

ref_cond_tbl1_pre <- condition_summary_pre |>
  filter(DataYear == "Y1")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions identified before referral") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Table of Year 2 conditions

ref_cond_tbl2_pre <- condition_summary_pre |>
  filter(DataYear == "Y2")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions identified before referral") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Table of Year 3 conditions

ref_cond_tbl3_pre <- condition_summary_pre |>
  filter(DataYear == "Y3")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions identified before referral") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Post referral ------------------------------------------------------------

# Table of Year 1 conditions

ref_cond_tbl1_post <- condition_summary_post |>
  filter(DataYear == "Y1")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions identified after referral") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Table of Year 2 conditions

ref_cond_tbl2_post <- condition_summary_post |>
  filter(DataYear == "Y2")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions identified after referral") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))


# Table of Year 3 conditions

ref_cond_tbl3_post <- condition_summary_post |>
  filter(DataYear == "Y3")|>
  ungroup() |>
  mutate(Total_identified = if_else(Total_identified < 5,
                                    NA_real_,
                                    round(Total_identified / 5) * 5),
         Primary_flag = if_else(Primary_flag < 5,
                                NA_real_,
                                round(Primary_flag / 5) * 5),
         Secondary_flag = if_else(Secondary_flag < 5,
                                  NA_real_,
                                  round(Secondary_flag / 5) * 5)) |>
  select(Condition,
         Total_identified,
         Primary_flag,
         Secondary_flag) |>
  rename("Total identified" = "Total_identified",
         "Primary Diagnosis" = "Primary_flag",
         "Secondary Diagnosis" = "Secondary_flag") |>
  gt() |>
  tab_header(title = "Conditions identified after referral") |>
  tab_style(style = list(cell_fill(color = palette_tu[1])),
            locations = cells_column_labels(everything()))

