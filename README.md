<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

# South London Partnerships - Adult Eating Disorders analysis

This repository contains the code to analyse the Adult Eating Disorders requiring a Tier 3 service relative to the South London population.

## Repository Structure

The current structure of the repository is detailed below:

``` plaintext
├───LICENSE
├───README.md
├───data
    ├───reference_data
    └───rds
├───images
└───src
    ├───config
    ├───dq
    ├───extract_queries
    ├───load
    ├───outputs
    ├───processing
    ├───requirements
    └───visuals

```

### data
Contains the reference data and rds static file, when saved, to run outputs from rather than extracting fresh data from MHSDS.

### images
Contains the TU logo and data flow diagram for outputs.

### src
Contains the files for the analysis of population vs referrals:

- `config`: Contains css file, palette, plot theme and connections to the data lake.
- `dq`: Contains the initial data quality checks.
- `extract_queries`: Contains the files that are run in the data lake.
- `loads`: Contains the files that load the data from the data lake into data frames in R.
- `outputs`: Contains the `.qmd` files to render the analysis and the download function that makes visuals in the `.qmd` downloadable.
- `processing`: Contains the files that process the reference data and extracted data into usable data frames for the analysis.
- `requirements`: Contains the files that install the packages required to run the analysis and the data quality checks.
- `visuals`: Contains the files that use processed data frames to create plots and data tables for the analysis.

The `AED_Process_Pipeline.R` file that is in the `src` folder runs the files within the sub-folders in the correct order for this analysis.


## Contributors
This repository has been created and developed by:

- [Simon Wickham](https://github.com/SiWickham)
- [Andy Wilson](https://github.com/ASW-Analyst)
