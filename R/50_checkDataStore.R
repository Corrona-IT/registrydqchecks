#' (internal function) Submit the results of the data quality checks to a set location
#'
#' @param .registry A text string with the initials of the registry (e.g. "ad", "pso", "ms")
#' @param .dsPullDate A date string of the data pull date in YYYY-MM-DD format (e.g. "2024-01-10")
#' @param .dataStoreUrl A text url of the location where the check results will be stored
#' @param .resultsOfChecks A list with the results of the data checks
#' @param .activeSites Information on the list of active sites for this registry
#' @param .dataFolderUrl Folder URL of the current month dataset
#' @param .lastMonthDataFolderUrl Folder URL of the last month dataset
#' @param .timestamp Timestamp that the checks were run
#' @param .folderName Name for the folder where results will be output
#' @param .cdmRomReportUrl (FOLDER URL) A url string to the location of the base CDM/ROM Report folder
#' @param .lastMonthDataPullDate A date string of last month's data pull date in the format YYYY-DD-MM (e.g. "2023-12-05")
#' 
#' @importFrom glue glue
submitToDataStore <- function(.registry
                              ,.dsPullDate
                              ,.timestamp
                              ,.folderName
                              ,.dataStoreUrl
                              ,.resultsOfChecks
                              ,.activeSites
                              ,.dataFolderUrl
                              ,.lastMonthDataFolderUrl
                              ,.cdmRomReportUrl
                              ,.lastMonthDataPullDate
                              ){

  staticDataStoreUrl <- .dataStoreUrl
  
  # Create the folders if they do not exist
  createDataStoreFolder(glue::glue("{.dataStoreUrl}{.folderName}"))
  createDataStoreFolder(glue::glue("{.dataStoreUrl}{.folderName}/checks"))
  createDataStoreFolder(glue::glue("{.dataStoreUrl}{.folderName}/listing"))

  # Assign the dataset name to store
  .resultsCheckName <- glue::glue("{.registry}_{.dsPullDate}_{.timestamp}_checks")

  # Generate runner summary information to output with the checks
  .runnerSummary <- list(
    "registry" = .registry
    ,"timestamp" = .timestamp
    ,"user" = Sys.info()[["user"]]
    ,"folderLoc" = .dataStoreUrl
    ,"pullDate" = .dsPullDate
    ,"dataFolderUrl" = .dataFolderUrl
    ,"lastMonthDataFolderUrl" = .lastMonthDataFolderUrl
  )
  
  # Generate a summary of the check results to output with the check results
  .checkSummary <- generateCheckSummary(.resultsOfChecks = .resultsOfChecks)
  
  # Structure the output to be saved
  .outputToSave <- list(
    "runnerSummary" = .runnerSummary
    ,"checkSummary" = .checkSummary
    ,"criticalChecks" = .resultsOfChecks$criticalCheckOutput
    ,"nonCriticalChecks" = .resultsOfChecks$nonCriticalCheckOutput
  )
  
  # Save the .rds with results of the checks
  saveRDS(.outputToSave,glue::glue("{.dataStoreUrl}{.folderName}/checks/{.resultsCheckName}.rds"))
  
  # Save the listings as Excel files
  thisMonthRomReportUrl = outputListings(.registry = .registry
                                          ,.listingUrl = glue::glue("{.dataStoreUrl}{.folderName}/listing")
                                          ,.yearMonthTimestamp = format(as.Date(.dsPullDate), "%Y-%m")
                                          ,.dataPullDate = .dsPullDate
                                          ,.timestamp = .timestamp
                                          ,.checksToOutput = .outputToSave
                                          ,.activeSites = .activeSites
                                         )
  
  # Create YM timestamp for last month
  .lastYearMonthTimestamp = format(as.Date(.lastMonthDataPullDate), "%Y-%m")
  .lastYear = format(as.Date(.lastMonthDataPullDate), "%Y")
  
  # Create allDqChecks Excel file URL to feed into checkPerpetuation
  lastMonthExcelUrl <- glue::glue("{.cdmRomReportUrl}/{.registry}/{.lastYear}/{.lastYearMonthTimestamp}/{.registry}_{.lastYearMonthTimestamp}_allDqChecks.xlsx")

  
  # Check if allDqChecks file exists from last month
  ### IF Exists - perpetuate comments
  if(file.exists(glue::glue("{lastMonthExcelUrl}"))){
    suppressWarnings({
      perpetuateExcelComments(
        .lastMonthCheckExcelFileUrl = lastMonthExcelUrl
        ,.thisMonthCheckExcelFileUrl = thisMonthRomReportUrl
      )
    })
  } else{
    message("NOTE: There is no allDqChecks Excel file from last month - no comments were carried over")
  }
}
