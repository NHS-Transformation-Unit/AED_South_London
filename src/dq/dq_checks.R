
# New Referrals -----------------------------------------------------------

dq_checks_new <- dq_ref_new |>
  left_join(national_ed_tableau_extract_dq,
            by = c("OrgIDProv" = "OrgCode",
                   "ReportingPeriodEndDate" = "Measure Name")) |>
  select(-c(`Closed referrals`)) |>
  mutate(difference = New_Referrals - `New referrals`,
         prop_difference = difference / New_Referrals)


# Closed Referrals --------------------------------------------------------

dq_checks_closed <- dq_ref_clo |>
  left_join(national_ed_tableau_extract_dq,
            by = c("OrgIDProv" = "OrgCode",
                   "ReportingPeriodEndDate" = "Measure Name")) |>
  select(-c(`New referrals`)) |>
  mutate(difference = Closed_Referrals - `Closed referrals`,
         prop_difference = difference / Closed_Referrals)
