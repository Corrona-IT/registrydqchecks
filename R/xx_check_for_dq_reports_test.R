library(dplyr)
library(stringr)
library(glue)

setwd("C:/Users/lina.li2/OneDrive - Thermo Fisher Scientific/Documents/GitHub/registrydqchecks/R")

base_report_url <- "C:/Users/andrew.vancil/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registry Data Quality Reports/"
base_html_report_url <- "C:/Users/andrew.vancil/PPD (CRG)/Biostat Data Files - Registry Data/"
output_url <- "C:/Users/andrew.vancil/OneDrive - Thermo Fisher Scientific/Documents/tests/"

base_report_url <- "C:/Users/lina.li2/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registry Data Quality Reports/"
base_html_report_url <- "C:/Users/lina.li2/PPD (CRG)/Biostat Data Files - Registry Data/"
output_url <- "C:/Users/lina.li2/OneDrive - Thermo Fisher Scientific/Documents/DQ Program WG/"
# output_url <- "C:/Users/lina.li2/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registries Data Quality Program"

source("xx_check_for_dq_reports.R")

# Call function check_for_dq_reports and assign a year_month date of interest 
check_for_dq_reports(
  base_report_url,
  base_html_report_url,
  output_url, 
  year_month = "2025-06"
)
