# Script for running all processing scripts for the AED population comparison pipeline

library(here)

## Loading necessary packages for processing scripts

source(paste0(here(),"/src/requirements/packages.R"))

## Connects to UDAL

source(paste0(here(),"/src/config/connection.R"))

## Load in the referral and population data

source(paste0(here(),"/src/load/load_referrals.R"))
source(paste0(here(),"/src/load/load_population.R"))

## Process the loaded data

source(paste0(here(),"/src/processing/ref_new_processing.R"))
source(paste0(here(),"/src/processing/population_processing.R"))

## Merge processed data into a single dataframe

source(paste0(here(),"/src/processing/merge_data.R"))

## Generate visuals

source(paste0(here(),"/src/visuals/age_dist.R"))

