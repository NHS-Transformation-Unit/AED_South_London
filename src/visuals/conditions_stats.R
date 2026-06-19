
ref_condition_tbl <- condition_summary |>
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