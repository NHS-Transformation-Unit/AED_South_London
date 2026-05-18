
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
                                  "load_referrals.sql")))


# Drop Temps --------------------------------------------------------------

DBI::dbExecute(conn = con,
               statement = "DROP TABLE #temp_referrals")
