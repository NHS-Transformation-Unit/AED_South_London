
# Extract only necessary columns from condition flags table

ref_con_proc <- ref_con_flag  |>
  filter(New_referral == 1) |>
  mutate('Autism_con' = case_when(AutismStatus < 5 ~ 1,
                              TRUE ~ 0),
         'LD_con' = case_when(LDStatus < 5 ~ 1,
                          TRUE ~ 0)) |>
  select(Der_Person_ID,
         ReferralRequestReceivedDate,
         New_referral,
         Autism_con,
         LD_con)


# Summarise primary diagnosed conditions

ref_prim_proc <- ref_prim_flag |>
  group_by(Der_Person_ID) |>
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
         Autism_prim,
         LD_prim,
         ADHD_prim,
         Pers_Dis_prim,
         PTSD_prim,
         Major_Dep_Dis_prim,
         Anx_Dis_prim,
         Subs_Use_Dis_prim)


# Join to referrals conditions

ref_con_conprim <- left_join(ref_con_proc, ref_prim_proc, by = c("Der_Person_ID" = "Der_Person_ID"))


# Summarise secondary diagnosed conditions

ref_sec_proc <- ref_sec_flag |>
  group_by(Der_Person_ID) |>
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
         Autism_sec,
         LD_sec,
         ADHD_sec,
         Pers_Dis_sec,
         PTSD_sec,
         Major_Dep_Dis_sec,
         Anx_Dis_sec,
         Subs_Use_Dis_sec)


# Join to referrals conditions and primary diagnosis

ref_con_all <- left_join(ref_con_conprim, ref_sec_proc, by = c("Der_Person_ID" = "Der_Person_ID")) |>
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
         ReferralRequestReceivedDate,
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


# Cndition summaries

autism_summary <- ref_con_all |>
  summarise('Total_identified' = sum(Autism_flag, na.rm = TRUE),
            'Condition_flag' = sum(Autism_con, na.rm = TRUE),
            'Primary_flag' = sum(Autism_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Autism_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Autism") |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

ld_summary <- ref_con_all |>
  summarise('Total_identified' = sum(LD_flag, na.rm = TRUE),
            'Condition_flag' = sum(LD_con, na.rm = TRUE),
            'Primary_flag' = sum(LD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(LD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Learning Disability") |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

adhd_summary <- ref_con_all |>
  summarise('Total_identified' = sum(ADHD_flag, na.rm = TRUE),
            'Primary_flag' = sum(ADHD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(ADHD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "ADHD",
         'Condition_flag' = 0) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

pers_dis_summary <- ref_con_all |>
  summarise('Total_identified' = sum(Pers_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Pers_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Pers_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Personality Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

ptsd_summary <- ref_con_all |>
  summarise('Total_identified' = sum(PTSD_flag, na.rm = TRUE),
            'Primary_flag' = sum(PTSD_prim, na.rm = TRUE),
            'Secondary_flag' = sum(PTSD_sec, na.rm = TRUE)) |>
  mutate('Condition' = "PTSD",
         'Condition_flag' = 0) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

major_dep_dis_summary <- ref_con_all |>
  summarise('Total_identified' = sum(Major_Dep_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Major_Dep_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Major_Dep_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Major Depressive Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

anx_dis_summary <- ref_con_all |>
  summarise('Total_identified' = sum(Anx_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Anx_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Anx_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Anxiety Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
         Total_identified,
         Condition_flag,
         Primary_flag,
         Secondary_flag)

sub_use_dis_summary <- ref_con_all |>
  summarise('Total_identified' = sum(Subs_Use_Dis_flag, na.rm = TRUE),
            'Primary_flag' = sum(Subs_Use_Dis_prim, na.rm = TRUE),
            'Secondary_flag' = sum(Subs_Use_Dis_sec, na.rm = TRUE)) |>
  mutate('Condition' = "Substance Use Disorder",
         'Condition_flag' = 0) |>
  select(Condition,
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
