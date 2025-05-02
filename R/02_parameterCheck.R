




#' Parameter Checks
#'
#' @param .registry 
#' @param .prelimDataFolderUrl 
#' @param .lastMonthDataFolderUrl 
#' @param .codebookUrl 
#' @param .siteInfoUrl 
#' @param .cdmRomReportUrl 
#' @param .outputUrl 
#'
#' @return Print message that all parameters pass
#' @export
#'
#' @examples
#' 
#' .registry = "ra"
#' .prelimDataFolderUrl = "C:/Users/olsonr/PPD (CRG)/Biostat Data Files - RA/DQ checks/Data/2025/2025-04-01/"
#' .lastMonthDataFolderUrl = "C:/Users/olsonr/PPD (CRG)/Biostat Data Files - RA/DQ checks/Data/2025/2025-03-01/"
#' .codebookUrl = "C:/Users/olsonr/PPD (CRG)/Biostat Data Files - RA/DQ checks/Documentations/RA_codebook_2025-04-01.xlsx"
#' .siteInfoUrl = "C:/Users/olsonr/PPD (CRG)/Biostat Data Files - Site and Provider Data/data/site_data_clean.csv"
#' .cdmRomReportUrl = "C:/Users/olsonr/PPD (CRG)/Core_Biostat and Epi Team Site - Documents/Biostat Registry Data Quality Reports"
#' .outputUrl = "C:/Users/olsonr/Documents/Scrap/ra/2025/2025-04/"
#' 
#' paramCheck(.registry = .registry
#' ,.prelimDataFolderUrl = .prelimDataFolderUrl
#' ,.lastMonthDataFolderUrl = .lastMonthDataFolderUrl
#' ,.codebookUrl = .codebookUrl
#' ,.siteInfoUrl = .siteInfoUrl
#' ,.cdmRomReportUrl = .cdmRomReportUrl
#' ,.outputUrl = .outputUrl)



paramCheck <- function(.registry
                       ,.prelimDataFolderUrl
                       ,.lastMonthDataFolderUrl
                       ,.codebookUrl
                       ,.siteInfoUrl
                       ,.cdmRomReportUrl
                       ,.outputUrl) {
  # Check if .registry is one of the valid values
  is_registry <- .registry %in% c("ad", "ms", "ra", "raj", "aa", "pso", "ibd", "nmo")
  if (!is_registry) {
    stop(".registry is not a valid registry")
  }
  
  # Check if the preliminary data folder exists
  prelimDataFolder_exists <- dir.exists(.prelimDataFolderUrl)
  if (!prelimDataFolder_exists) {
    stop(".prelimDataFolderUrl does not exist")
  }
  
  # Check if the last month data folder exists
  lastMonthDataFolder_exists <- dir.exists(.lastMonthDataFolderUrl)
  if (!lastMonthDataFolder_exists) {
    stop(".lastMonthDataFolderUrl does not exist")
  }
  
  # Check if the codebook file exists
  codebook_exists <- file.exists(.codebookUrl)
  if (!codebook_exists) {
    stop(".codebookUrl does not exist")
  }
  
  # Check if the site info file exists
  siteInfo_exists <- file.exists(.siteInfoUrl)
  if (!siteInfo_exists) {
    stop(".siteInfoUrl does not exist")
  }
  
  # Check if the CDM ROM report directory exists
  cdmRomReport_dir_exists <- dir.exists(.cdmRomReportUrl)
  if (!cdmRomReport_dir_exists) {
    stop(".cdmRomReportUrl does not exist")
  }
  
  # Check if the output directory exists
  output_dir_exists <- dir.exists(.outputUrl)
  if (!output_dir_exists) {
    stop(".outputUrl does not exist")
  }
  
  # If all checks pass, proceed with the rest of the function
  return("All parameter checks pass. Proceeding with the rest of the function.")
}


