
# Referrals split by FY

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
