
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


# Other Flags -------------------------------------------------------------

fy_ref_autld <- ref_new_fy |>
  filter(Rejected_Flag == 0,
         financial_year > 2022) |>
  group_by(financial_year) |>
  mutate('Aut_Only' = case_when(AutismFlag == '1' & LDFlag == '0' ~ 1,
                                     TRUE ~ 0),
         'LD_Only' = case_when(LDFlag == '1' & AutismFlag == '0' ~ 1,
                               TRUE ~ 0),
         'Aut/LD' = case_when(AutismFlag == '1' & LDFlag == '1' ~ 1,
                                     TRUE ~ 0)) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Aut' = sum(Aut_Only, na.rm = TRUE),
            'LD' = sum(LD_Only, na.rm = TRUE),
            'Aut&LD' = sum(`Aut/LD`, na.rm = TRUE)) |>
  mutate('Aut%' = Aut / Referrals,
         'LD%' = LD / Referrals,
         'Aut&LD%' = `Aut&LD` / Referrals)

all_ref_autld <- ref_new_fy |>
  filter(Rejected_Flag == 0,
         financial_year > 2022) |>
  mutate('Aut_Only' = case_when(AutismFlag == '1' & LDFlag == '0' ~ 1,
                                TRUE ~ 0),
         'LD_Only' = case_when(LDFlag == '1' & AutismFlag == '0' ~ 1,
                               TRUE ~ 0),
         'Aut/LD' = case_when(AutismFlag == '1' & LDFlag == '1' ~ 1,
                              TRUE ~ 0)) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE),
            'Aut' = sum(Aut_Only, na.rm = TRUE),
            'LD' = sum(LD_Only, na.rm = TRUE),
            'Aut&LD' = sum(`Aut/LD`, na.rm = TRUE)) |>
  mutate('Aut%' = Aut / Referrals,
         'LD%' = LD / Referrals,
         'Aut&LD%' = `Aut&LD` / Referrals)
