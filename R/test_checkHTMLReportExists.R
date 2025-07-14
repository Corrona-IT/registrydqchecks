# Checking HTML reports exist in each registry folder on the Biostat Data Files SharePoint site each month
library(tidyverse)
library(tibble)
library(glue)

# Obtain current year and month - Andrew's code
if(lubridate::month(lubridate::today()) < 10) {
  current_month <- paste0("0", lubridate::month(lubridate::today()), sep = "")
} else {
  current_month <- lubridate::month(lubridate::today())
}

current_year <- lubridate::year(lubridate::today())

# Assigning dir
base_report_url <- "C:/Users/andrew.vancil/PPD (CRG)/Biostat Data Files - Registry Data"
base_report_url <- "C:/Users/lina.li2/PPD (CRG)/Biostat Data Files - Registry Data"
output_url <- "C:/Users/lina.li2/OneDrive - Thermo Fisher Scientific/Documents/Registry/Test"


# Listing out the html reports that exist for the month of interest
AA_dir <-  glue::glue("{bdf_folder}/AA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
AD_dir  <-  glue::glue("{bdf_folder}/AD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
IBD_dir  <- glue::glue("{bdf_folder}/IBD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
MS_dir  <-  glue::glue("{bdf_folder}/MS/DQ Checks/Reports/ms/{current_year}/{current_year}-{current_month}/")
NMO_dir  <- glue::glue("{bdf_folder}/NMO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
PSO_dir  <- glue::glue("{bdf_folder}/PSO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
RA_dir  <-  glue::glue("{bdf_folder}/RA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
RAJ_dir  <- glue::glue("{bdf_folder}/RA Japan/DQ Checks/Reports/raj/{current_year}/{current_year}-{current_month}/")

# Create a function
check_dq_html <- function(directory) {
  tibble(
    dq_html_reports = list.files(directory, 
                                 pattern = ".html",
                                 recursive = TRUE)
  )
}

# List of registries
reg_list <- c("AA", "AD", "IBD", "MS", "NMO", "PSO", "RA", "RAJ")

# List of registry directories with DQ checks reports (add PsA, GPP, and other reg later)
reg_dir <- c(AA_dir, AD_dir, IBD_dir, MS_dir, NMO_dir, PSO_dir, RA_dir, RAJ_dir)

# Generate tibbles for each directory
dq_html_list <- lapply(reg_dir, check_dq_html)

# Optionally, name the list elements for easier access
names(dq_html_list) <- paste0("dq_html_reports_", tolower(reg_list))

# Print the results - do we want to output this in Excel?
dq_html_list

writexl::write_xlsx(dq_html_list, "C:/Users/lina.li2/OneDrive - Thermo Fisher Scientific/Documents/Registry/Test/dq_html_list.xlsx")



# Test code below to incorporate base_report_url and output_url
check_dq_html <- function(base_report_url, output_url) {
  # Checking HTML reports exist in each registry folder on the Biostat Data Files SharePoint site each month
  dir.exists(base_report_url)
  
  # Listing out the html reports that exist for the month of interest
  AA_dir <- glue("{base_report_url}/AA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
  AD_dir <- glue("{base_report_url}/AD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
  IBD_dir <- glue("{base_report_url}/IBD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
  MS_dir <- glue("{base_report_url}/MS/DQ Checks/Reports/ms/{current_year}/{current_year}-{current_month}/")
  NMO_dir <- glue("{base_report_url}/NMO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
  PSO_dir <- glue("{base_report_url}/PSO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
  RA_dir <- glue("{base_report_url}/RA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
  RAJ_dir <- glue("{base_report_url}/RA Japan/DQ Checks/Reports/raj/{current_year}/{current_year}-{current_month}/")
  
  # List of registries
  reg_list <- c("AA", "AD", "IBD", "MS", "NMO", "PSO", "RA", "RAJ")
  
  # List of registry directories with DQ checks reports (add PsA, GPP, and other reg later)
  reg_dir <- c(AA_dir, AD_dir, IBD_dir, MS_dir, NMO_dir, PSO_dir, RA_dir, RAJ_dir)
  
  # Generate tibbles for each directory
  dq_html_list <- lapply(reg_dir, function(directory) {
    tibble(
      dq_html_reports = list.files(directory, 
                                   pattern = ".html",
                                   recursive = TRUE)
    )
  })
  
  # Optionally, name the list elements for easier access
  names(dq_html_list) <- paste0("dq_html_reports_", tolower(reg_list))
  
  # Print the results - do we want to output this in Excel?
  writexl::write_xlsx(dq_html_list, glue("{output_url}/dq_html_list.xlsx"))
  
  return(dq_html_list)
}

# Generate tables for each registry
dq_html_list <- lapply(reg_dir, function(directory) {
  # Extract the registry name from the directory path
  path_parts <- strsplit(directory, "/")[[1]]
  registry_name <- path_parts[length(path_parts) - 4]
  
  tibble(
    registry = registry_name,
    dq_html_reports = list.files(directory, 
                                 pattern = ".html",
                                 recursive = TRUE)
  )
})

# Test below - error with MS and RAJ having an extra folder that the other reg don't have
dq_html_list <- lapply(reg_dir, function(directory) {
  tibble(
    registry = basename(dirname(dirname(dirname(dirname(directory))))),
    dq_html_reports = list.files(directory,
                                 pattern = ".html",
                                 recursive = TRUE)
  )
})

# Combine all into one table
combined_dq_html <- bind_rows(dq_html_list)

# An example of what it would look like if included as a function in the registrydqchecks package
library(registrydqchecks)
Test <- check_dq_html(
  base_report_url = "C:/Users/lina.li2/PPD (CRG)/Biostat Data Files - Registry Data"
  ,output_url = "C:/Users/lina.li2/OneDrive - Thermo Fisher Scientific/Documents/Registry/Test")

