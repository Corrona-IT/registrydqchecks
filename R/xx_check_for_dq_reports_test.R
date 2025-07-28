library(dplyr)
library(glue)
library(stringr)
library(devtools)

base_report_url <- "C:/Users/andrew.vancil/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registry Data Quality Reports/"
base_html_report_url <- "C:/Users/andrew.vancil/PPD (CRG)/Biostat Data Files - Registry Data/"
output_url <- "C:/Users/andrew.vancil/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registries Data Quality Program"

base_report_url <- "C:/Users/lina.li2/Thermo Fisher Scientific/Core_Biostat and Epi Team Site - Biostat Registry Data Quality Reports/"
base_html_report_url <- "C:/Users/lina.li2/PPD (CRG)/Biostat Data Files - Registry Data/"
output_url <- "C:/Users/lina.li2/Thermo Fisher Scientific/Core_Biostat and Epi Team Site - Biostat Registries Data Quality Program/"
dir.exists(output_url)

source("xx_check_for_dq_reports.R")

# Call function check_for_dq_reports for current month
check_for_dq_reports(
  base_report_url,
  base_html_report_url,
  output_url
)

# assign a year-month date of interest
check_for_dq_reports(
  base_report_url,
  base_html_report_url,
  output_url, 
  year_month = "2025-06"
)
