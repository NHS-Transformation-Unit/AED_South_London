
# All Providers -----------------------------------------------------------


ref_new_fy <- ref_new_proc |>
  mutate(financial_year = if_else(month(ReferralRequestReceivedDate) < 4,
                                  year(ReferralRequestReceivedDate) - 1,
                                  year(ReferralRequestReceivedDate))) 


all_ref_new <- ref_new_fy |>
  filter(financial_year > 2022) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Rejections' = sum(Rejected_Flag, na.rm = TRUE)) |>
  mutate('Rejection%' = Rejections / Referrals)

all_ref_pop <- cbind(all_ref_new, pop_tot) |>
  mutate('population_rate' = ((Referrals / LAD_Population) * 1000) / 3) # 3 years of data


fy_ref_new <- ref_new_fy |>
  filter(financial_year > 2022) |>
  group_by(financial_year) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Rejections' = sum(Rejected_Flag, na.rm = TRUE)) |>
  mutate('Rejection%' = Rejections / Referrals)

fy_ref_pop <- cbind(fy_ref_new, pop_tot) |>
  mutate('population_rate' = (Referrals / LAD_Population) * 1000)



# SL Resident ------------------------------------------------------------

all_ref_new_SL <- ref_new_fy |>
  filter(financial_year > 2022,
         SL_Resident_Flag == "SL Resident") |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Rejections' = sum(Rejected_Flag, na.rm = TRUE)) |>
  mutate('Rejection%' = Rejections / Referrals)

all_ref_pop_SL <- cbind(all_ref_new_SL, pop_tot) |>
  mutate('population_rate' = ((Referrals / LAD_Population) * 1000) / 3) # 3 years of data


fy_ref_new_SL <- ref_new_fy |>
  filter(financial_year > 2022,
         SL_Resident_Flag == "SL Resident") |>
  group_by(financial_year) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Rejections' = sum(Rejected_Flag, na.rm = TRUE)) |>
  mutate('Rejection%' = Rejections / Referrals)

fy_ref_pop_SL <- cbind(fy_ref_new_SL, pop_tot) |>
  mutate('population_rate' = (Referrals / LAD_Population) * 1000)


# NON SL Resident ------------------------------------------------------------

all_ref_new_NSL <- ref_new_fy |>
  filter(financial_year > 2022,
         SL_Resident_Flag == "Non-SL Resident") |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Rejections' = sum(Rejected_Flag, na.rm = TRUE)) |>
  mutate('Rejection%' = Rejections / Referrals)

all_ref_pop_NSL <- cbind(all_ref_new_NSL, pop_tot) |>
  mutate('population_rate' = ((Referrals / LAD_Population) * 1000) / 3) # 3 years of data


fy_ref_new_NSL <- ref_new_fy |>
  filter(financial_year > 2022,
         SL_Resident_Flag == "Non-SL Resident") |>
  group_by(financial_year) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Rejections' = sum(Rejected_Flag, na.rm = TRUE)) |>
  mutate('Rejection%' = Rejections / Referrals)

fy_ref_pop_NSL <- cbind(fy_ref_new_NSL, pop_tot) |>
  mutate('population_rate' = (Referrals / LAD_Population) * 1000)
