

# DQ Packages -------------------------------------------------------------

dq_packages <- c("readxl",
                   "here",
                   "odbc",
                   "DBI",
                   "readr",
                   "dplyr",
                   "tidyr",
                   "ggplot2")

# load_packages function --------------------------------------------------

load_packages <- function(packages){
  
  missing_packages <- setdiff(packages, installed.packages()[,"Package"])
  
  if (length(missing_packages) > 0) {
    install.packages(missing_packages)
  }
  
  lapply(packages, function(pkg) {
    library(pkg, character.only = TRUE)
  })
  
}

load_packages(dq_packages)
