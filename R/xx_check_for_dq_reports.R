#' check_for_dq_reports Function to check for presence of DQ reports, both excel and html
#'
#' @param base_report_url The url string to the base DQ reports folder
#' @param base_html_report_url The url string for the top level Biostat Data Files folder
#' @param output_url The url string for where I want to save the reports
#' @param year_month Optional; Specific month-year to look up the status; defaults to current month; enter as "YYYY-MM"
#'
#' @return A .csv table recording which registries have completed DQ reports for the current month, saved in the specified output location
#' @export
#' 
#' @importFrom dplyr rowwise mutate case_when ungroup group_by select
#' @importFrom stringr str_detect str_extract
#' 
#' 
#' 
base_report_url <- c("C:/Users/andrew.vancil/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registry Data Quality Reports")
base_html_report_url <- c("C:/Users/andrew.vancil/PPD (CRG)/Biostat Data Files - Registry Data")
output_url <- c("C:/Users/andrew.vancil/PPD (CRG)/Core_Biostat and Epi Team Site - Biostat Registries Data Quality Program/")

check_for_dq_reports <- function(base_report_url, base_html_report_url, output_url, year_month = NULL)
  {
  
  stopifnot(dir.exists(base_report_url))
  stopifnot(dir.exists(base_html_report_url))
  stopifnot(dir.exists(output_url))
  
  dq_folder <- base_report_url
  
  if(lubridate::month(lubridate::today()) < 10) {
    current_month <- paste0("0", lubridate::month(lubridate::today()), sep = "")
  } else {
    current_month <- lubridate::month(lubridate::today())
  }
  
  current_year <- lubridate::year(lubridate::today())
  
  if (exists("year_month")){
    year_month <- year_month
  } else {
    year_month <- glue::glue(current_year, "-", current_month)
  }
  
  dq_reps <- tibble(
    dq_reports = 
      list.files(dq_folder,
                 pattern = year_month,
                 recursive = TRUE)
  ) |> 
    mutate(reg_present = dirname(dirname(dirname(dq_reports))))
  
  reg_tbl <- tibble("registries_to_check" = list.files(dq_folder),
                    "lead" = c("Wendi Malley",
                               "Kaylee Ho",
                               "Ning Guo",
                               "Margaux Crabtree",
                               "Maggie Yu",
                               "Margaux Crabtree",
                               "Paul Lakin",
                               "Ning Guo",
                               "Ying Shan",
                               "Alina Onofrei"))
  
  check_excel_table <- reg_tbl |> 
    left_join(dq_reps, by = c("registries_to_check" = "reg_present")) |> 
    mutate(dq_reports = replace_na(dq_reports, "missing"))
  
  # Test code below to incorporate base_report_url and output_url? I'm not sure if I'm doing this correctly
  # check_dq_html <- function(base_html_report_url, output_url) {
  #   # Checking HTML reports exist in each registry folder on the Biostat Data Files SharePoint site each month
  #   dir.exists(base_report_url)
    
    # Listing out the html report directories
    AA_dir <- glue("{base_html_report_url}/AA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
    AD_dir <- glue("{base_html_report_url}/AD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
    IBD_dir <- glue("{base_html_report_url}/IBD/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
    MS_dir <- glue("{base_html_report_url}/MS/DQ Checks/Reports/ms/{current_year}/{current_year}-{current_month}/")
    NMO_dir <- glue("{base_html_report_url}/NMO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
    PSO_dir <- glue("{base_html_report_url}/PSO/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
    RA_dir <- glue("{base_html_report_url}/RA/DQ Checks/Reports/{current_year}/{current_year}-{current_month}/")
    RAJ_dir <- glue("{base_html_report_url}/RA Japan/DQ Checks/Reports/raj/{current_year}/{current_year}-{current_month}/")
    
    # Vector of registry abbreviations
    reg_list <- c("AA", "AD", "IBD", "MS", "NMO", "PSO", "RA", "RAJ")
    
    # List of registry directories we assigned earlier (add PsA, GPP, and other reg dir later)
    reg_dir <- c(AA_dir, AD_dir, IBD_dir, MS_dir, NMO_dir, PSO_dir, RA_dir, RAJ_dir)
    
    # Generate tibbles for each reg
    dq_html_list <- lapply(reg_dir, function(directory) {
      tibble(
        dq_html_reports = list.files(directory, 
                                     pattern = ".html",
                                     recursive = TRUE)
      )
    })
    
    # Name the list elements for easier access
    names(dq_html_list) <- paste0("dq_html_reports_", tolower(reg_list))
    
  #   return(dq_html_list)
  # }
  
  # Generate tables for each registry
  dq_html_list <- lapply(reg_dir, function(directory) {
    dq_df <- tibble(
      registry = basename(dirname(dirname(dirname(dirname(directory))))),
      dq_html_reports = list.files(directory,
                                   pattern = ".html",
                                   recursive = TRUE))
    # Edit the registry column values for MS and RA Japan to work around them having an extra folder unlike the other registries
    dq_df <- dq_df |>
      mutate(registry = if_else(str_starts(dq_html_reports, "ms"), "MS", registry)) |>
      mutate(registry = if_else(str_starts(dq_html_reports, "raj"), "RAJ", registry)) |>
      group_by(registry) |>
      summarise(dq_html_reports = paste(dq_html_reports, collapse = ", ")) |> # Separate the html reports by a comma if there are multiple per registry
      ungroup()
  })
  
  # Combine all into one table
  combined_dq_html <- bind_rows(dq_html_list)
  
  
  all_reports <- check_excel_table |> 
    left_join(combined_dq_html, by = c("registries_to_check" = "registry")) |> 
    mutate(dq_html_reports = replace_na(dq_html_reports, "missing"))
  
}