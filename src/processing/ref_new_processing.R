
# Add age bands to referrals

ref_new_proc <- ref_new |>
  mutate('Age_band' = case_when(AgeServReferRecDate < 12 ~ 'Under 12',
                                between(AgeServReferRecDate,12,18) ~ '12 to 18',
                                between(AgeServReferRecDate,19,25) ~ '19 to 25',
                                between(AgeServReferRecDate,26,35) ~ '26 to 35',
                                between(AgeServReferRecDate,36,45) ~ '36 to 45',
                                between(AgeServReferRecDate,46,55) ~ '46 to 55',
                                between(AgeServReferRecDate,56,65) ~ '56 to 65',
                                between(AgeServReferRecDate,66,75) ~ '66 to 75',
                                between(AgeServReferRecDate,76,85) ~ '76 to 85',
                                AgeServReferRecDate > 85 ~ 'Over 85',
                                TRUE ~ 'NA'))


# Age banding of population

ref_new_age_LA <- ref_new_proc |>
  group_by(LAD16NM,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_age_LA_stat <- ref_new_age_LA |>
  group_by(LAD16NM) |>
  summarise('Mean' = mean(Referrals, na.rm = TRUE),
            'SD' = sd(Referrals, na.rm = TRUE),
            'Error' = SD/sqrt(Referrals),
            'low_error' = `Mean` - `Error`,
            'high_error' = `Mean` + `Error`)

ref_new_age_tot <- ref_new_proc |>
  mutate("Total" = "Total") |>
  group_by(Total,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE)) |>
  rename("LAD16NM" = "Total")

ref_new_age_tot_stat <- ref_new_age_tot |>
  group_by(LAD16NM) |>
  summarise('Mean' = mean(Referrals, na.rm = TRUE),
            'SD' = sd(Referrals, na.rm = TRUE),
            'Error' = SD/sqrt(Referrals),
            'low_error' = `Mean` - `Error`,
            'high_error' = `Mean` + `Error`)

ref_new_age <- rbind(ref_new_age_LA,ref_new_age_tot)


# Ethnicity banding of population

ref_new_eth <- ref_new_proc |>
  group_by(LAD16NM,
           Ethnic_Category_Main_Desc) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

