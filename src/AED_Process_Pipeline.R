# Script for running all processing scripts for the AED population comparison pipeline

install.packages("here")
library(here)

## Loading necessary packages for processing scripts

source(paste0(here(),"/src/requirements/packages.R"))

## Connects to UDAL

source(paste0(here(),"/src/config/connection.R"))

## Load in the referral and population data

source(paste0(here(),"/src/load/load_referrals.R"))
# source(paste0(here(),"/src/load/load_rds.R"))
source(paste0(here(),"/src/load/load_population.R"))
source(paste0(here(),"/src/load/load_deprivation.R"))

## Process the loaded data
source(paste0(here(),"/src/config/palette.R"))
source(paste0(here(),"/src/config/tu_ggplot_theme.R"))

source(paste0(here(),"/src/processing/ref_new_processing.R"))
source(paste0(here(),"/src/processing/population_processing.R"))
source(paste0(here(),"/src/processing/deprivation_processing.R"))

## Merge processed data into  single data frames for each exploration area

source(paste0(here(),"/src/processing/merge_data.R"))

## Generate visuals

source(paste0(here(),"/src/visuals/age_dist.R"))
source(paste0(here(),"/src/visuals/diag_dist.R"))
source(paste0(here(),"/src/visuals/dep_dist.R"))
source(paste0(here(),"/src/visuals/eth_dist.R"))

