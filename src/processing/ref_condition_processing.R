
# Total by year -----------------------------------------------------------

# Extract only necessary columns from condition flags table

ref_con_proc <- ref_con_flag  |>
  filter(New_referral == 1) |>
  mutate('Autism_con' = case_when(AutismStatus < 5 ~ 1,
                              TRUE ~ 0),
         'LD_con' = case_when(LDStatus < 5 ~ 1,
                          TRUE ~ 0),
         'Diag_Time' = "Unknown",
         'DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0')) |>
  select(Der_Person_ID,
         DataYear,
         New_referral,
         Autism_con,
         LD_con)


# Summarise primary diagnosed conditions

ref_prim_proc <- ref_prim_flag |>
  mutate('DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'))|>
  group_by(Der_Person_ID,
           DataYear) |>
  summarise('Autism_Diag' = sum(Autism_Prim_Diag, na.rm = TRUE),
            'LD_Diag' = sum(LD_Prim_Diag, na.rm = TRUE),
            'ADHD_Diag' = sum(ADHD_Prim_Diag, na.rm = TRUE),
            'Pers_Dis_Diag' = sum(Pers_Dis_Prim_Diag, na.rm = TRUE),
            'PTSD_Diag' = sum(PTSD_Prim_Diag, na.rm = TRUE),
            'Major_Dep_Dis_Diag' = sum(Major_Dep_Dis_Prim_Diag, na.rm = TRUE),
            'Anx_Dis_Diag' = sum(Anx_Dis_Prim_Diag, na.rm = TRUE),
            'Subs_Use_Dis_Diag' = sum(Subs_Use_Dis_Prim_Diag, na.rm = TRUE)) |>
  mutate('Autism_prim' = case_when(Autism_Diag > 0 ~ 1,
                              TRUE ~ 0),
         'LD_prim' = case_when(LD_Diag > 0 ~ 1,
                          TRUE ~ 0),
         'ADHD_prim' = case_when(ADHD_Diag > 0 ~ 1,
                            TRUE ~ 0),
         'Pers_Dis_prim' = case_when(Pers_Dis_Diag > 0 ~ 1,
                              TRUE ~ 0),
         'PTSD_prim' = case_when(PTSD_Diag > 0 ~ 1,
                            TRUE ~ 0),
         'Major_Dep_Dis_prim' = case_when(Major_Dep_Dis_Diag > 0 ~ 1,
                                     TRUE ~ 0),
         'Anx_Dis_prim' = case_when(Anx_Dis_Diag > 0 ~ 1,
                               TRUE ~ 0),
         'Subs_Use_Dis_prim' = case_when(Subs_Use_Dis_Diag > 0 ~ 1,
                                   TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_prim,
         LD_prim,
         ADHD_prim,
         Pers_Dis_prim,
         PTSD_prim,
         Major_Dep_Dis_prim,
         Anx_Dis_prim,
         Subs_Use_Dis_prim)


# Join to referrals conditions

ref_con_conprim <- left_join(ref_con_proc, ref_prim_proc, by = c("Der_Person_ID" = "Der_Person_ID",
                                                                 "DataYear" = "DataYear"))


# Summarise secondary diagnosed conditions

ref_sec_proc <- ref_sec_flag |>
  mutate('DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'))|>
  group_by(Der_Person_ID,
           DataYear) |>
  summarise('Autism_Diag' = sum(Autism_Sec_Diag, na.rm = TRUE),
            'LD_Diag' = sum(LD_Sec_Diag, na.rm = TRUE),
            'ADHD_Diag' = sum(ADHD_Sec_Diag, na.rm = TRUE),
            'Pers_Dis_Diag' = sum(Pers_Dis_Sec_Diag, na.rm = TRUE),
            'PTSD_Diag' = sum(PTSD_Sec_Diag, na.rm = TRUE),
            'Major_Dep_Dis_Diag' = sum(Major_Dep_Dis_Sec_Diag, na.rm = TRUE),
            'Anx_Dis_Diag' = sum(Anx_Dis_Sec_Diag, na.rm = TRUE),
            'Subs_Use_Dis_Diag' = sum(Subs_Use_Dis_Sec_Diag, na.rm = TRUE)) |>
  mutate('Autism_sec' = case_when(Autism_Diag > 0 ~ 1,
                                  TRUE ~ 0),
         'LD_sec' = case_when(LD_Diag > 0 ~ 1,
                              TRUE ~ 0),
         'ADHD_sec' = case_when(ADHD_Diag > 0 ~ 1,
                                TRUE ~ 0),
         'Pers_Dis_sec' = case_when(Pers_Dis_Diag > 0 ~ 1,
                                    TRUE ~ 0),
         'PTSD_sec' = case_when(PTSD_Diag > 0 ~ 1,
                                TRUE ~ 0),
         'Major_Dep_Dis_sec' = case_when(Major_Dep_Dis_Diag > 0 ~ 1,
                                         TRUE ~ 0),
         'Anx_Dis_sec' = case_when(Anx_Dis_Diag > 0 ~ 1,
                                   TRUE ~ 0),
         'Subs_Use_Dis_sec' = case_when(Subs_Use_Dis_Diag > 0 ~ 1,
                                        TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_sec,
         LD_sec,
         ADHD_sec,
         Pers_Dis_sec,
         PTSD_sec,
         Major_Dep_Dis_sec,
         Anx_Dis_sec,
         Subs_Use_Dis_sec)


# Join to referrals conditions and primary diagnosis

ref_con_all <- left_join(ref_con_conprim, ref_sec_proc, by = c("Der_Person_ID" = "Der_Person_ID",
                                                               "DataYear" = "DataYear")) |>
  mutate('Autism_flag' = case_when(Autism_con == 1 ~ 1,
                                   Autism_prim == 1 ~ 1,
                                   Autism_sec == 1 ~ 1,
                                   TRUE ~ 0),
         'LD_flag' = case_when(LD_con == 1 ~ 1,
                               LD_prim == 1 ~ 1,
                               LD_sec == 1 ~ 1,
                               TRUE ~ 0),
         'ADHD_flag' = case_when(ADHD_prim == 1 ~ 1,
                                 ADHD_sec == 1 ~ 1,
                                 TRUE ~ 0),
         'Pers_Dis_flag' = case_when(Pers_Dis_prim == 1 ~ 1,
                                     Pers_Dis_sec == 1 ~ 1,
                                     TRUE ~ 0),
         'PTSD_flag' = case_when(PTSD_prim == 1 ~ 1,
                                 PTSD_sec == 1 ~ 1,
                                 TRUE ~ 0),
         'Major_Dep_Dis_flag' = case_when(Major_Dep_Dis_prim == 1 ~ 1,
                                          Major_Dep_Dis_sec == 1 ~ 1,
                                          TRUE ~ 0),
         'Anx_Dis_flag' = case_when(Anx_Dis_prim == 1 ~ 1,
                                    Anx_Dis_sec == 1 ~ 1,
                                    TRUE ~ 0),
         'Subs_Use_Dis_flag' = case_when(Subs_Use_Dis_prim == 1 ~ 1,
                                         Subs_Use_Dis_sec == 1 ~ 1,
                                         TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_flag,
         LD_flag,
         ADHD_flag,
         Pers_Dis_flag,
         PTSD_flag,
         Major_Dep_Dis_flag,
         Anx_Dis_flag,
         Subs_Use_Dis_flag,
         Autism_con,
         Autism_prim,
         Autism_sec,
         LD_con,
         LD_prim,
         LD_sec,
         ADHD_prim,
         ADHD_sec,
         Pers_Dis_prim,
         Pers_Dis_sec,
         PTSD_prim,
         PTSD_sec,
         Major_Dep_Dis_prim,
         Major_Dep_Dis_sec,
         Anx_Dis_prim,
         Anx_Dis_sec,
         Subs_Use_Dis_prim,
         Subs_Use_Dis_sec)


# Condition summaries

autism_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Autism_flag, na.rm = TRUE),
            'Condition_flag' = sum(Autism_con, na.rm = TRUE),
            'Primary_flag' = sum(Autism_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Autism_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Autism") |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

ld_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(LD_flag, na.rm = TRUE),
            'Condition_flag' = sum(LD_con, na.rm = TRUE),
            'Primary_flag' = sum(LD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(LD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Learning Disability") |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

adhd_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(ADHD_flag, na.rm = TRUE),
            'Primary_flag' = sum(ADHD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(ADHD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "ADHD",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

pers_dis_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Pers_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Pers_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Pers_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Personality Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

ptsd_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(PTSD_flag, na.rm = TRUE),
            'Primary_flag' = sum(PTSD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(PTSD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "PTSD",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

major_dep_dis_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Major_Dep_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Major_Dep_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Major_Dep_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Major Depressive Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

anx_dis_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Anx_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Anx_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Anx_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Anxiety Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

sub_use_dis_summary <- ref_con_all |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Subs_Use_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Subs_Use_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Subs_Use_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Substance Use Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)


condition_summary <- rbind(autism_summary,
                           ld_summary,
                           adhd_summary,
                           pers_dis_summary,
                           ptsd_summary,
                           major_dep_dis_summary,
                           anx_dis_summary,
                           sub_use_dis_summary)



# Pre-referral diagnosis --------------------------------------------------

# Summarise primary diagnosed conditions

ref_con_conprim_pre <- ref_prim_flag |>
  filter(Diag_Time == "Diag_Pre_Ref") |>
  mutate('DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'))|>
  group_by(Der_Person_ID,
           DataYear) |>
  summarise('Autism_Diag' = sum(Autism_Prim_Diag, na.rm = TRUE),
            'LD_Diag' = sum(LD_Prim_Diag, na.rm = TRUE),
            'ADHD_Diag' = sum(ADHD_Prim_Diag, na.rm = TRUE),
            'Pers_Dis_Diag' = sum(Pers_Dis_Prim_Diag, na.rm = TRUE),
            'PTSD_Diag' = sum(PTSD_Prim_Diag, na.rm = TRUE),
            'Major_Dep_Dis_Diag' = sum(Major_Dep_Dis_Prim_Diag, na.rm = TRUE),
            'Anx_Dis_Diag' = sum(Anx_Dis_Prim_Diag, na.rm = TRUE),
            'Subs_Use_Dis_Diag' = sum(Subs_Use_Dis_Prim_Diag, na.rm = TRUE)) |>
  mutate('Autism_prim' = case_when(Autism_Diag > 0 ~ 1,
                                   TRUE ~ 0),
         'LD_prim' = case_when(LD_Diag > 0 ~ 1,
                               TRUE ~ 0),
         'ADHD_prim' = case_when(ADHD_Diag > 0 ~ 1,
                                 TRUE ~ 0),
         'Pers_Dis_prim' = case_when(Pers_Dis_Diag > 0 ~ 1,
                                     TRUE ~ 0),
         'PTSD_prim' = case_when(PTSD_Diag > 0 ~ 1,
                                 TRUE ~ 0),
         'Major_Dep_Dis_prim' = case_when(Major_Dep_Dis_Diag > 0 ~ 1,
                                          TRUE ~ 0),
         'Anx_Dis_prim' = case_when(Anx_Dis_Diag > 0 ~ 1,
                                    TRUE ~ 0),
         'Subs_Use_Dis_prim' = case_when(Subs_Use_Dis_Diag > 0 ~ 1,
                                         TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_prim,
         LD_prim,
         ADHD_prim,
         Pers_Dis_prim,
         PTSD_prim,
         Major_Dep_Dis_prim,
         Anx_Dis_prim,
         Subs_Use_Dis_prim)


# Summarise secondary diagnosed conditions

ref_sec_proc_pre <- ref_sec_flag |>
  filter(Diag_Time == "Diag_Pre_Ref") |>
  mutate('DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'))|>
  group_by(Der_Person_ID,
           DataYear) |>
  summarise('Autism_Diag' = sum(Autism_Sec_Diag, na.rm = TRUE),
            'LD_Diag' = sum(LD_Sec_Diag, na.rm = TRUE),
            'ADHD_Diag' = sum(ADHD_Sec_Diag, na.rm = TRUE),
            'Pers_Dis_Diag' = sum(Pers_Dis_Sec_Diag, na.rm = TRUE),
            'PTSD_Diag' = sum(PTSD_Sec_Diag, na.rm = TRUE),
            'Major_Dep_Dis_Diag' = sum(Major_Dep_Dis_Sec_Diag, na.rm = TRUE),
            'Anx_Dis_Diag' = sum(Anx_Dis_Sec_Diag, na.rm = TRUE),
            'Subs_Use_Dis_Diag' = sum(Subs_Use_Dis_Sec_Diag, na.rm = TRUE)) |>
  mutate('Autism_sec' = case_when(Autism_Diag > 0 ~ 1,
                                  TRUE ~ 0),
         'LD_sec' = case_when(LD_Diag > 0 ~ 1,
                              TRUE ~ 0),
         'ADHD_sec' = case_when(ADHD_Diag > 0 ~ 1,
                                TRUE ~ 0),
         'Pers_Dis_sec' = case_when(Pers_Dis_Diag > 0 ~ 1,
                                    TRUE ~ 0),
         'PTSD_sec' = case_when(PTSD_Diag > 0 ~ 1,
                                TRUE ~ 0),
         'Major_Dep_Dis_sec' = case_when(Major_Dep_Dis_Diag > 0 ~ 1,
                                         TRUE ~ 0),
         'Anx_Dis_sec' = case_when(Anx_Dis_Diag > 0 ~ 1,
                                   TRUE ~ 0),
         'Subs_Use_Dis_sec' = case_when(Subs_Use_Dis_Diag > 0 ~ 1,
                                        TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_sec,
         LD_sec,
         ADHD_sec,
         Pers_Dis_sec,
         PTSD_sec,
         Major_Dep_Dis_sec,
         Anx_Dis_sec,
         Subs_Use_Dis_sec)


# Join to referrals conditions and primary diagnosis

ref_con_all_pre <- left_join(ref_con_conprim_pre, ref_sec_proc_pre, by = c("Der_Person_ID" = "Der_Person_ID",
                                                                           "DataYear" = "DataYear")) |>
  mutate('Autism_flag' = case_when(Autism_prim == 1 ~ 1,
                                   Autism_sec == 1 ~ 1,
                                   TRUE ~ 0),
         'LD_flag' = case_when(LD_prim == 1 ~ 1,
                               LD_sec == 1 ~ 1,
                               TRUE ~ 0),
         'ADHD_flag' = case_when(ADHD_prim == 1 ~ 1,
                                 ADHD_sec == 1 ~ 1,
                                 TRUE ~ 0),
         'Pers_Dis_flag' = case_when(Pers_Dis_prim == 1 ~ 1,
                                     Pers_Dis_sec == 1 ~ 1,
                                     TRUE ~ 0),
         'PTSD_flag' = case_when(PTSD_prim == 1 ~ 1,
                                 PTSD_sec == 1 ~ 1,
                                 TRUE ~ 0),
         'Major_Dep_Dis_flag' = case_when(Major_Dep_Dis_prim == 1 ~ 1,
                                          Major_Dep_Dis_sec == 1 ~ 1,
                                          TRUE ~ 0),
         'Anx_Dis_flag' = case_when(Anx_Dis_prim == 1 ~ 1,
                                    Anx_Dis_sec == 1 ~ 1,
                                    TRUE ~ 0),
         'Subs_Use_Dis_flag' = case_when(Subs_Use_Dis_prim == 1 ~ 1,
                                         Subs_Use_Dis_sec == 1 ~ 1,
                                         TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_flag,
         LD_flag,
         ADHD_flag,
         Pers_Dis_flag,
         PTSD_flag,
         Major_Dep_Dis_flag,
         Anx_Dis_flag,
         Subs_Use_Dis_flag,
         Autism_prim,
         Autism_sec,
         LD_prim,
         LD_sec,
         ADHD_prim,
         ADHD_sec,
         Pers_Dis_prim,
         Pers_Dis_sec,
         PTSD_prim,
         PTSD_sec,
         Major_Dep_Dis_prim,
         Major_Dep_Dis_sec,
         Anx_Dis_prim,
         Anx_Dis_sec,
         Subs_Use_Dis_prim,
         Subs_Use_Dis_sec)


# Condition summaries

autism_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Autism_flag, na.rm = TRUE),
            'Primary_flag' = sum(Autism_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Autism_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Autism") |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

ld_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(LD_flag, na.rm = TRUE),
            'Primary_flag' = sum(LD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(LD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Learning Disability") |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

adhd_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(ADHD_flag, na.rm = TRUE),
            'Primary_flag' = sum(ADHD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(ADHD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "ADHD",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

pers_dis_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Pers_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Pers_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Pers_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Personality Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

ptsd_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(PTSD_flag, na.rm = TRUE),
            'Primary_flag' = sum(PTSD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(PTSD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "PTSD",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

major_dep_dis_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Major_Dep_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Major_Dep_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Major_Dep_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Major Depressive Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

anx_dis_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Anx_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Anx_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Anx_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Anxiety Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

sub_use_dis_summary_pre <- ref_con_all_pre |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Subs_Use_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Subs_Use_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Subs_Use_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Substance Use Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)


condition_summary_pre <- rbind(autism_summary_pre,
                               ld_summary_pre,
                               adhd_summary_pre,
                               pers_dis_summary_pre,
                               ptsd_summary_pre,
                               major_dep_dis_summary_pre,
                               anx_dis_summary_pre,
                               sub_use_dis_summary_pre)


# Post-referral diagnosis --------------------------------------------------

# Summarise primary diagnosed conditions

ref_con_conprim_post <- ref_prim_flag |>
  filter(Diag_Time == "Diag_Post_Ref") |>
  mutate('DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'))|>
  group_by(Der_Person_ID,
           DataYear) |>
  summarise('Autism_Diag' = sum(Autism_Prim_Diag, na.rm = TRUE),
            'LD_Diag' = sum(LD_Prim_Diag, na.rm = TRUE),
            'ADHD_Diag' = sum(ADHD_Prim_Diag, na.rm = TRUE),
            'Pers_Dis_Diag' = sum(Pers_Dis_Prim_Diag, na.rm = TRUE),
            'PTSD_Diag' = sum(PTSD_Prim_Diag, na.rm = TRUE),
            'Major_Dep_Dis_Diag' = sum(Major_Dep_Dis_Prim_Diag, na.rm = TRUE),
            'Anx_Dis_Diag' = sum(Anx_Dis_Prim_Diag, na.rm = TRUE),
            'Subs_Use_Dis_Diag' = sum(Subs_Use_Dis_Prim_Diag, na.rm = TRUE)) |>
  mutate('Autism_prim' = case_when(Autism_Diag > 0 ~ 1,
                                   TRUE ~ 0),
         'LD_prim' = case_when(LD_Diag > 0 ~ 1,
                               TRUE ~ 0),
         'ADHD_prim' = case_when(ADHD_Diag > 0 ~ 1,
                                 TRUE ~ 0),
         'Pers_Dis_prim' = case_when(Pers_Dis_Diag > 0 ~ 1,
                                     TRUE ~ 0),
         'PTSD_prim' = case_when(PTSD_Diag > 0 ~ 1,
                                 TRUE ~ 0),
         'Major_Dep_Dis_prim' = case_when(Major_Dep_Dis_Diag > 0 ~ 1,
                                          TRUE ~ 0),
         'Anx_Dis_prim' = case_when(Anx_Dis_Diag > 0 ~ 1,
                                    TRUE ~ 0),
         'Subs_Use_Dis_prim' = case_when(Subs_Use_Dis_Diag > 0 ~ 1,
                                         TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_prim,
         LD_prim,
         ADHD_prim,
         Pers_Dis_prim,
         PTSD_prim,
         Major_Dep_Dis_prim,
         Anx_Dis_prim,
         Subs_Use_Dis_prim)


# Summarise secondary diagnosed conditions

ref_sec_proc_post <- ref_sec_flag |>
  filter(Diag_Time == "Diag_Post_Ref") |>
  mutate('DataYear' = case_when(ReferralRequestReceivedDate >= maxdate - years(1) ~ 'Y3',
                                ReferralRequestReceivedDate >= maxdate - years(2) ~ 'Y2',
                                ReferralRequestReceivedDate >= maxdate - years(3) ~ 'Y1',
                                TRUE ~ 'Y0'))|>
  group_by(Der_Person_ID,
           DataYear) |>
  summarise('Autism_Diag' = sum(Autism_Sec_Diag, na.rm = TRUE),
            'LD_Diag' = sum(LD_Sec_Diag, na.rm = TRUE),
            'ADHD_Diag' = sum(ADHD_Sec_Diag, na.rm = TRUE),
            'Pers_Dis_Diag' = sum(Pers_Dis_Sec_Diag, na.rm = TRUE),
            'PTSD_Diag' = sum(PTSD_Sec_Diag, na.rm = TRUE),
            'Major_Dep_Dis_Diag' = sum(Major_Dep_Dis_Sec_Diag, na.rm = TRUE),
            'Anx_Dis_Diag' = sum(Anx_Dis_Sec_Diag, na.rm = TRUE),
            'Subs_Use_Dis_Diag' = sum(Subs_Use_Dis_Sec_Diag, na.rm = TRUE)) |>
  mutate('Autism_sec' = case_when(Autism_Diag > 0 ~ 1,
                                  TRUE ~ 0),
         'LD_sec' = case_when(LD_Diag > 0 ~ 1,
                              TRUE ~ 0),
         'ADHD_sec' = case_when(ADHD_Diag > 0 ~ 1,
                                TRUE ~ 0),
         'Pers_Dis_sec' = case_when(Pers_Dis_Diag > 0 ~ 1,
                                    TRUE ~ 0),
         'PTSD_sec' = case_when(PTSD_Diag > 0 ~ 1,
                                TRUE ~ 0),
         'Major_Dep_Dis_sec' = case_when(Major_Dep_Dis_Diag > 0 ~ 1,
                                         TRUE ~ 0),
         'Anx_Dis_sec' = case_when(Anx_Dis_Diag > 0 ~ 1,
                                   TRUE ~ 0),
         'Subs_Use_Dis_sec' = case_when(Subs_Use_Dis_Diag > 0 ~ 1,
                                        TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_sec,
         LD_sec,
         ADHD_sec,
         Pers_Dis_sec,
         PTSD_sec,
         Major_Dep_Dis_sec,
         Anx_Dis_sec,
         Subs_Use_Dis_sec)


# Join to referrals conditions and primary diagnosis

ref_con_all_post <- left_join(ref_con_conprim_post, ref_sec_proc_post, by = c("Der_Person_ID" = "Der_Person_ID",
                                                                              "DataYear" = "DataYear")) |>
  mutate('Autism_flag' = case_when(Autism_prim == 1 ~ 1,
                                   Autism_sec == 1 ~ 1,
                                   TRUE ~ 0),
         'LD_flag' = case_when(LD_prim == 1 ~ 1,
                               LD_sec == 1 ~ 1,
                               TRUE ~ 0),
         'ADHD_flag' = case_when(ADHD_prim == 1 ~ 1,
                                 ADHD_sec == 1 ~ 1,
                                 TRUE ~ 0),
         'Pers_Dis_flag' = case_when(Pers_Dis_prim == 1 ~ 1,
                                     Pers_Dis_sec == 1 ~ 1,
                                     TRUE ~ 0),
         'PTSD_flag' = case_when(PTSD_prim == 1 ~ 1,
                                 PTSD_sec == 1 ~ 1,
                                 TRUE ~ 0),
         'Major_Dep_Dis_flag' = case_when(Major_Dep_Dis_prim == 1 ~ 1,
                                          Major_Dep_Dis_sec == 1 ~ 1,
                                          TRUE ~ 0),
         'Anx_Dis_flag' = case_when(Anx_Dis_prim == 1 ~ 1,
                                    Anx_Dis_sec == 1 ~ 1,
                                    TRUE ~ 0),
         'Subs_Use_Dis_flag' = case_when(Subs_Use_Dis_prim == 1 ~ 1,
                                         Subs_Use_Dis_sec == 1 ~ 1,
                                         TRUE ~ 0)) |>
  select(Der_Person_ID,
         DataYear,
         Autism_flag,
         LD_flag,
         ADHD_flag,
         Pers_Dis_flag,
         PTSD_flag,
         Major_Dep_Dis_flag,
         Anx_Dis_flag,
         Subs_Use_Dis_flag,
         Autism_prim,
         Autism_sec,
         LD_prim,
         LD_sec,
         ADHD_prim,
         ADHD_sec,
         Pers_Dis_prim,
         Pers_Dis_sec,
         PTSD_prim,
         PTSD_sec,
         Major_Dep_Dis_prim,
         Major_Dep_Dis_sec,
         Anx_Dis_prim,
         Anx_Dis_sec,
         Subs_Use_Dis_prim,
         Subs_Use_Dis_sec)


# Condition summaries

autism_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Autism_flag, na.rm = TRUE),
            'Primary_flag' = sum(Autism_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Autism_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Autism") |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

ld_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(LD_flag, na.rm = TRUE),
            'Primary_flag' = sum(LD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(LD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Learning Disability") |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

adhd_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(ADHD_flag, na.rm = TRUE),
            'Primary_flag' = sum(ADHD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(ADHD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "ADHD",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

pers_dis_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Pers_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Pers_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Pers_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Personality Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

ptsd_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(PTSD_flag, na.rm = TRUE),
            'Primary_flag' = sum(PTSD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(PTSD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "PTSD",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

major_dep_dis_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Major_Dep_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Major_Dep_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Major_Dep_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Major Depressive Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

anx_dis_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Anx_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Anx_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Anx_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Anxiety Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)

sub_use_dis_summary_post <- ref_con_all_post |>
  group_by(DataYear) |>
  summarise('Total_identified' = sum(Subs_Use_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Subs_Use_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Subs_Use_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Substance Use Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         DataYear,
         Total_identified,
         Primary_flag,
         Secondary_flag)


condition_summary_post <- rbind(autism_summary_post,
                                ld_summary_post,
                                adhd_summary_post,
                                pers_dis_summary_post,
                                ptsd_summary_post,
                                major_dep_dis_summary_post,
                                anx_dis_summary_post,
                                sub_use_dis_summary_post)
