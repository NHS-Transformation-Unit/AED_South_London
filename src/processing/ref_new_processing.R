
# Minimum referral date

maxdate <- max(ref_new$ReferralRequestReceivedDate, na.rm = TRUE)
mindate <- max(ref_new$ReferralRequestReceivedDate, na.rm = TRUE) - years(3) +1

# Add age bands to referrals

ref_new_proc <- ref_new |>
  mutate('Age_band' = case_when(AgeServReferRecDate < 12 ~ 'Under 12',
                                AgeServReferRecDate < 18 ~ '12 to 17',
                                AgeServReferRecDate < 26 ~ '18 to 25',
                                AgeServReferRecDate < 36 ~ '26 to 35',
                                AgeServReferRecDate < 46 ~ '36 to 45',
                                AgeServReferRecDate < 56 ~ '46 to 55',
                                AgeServReferRecDate < 66 ~ '56 to 65',
                                AgeServReferRecDate < 76 ~ '66 to 75',
                                AgeServReferRecDate < 86 ~ '76 to 85',
                                AgeServReferRecDate > 85 ~ 'Over 85',
                                TRUE ~ 'NA'),
         'Ethnic_group' = case_when(Ethnic_Category_Main_Desc == 'British' ~ 'White: English, Welsh, Scottish, Northern Irish or British',
                                    Ethnic_Category_Main_Desc == 'White and Asian' ~ 'Asian, Asian British or Asian Welsh',
                                    Ethnic_Category_Main_Desc == 'Chinese' ~ 'Asian, Asian British or Asian Welsh',
                                    Ethnic_Category_Main_Desc == 'Any other Asian background' ~ 'Asian, Asian British or Asian Welsh',
                                    Ethnic_Category_Main_Desc == 'Caribbean' ~ 'Black, Black British, Black Welsh, Caribbean or African',
                                    Ethnic_Category_Main_Desc == 'African' ~ 'Black, Black British, Black Welsh, Caribbean or African',
                                    Ethnic_Category_Main_Desc == 'White and Black African' ~ 'Black, Black British, Black Welsh, Caribbean or African',
                                    Ethnic_Category_Main_Desc == 'White and Black Caribbean' ~ 'Black, Black British, Black Welsh, Caribbean or African',
                                    Ethnic_Category_Main_Desc == 'Any other Black background' ~ 'Black, Black British, Black Welsh, Caribbean or African',
                                    Ethnic_Category_Main_Desc == 'Any other mixed background' ~ 'Mixed or Multiple ethnic groups',
                                    Ethnic_Category_Main_Desc == 'Irish' ~ 'White: Irish',
                                    Ethnic_Category_Main_Desc == 'Any other white background' ~ 'White: Gypsy or Irish Traveller, Roma or Other White',
                                    Ethnic_Category_Main_Desc == 'Bangladeshi' ~ 'Other ethnic group',
                                    Ethnic_Category_Main_Desc == 'Indian' ~ 'Other ethnic group',
                                    Ethnic_Category_Main_Desc == 'Pakistani' ~ 'Other ethnic group',
                                    Ethnic_Category_Main_Desc == 'Any other ethnic group' ~ 'Other ethnic group',
                                    Ethnic_Category_Main_Desc == 'Not stated' ~ 'Does not apply',
                                    Ethnic_Category_Main_Desc == 'Not known' ~ 'Does not apply'),
         IMD19dec = as.numeric(IMD19dec),
         'DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'),
         'Gender_group' = case_when(Gender == '1' ~ 'Male',
                                    Gender == '2' ~ 'Female',
                                    Gender == '9' ~ 'Indeterminate',
                                    TRUE ~ 'Not Known'),
         'SL Side' = case_when(LAD16NM %in% c("Bexley",
                                              "Bromley",
                                              "Greenwich",
                                              "Lambeth",
                                              "Lewisham",
                                              "Southwark",
                                              "Croydon") ~ 'South East',
                               TRUE ~ 'South West'))


# Age banding of population

ref_new_age_LA <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(LAD16NM,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_age_SL <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(`SL Side`,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_age_tot <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  mutate("Total" = "London") |>
  group_by(Total,
           Age_band) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_age_tot_yr <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0,
         DataYear != 'Y0') |>
  mutate("Total" = "London") |>
  group_by(Total,
           Age_band,
           DataYear) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_age_tot_yr1 <- ref_new_age_tot_yr |>
  filter(DataYear =='Y1')

ref_new_age_tot_yr2 <- ref_new_age_tot_yr |>
  filter(DataYear =='Y2')

ref_new_age_tot_yr3 <- ref_new_age_tot_yr |>
  filter(DataYear =='Y3')


# Deprivation banding of population

ref_new_dep_LA <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(LAD16NM,
           IMD19dec) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_dep_SL <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(`SL Side`,
           IMD19dec) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_dep_tot <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  mutate("Total" = "London") |>
  group_by(Total,
           IMD19dec) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))


# Gender of population

ref_new_gen_LA <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(LAD16NM,
           Gender_group) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_gen_SL <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(`SL Side`,
           Gender_group) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_gen_tot <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  mutate("Total" = "London") |>
  group_by(Total,
           Gender_group) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))


# Ethnicity banding of population

ref_new_eth_LA <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(LAD16NM,
           Ethnic_group) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_eth_SL <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(`SL Side`,
           Ethnic_group) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))

ref_new_eth_tot <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  mutate("Total" = "London") |>
  group_by(Total,
           Ethnic_group) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE))


# Diagnosis grouping of population

ref_new_diag <- ref_new_proc |>
  filter(Rejected_Flag == 0) |>
  group_by(PrimaryDiag,
           Description) |>
  summarise('Referrals' = sum(New_referral, na.rm = TRUE)) |>
  mutate('Diagnosis' = case_when(Referrals < 300 ~ 'Other diagnosis',
                                 TRUE ~ Description)) |>
  group_by(Diagnosis) |>
  summarise('Diagnosed' = sum(Referrals,na.rm = TRUE)) |>
  mutate(colour = colorRampPalette(palette_tu)(n()),
         colour = replace(colour, which.max(Diagnosed),"grey"))



# Totals ------------------------------------------------------------------

ref_new_LA <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(LAD16NM) |>
  summarise('LAD_total' = sum(New_referral, na.rm = TRUE))

ref_new_SL <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  group_by(`SL Side`) |>
  summarise('LAD_total' = sum(New_referral, na.rm = TRUE))

ref_new_tot <- ref_new_proc |>
  filter(SL_Resident_Flag == 'SL Resident',
         Rejected_Flag == 0) |>
  mutate("Total" = "London") |>
  group_by(Total) |>
  summarise('LAD_total' = sum(New_referral, na.rm = TRUE))


# Age - Percentage and Errors ---------------------------------------------------

ref_new_LA_per <- left_join(ref_new_age_LA,ref_new_LA,by = c('LAD16NM'='LAD16NM')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2)))))

ref_new_SL_per <- left_join(ref_new_age_SL,ref_new_SL,by = c('SL Side'='SL Side')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "SL Side")

ref_new_tot_per <- left_join(ref_new_age_tot,ref_new_tot,by = c('Total'='Total')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "Total")


ref_new_per <- rbind(ref_new_LA_per, ref_new_SL_per, ref_new_tot_per)



# Deprivation - Percentage and Errors -------------------------------------

ref_new_dep_LA_per <- left_join(ref_new_dep_LA,ref_new_LA,by = c('LAD16NM'='LAD16NM')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2)))))

ref_new_dep_SL_per <- left_join(ref_new_dep_SL,ref_new_SL,by = c('SL Side'='SL Side')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "SL Side")

ref_new_dep_tot_per <- left_join(ref_new_dep_tot,ref_new_tot,by = c('Total'='Total')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "Total")


ref_new_dep_per <- rbind(ref_new_dep_LA_per, ref_new_dep_SL_per, ref_new_dep_tot_per)


# DGender - Percentage and Errors -------------------------------------

ref_new_gen_LA_per <- left_join(ref_new_gen_LA,ref_new_LA,by = c('LAD16NM'='LAD16NM')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2)))))

ref_new_gen_SL_per <- left_join(ref_new_gen_SL,ref_new_SL,by = c('SL Side'='SL Side')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "SL Side")

ref_new_gen_tot_per <- left_join(ref_new_gen_tot,ref_new_tot,by = c('Total'='Total')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "Total")


ref_new_gen_per <- rbind(ref_new_gen_LA_per, ref_new_gen_SL_per, ref_new_gen_tot_per)


# Ethnicity - Percentage and Errors ----------------------------------------

ref_new_eth_LA_per <- left_join(ref_new_eth_LA,ref_new_LA,by = c('LAD16NM'='LAD16NM')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2)))))

ref_new_eth_SL_per <- left_join(ref_new_eth_SL,ref_new_SL,by = c('SL Side'='SL Side')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "SL Side")

ref_new_eth_tot_per <- left_join(ref_new_eth_tot,ref_new_tot,by = c('Total'='Total')) |>
  mutate('Percentage' = Referrals/LAD_total,
         'Confidence' = Percentage - (((2*Referrals) + (1.96^2) - (1.96*sqrt((1.96^2) + (4*Referrals*(1-Percentage)))))/(2*(LAD_total+(1.96^2))))) |>
  rename("LAD16NM" = "Total")


ref_new_eth_per <- rbind(ref_new_eth_LA_per, ref_new_eth_SL_per, ref_new_eth_tot_per)

