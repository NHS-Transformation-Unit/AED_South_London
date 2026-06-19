
# Load Referrals Data -----------------------------------------------------

DBI::dbExecute(conn = con,
               statement = read_file(here("src",
                                          "extract_queries",
                                          "referrals.sql")),
               immediate = TRUE)


ref_new <- DBI::dbGetQuery(conn = con,
                           statement = read_file(
                             here("src",
                                  "extract_queries",
                                  "new_referrals.sql")))

ref_con_flag <- DBI::dbGetQuery(conn = con,
                                statement = read_file(
                                  here("src",
                                       "extract_queries",
                                       "condition_flag.sql")))

ref_prim_flag <- DBI::dbGetQuery(conn = con,
                                 statement = read_file(
                                   here("src",
                                        "extract_queries",
                                        "prim_diag_flag.sql")))

ref_sec_flag <- DBI::dbGetQuery(conn = con,
                                statement = read_file(
                                  here("src",
                                       "extract_queries",
                                       "sec_diag_flag.sql")))


# Drop Temps --------------------------------------------------------------

DBI::dbExecute(conn = con,
               statement = "DROP TABLE #temp_new_refs")

DBI::dbExecute(conn = con,
               statement = "DROP TABLE #temp_new_refs_diags")

#DBI::dbExecute(conn = con,
#               statement = "DROP TABLE #temp_new_refs_005flag")

#DBI::dbExecute(conn = con,
#               statement = "DROP TABLE #temp_new_refs_primflag")

#DBI::dbExecute(conn = con,
#               statement = "DROP TABLE #temp_new_refs_secflag")
