
# UDAL Data Lake ----------------------------------------------------------

con <- DBI::dbConnect(drv = odbc::odbc(),
                      driver = "ODBC Driver 18 for SQL Server",
                      server = "udalsyndataprod.sql.azuresynapse.net",
                      database = "UDAL_Warehouse",
                      authentication = "ActiveDirectoryInteractive")
