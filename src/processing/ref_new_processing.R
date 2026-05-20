
# Add age bands to referrals

ref_new_proc <- ref_new |>
  mutate('Age_band' = case_when(AgeServReferRecDate < 12 ~ 'Under 12',
                                AgeServReferRecDate < 19 ~ '12 to 18',
                                AgeServReferRecDate < 26 ~ '19 to 25',
                                AgeServReferRecDate < 36 ~ '26 to 35',
                                AgeServReferRecDate < 46 ~ '36 to 45',
                                AgeServReferRecDate < 56 ~ '46 to 55',
                                AgeServReferRecDate < 66 ~ '56 to 65',
                                AgeServReferRecDate < 76 ~ '66 to 75',
                                AgeServReferRecDate < 86 ~ '76 to 85',
                                AgeServReferRecDate > 85 ~ 'Over 85',
                                TRUE ~ 'NA'))


# Age banding of population

ref_new_age_LA <- ref_new_proc |>
  group_by(LAD16NM,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_age_tot <- ref_new_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))


# Ethnicity banding of population

ref_new_eth_LA <- ref_new_proc |>
  group_by(LAD16NM,
           Ethnic_Category_Main_Desc) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_eth_tot <- ref_new_proc |>
  mutate("Total" = "London") |>
  group_by(Total,
           Ethnic_Category_Main_Desc) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))



# Totals ------------------------------------------------------------------

ref_new_LA <- ref_new_proc |>
  group_by(LAD16NM) |>
  summarise('LAD_total' = sum(New_referral, na.rm = TRUE))

ref_new_tot <- ref_new_proc |>
  mutate("Total" = "London") |>
  group_by(Total) |>
  summarise('LAD_total' = sum(New_referral, na.rm = TRUE))


# Age - Percentage and Errors ---------------------------------------------------

ref_new_LA_per <- left_join(ref_new_age_LA,ref_new_LA,by = c('LAD16NM'='LAD16NM')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2)))))

ref_new_tot_per <- left_join(ref_new_age_tot,ref_new_tot,by = c('Total'='Total')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "Total")


ref_new_per <- rbind(ref_new_LA_per, ref_new_tot_per)


# Ethnicity - Percentage and Errors ----------------------------------------

ref_new_eth_LA_per <- left_join(ref_new_eth_LA,ref_new_LA,by = c('LAD16NM'='LAD16NM')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2)))))

ref_new_eth_tot_per <- left_join(ref_new_eth_tot,ref_new_tot,by = c('Total'='Total')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "Total")


ref_new_eth_per <- rbind(ref_new_eth_LA_per, ref_new_eth_tot_per)

