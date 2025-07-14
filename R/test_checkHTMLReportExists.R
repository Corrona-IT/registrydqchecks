library(tidyverse)
library(tibble)

# Obtain current year and month - Andrew's code
if(lubridate::month(lubridate::today()) < 10) {
  current_month <- paste0("0", lubridate::month(lubridate::today()), sep = "")
} else {
  current_month <- lubridate::month(lubridate::today())
}

current_year <- lubridate::year(lubridate::today())

# Checking HTML reports exist in each registry folder on the Biostat Data Files SharePoint site each month
bdf_folder <- c("C:/Users/andrew.vancil/PPD (CRG)/Biostat Data Files - Registry Data")
bdf_folder <- c("C:/Users/lina.li2/PPD (CRG)/Biostat Data Files - Registry Data")
dir.exists(bdf_folder)

# Listing out the html reports that exist for the month of interest
AA_dir <-  glue::glue("{bdf_folder}/AA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
AD_dir  <-  glue::glue("{bdf_folder}/AD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
IBD_dir  <- glue::glue("{bdf_folder}/IBD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
MS_dir  <-  glue::glue("{bdf_folder}/MS/DQ Checks/Reports/ms/{current_year}/{current_year}-{current_month}/")
NMO_dir  <- glue::glue("{bdf_folder}/NMO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
PSO_dir  <- glue::glue("{bdf_folder}/PSO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
RA_dir  <-  glue::glue("{bdf_folder}/RA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
RAJ_dir  <- glue::glue("{bdf_folder}/RAJ/DQ Checks/Reports/raj/{current_year}/{current_year}-{current_month}/")


# Create a function
check_dq_html <- function(directory) {
  tibble(
    dq_html_reports = list.files(directory, 
                                 pattern = ".html",
                                 recursive = TRUE)
  )
}

# List of registries with DQ checks reports (add PsA, GPP, and other reg later)
reg_list <- c(AA_dir, AD_dir, IBD_dir, MS_dir, NMO_dir, PSO_dir, RA_dir, RAJ_dir)

# Generate tibbles for each directory
dq_html_list <- lapply(reg_list, check_dq_html)

# Optionally, name the list elements for easier access
names(dq_html_list) <- paste0("dq_html_", tolower(reg_list))

# Print the results - do we want to output this in Excel?
dq_html_list
