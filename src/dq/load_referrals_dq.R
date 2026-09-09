
# Load Referrals Data -----------------------------------------------------

DBI::dbExecute(conn = con,
               statement = read_file(here("src",
                                          "dq",
                                          "referrals_dq.sql")),
               immediate = TRUE)

dq_ref_new <- DBI::dbGetQuery(conn = con,
                              statement = read_file(
                                here("src",
                                     "dq",
                                     "load_referrals_temp_new.sql")))

dq_ref_clo <- DBI::dbGetQuery(conn = con,
                              statement = read_file(
                                here("src",
                                     "dq",
                                     "load_referrals_temp_closed.sql")))

dq_ref_new_all <- DBI::dbGetQuery(conn = con,
                                  statement = read_file(
                                    here("src",
                                         "dq",
                                         "load_referrals_new.sql")))


# Drop Temps --------------------------------------------------------------

DBI::dbExecute(conn = con,
               statement = "DROP TABLE #temp_referrals")
