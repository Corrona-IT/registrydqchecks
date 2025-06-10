#' Parameter Checks
#'
#' @param .registry The registry abbreviation
#' @param .prelimDataFolderUrl The folder URL of the data
#' @param .lastMonthDataFolderUrl The folder URL of last month's data
#' @param .codebookUrl The URL to the codebook
#' @param .siteInfoUrl The URL to the site_info_clean.csv file
#' @param .cdmRomReportUrl The CDM/ROM report URL
#' @param .outputUrl The output URL
#'
#' @return Print message that all parameters pass
#' @export

paramCheck <- function(.registry
                       ,.prelimDataFolderUrl
                       ,.lastMonthDataFolderUrl
                       ,.codebookUrl
                       ,.siteInfoUrl
                       ,.cdmRomReportUrl
                       ,.outputUrl) {
  # Check if .registry is one of the valid values
  is_registry <- .registry %in% c("ad", "ms", "ra", "raj", "aa", "pso", "ibd", "nmo","gpp")
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
  
  # # Check if the output directory exists
  # output_dir_exists <- dir.exists(.outputUrl)
  # if (!output_dir_exists) {
  #   stop(".outputUrl does not exist")
  # }
  
  # If all checks pass, proceed with the rest of the function
  return("All parameter checks pass. Proceeding with the rest of the function.")
}


