#' The main function call to run the CorEvitas Registry DQ Checks and the Report
#'
#' @param .registry A text string with the initials of the specific registry ("ad", "ms", "raj", "aa", "pso", "ibd", "nmo")
#' @param .prelimDataFolderUrl (FOLDER URL) A url string to the FOLDER with the preliminary datasets
#' @param .prelimDataPullDate A date string of the data pull date in the format YYYY-DD-MM (e.g. "2024-01-10")
#' @param .lastMonthDataFolderUrl (FOLDER URL) A url string to the FOLDER with the last month's datasets
#' @param .lastMonthDataPullDate A date string of last month's data pull date in the format YYYY-DD-MM (e.g. "2023-12-05")
#' @param .codebookUrl (FILE URL - .XLSX) A url string to the registry-specific codebook FILE (MUST BE DIRECTLY TO THE .XLSX FILE)
#' @param .siteInfoUrl (FILE URL - .CSV) A Url to the FILE for site/provider data (MUST BE DIRECTLY TO THE site_data_clean.csv FILE)
#' @param .datasetsToCheck A string vector with the names of the datasets to be checked (e.g. c("exvisit", "exlab", "exdrugexp")) - NOTE: These must perfectly match both the tab names in the codebook AND the names of the datasets being checked
#' @param .nonCriticalChecks A list of the manually generated non-critical checks in the CE DQ specified format (see additional documentation)
#' @param .outputUrl (FOLDER URL) A url string to the location of the output datasets - NOTE: A subfolder will be created here called /checks that will house the results of the checks and will be the location called by the check report
#' @param .isR A boolean indicating if the datasets being checked are in R or Stata format (e.g. if R then .isR = TRUE; if Stata then .isR = FALSE)
#' @param .cdmRomReportUrl (FOLDER URL) A url string to the location of the base CDM/ROM Report folder
#'
#' @returns A personalized URL to the location of the report
#'
#' @export
#' 
#' @importFrom glue glue
#' @importFrom dplyr filter select
#' @importFrom registrydqchecksreportdown generateReport


runRegistryChecks <- function(.registry = "defaultRegistry"
                              ,.prelimDataFolderUrl
                              ,.prelimDataPullDate
                              ,.lastMonthDataFolderUrl
                              ,.lastMonthDataPullDate
                              ,.codebookUrl
                              ,.siteInfoUrl = NULL
                              ,.cdmRomReportUrl
                              ,.datasetsToCheck
                              ,.nonCriticalChecks = NULL
                              ,.outputUrl
                              ,.isR){
  

  
  ###############
  #Check parameters
  paramCheck(.registry = .registry
             ,.prelimDataFolderUrl = .prelimDataFolderUrl
             ,.lastMonthDataFolderUrl = .lastMonthDataFolderUrl
             ,.codebookUrl = .codebookUrl
             ,.siteInfoUrl = .siteInfoUrl
             ,.cdmRomReportUrl = .cdmRomReportUrl
             ,.outputUrl = .outputUrl)

  ############################
  # Initialize variable lists to house information on specific datasets being checked
  .codebooks <- list()
  .dataToCheck <- list()
  .dataToCompare <- list()
  .essentialVariables <- list()
  .codebookVariables <- list()
  .uniqueKeys <- list()
  .critCheckOutput <- list()
  .codebookNcOutput <- list()
  .nonCritCheckOutput <- list()
  .ncChecks <- list()
  
  # Define timestamp of this specific datapull
  .timestamp <- format(Sys.time(), "%Y-%m-%d_%H%M")
  .formattedTimestamp <- gsub('[^A-Za-z0-9_]', '_', .timestamp)
  .yearMonthTimestamp = format(as.Date(.prelimDataPullDate), "%Y-%m")
  .folderName = glue::glue("{.registry}_{.yearMonthTimestamp}_DQReport_{.timestamp}")
  .reportOutputUrl = glue::glue("{.outputUrl}{.folderName}/")
  
  createDataStoreFolder(.reportOutputUrl)
  
  validateCodebook(codebookUrl = .codebookUrl
                   ,datasetNames = .datasetsToCheck)
  
  .activeSites <- pullSiteInfoFromExcelFile(.fileUrl = .siteInfoUrl
                                         ,.registry = .registry)
  
  # Loop through each dataset and perform the checks
  for(.dsName in .datasetsToCheck){
    # Pull dataset specific codebook
    .codebooks <- pullCodebookFromExcelFile(.fileUrl = .codebookUrl
                                                       ,.sheetName = .dsName)
    
    # Pull the unique keys for the specific dataset from the codebook
    .uniqueKeys <- .codebooks |>
      dplyr::filter(uniqueKey == 1) |>
      dplyr::select(varName)
    
    # Pull data to check and data from last month to compare it to
    .dataToCheck <- pullData(.datasetUrl = glue::glue("{.prelimDataFolderUrl}{.dsName}_{.prelimDataPullDate}")
                                        ,.isR) |>
      cleanUniqueKeyClasses(uniqueKeyVars = .uniqueKeys)
    
    .dataToCompare <- pullData(.datasetUrl = glue::glue("{.lastMonthDataFolderUrl}{.dsName}_{.lastMonthDataPullDate}")
                                          ,.isR) |>
      cleanUniqueKeyClasses(uniqueKeyVars = .uniqueKeys)

    # Run data_changes report
    data_changes_report <- data_changes(
      curr_dataset = .dataToCheck
      ,comp_dataset = .dataToCompare
      ,by_vars = .uniqueKeys |> dplyr::pull()
      ,output_folder = .reportOutputUrl
      ,output_filename = glue::glue("{.dsName}_data_comparison.xlsx")
      ,title_pagename = .dsName)
    
    # Pull the list of essential variables for the specific dataset from the codebook
    .essentialVariables <- .codebooks |>
      dplyr::filter(essential == 1) |>
      dplyr::select(varName, acceptableMissingness, nonExtremeMissingness, missingnessThresholdMultiplier, skipLogic)
    
    # Pull the codebook noncritical check variables for the specific dataset from the codebook
    .codebookVariables <- .codebooks |>
      dplyr::select(varName, varLabel, essential, calculatedVariable, acceptableMissingness, missingnessThresholdMultiplier, skipLogic, catValues, numRange)
    
    # Run the critical checks on the specific dataset with information pulled from the codebook
    .critCheckOutput[[.dsName]] <- criticalChecks(.dsToCheck = data.frame(.dataToCheck)
                                                  ,.compDsToCheck = data.frame(.dataToCompare)
                                                  ,.listOfEssentialVars = .essentialVariables
                                                  ,.listOfSupposedVars = names(.dataToCompare)
                                                  ,.uniqueKeys = .uniqueKeys$varName
                                                  ,.codebookVariables = .codebookVariables
                                                  ,.dsName = .dsName
                                                  )

    
    # Run the codebook noncritical checks on the specific dataset with information pulled from the codebook
    .codebookNcOutput[[.dsName]] <- codebookNcChecks(.dsName = .dsName
                                                     ,.dsToCheck = data.frame(.dataToCheck)
                                                     ,.compDsToCheck = data.frame(.dataToCompare)
                                                     ,.codebookVariables = .codebookVariables
                                                     ,.uniqueKeys = .uniqueKeys$varName
                                                     )
    
    # Add codebook noncritical checks to the noncritical check output
    # And add manual noncritical checks (if they exist) to the noncritical check output
    .ncChecks[[.dsName]][["codebookChecks"]] <- .codebookNcOutput[[.dsName]]
    
    # If no manual noncritical checks then skip
    # Else - append the results of the manual noncritical checks to the codebook noncritical checks
    if(!is.null(.nonCriticalChecks)){
      for(.checkName in names(.nonCriticalChecks[[.dsName]])){
        .ncChecks[[.dsName]][[.checkName]] <- .nonCriticalChecks[[.dsName]][[.checkName]]
      }
    }
  }
  
  rm(.codebooks, .essentialVariables, .codebookVariables, .dataToCheck, .uniqueKeys, .dataToCompare)

  
  # Create a list of the critical check and the noncritical check output to be saved to a location  
  .checkOutput <- list(
    "criticalCheckOutput" = .critCheckOutput
    ,"nonCriticalCheckOutput" = .ncChecks
  )


  # Submit check results to datastore - including a .rds and Excel files
  submitToDataStore(.registry = .registry
                    ,.dsPullDate = .prelimDataPullDate
                    ,.timestamp = .timestamp
                    ,.folderName = .folderName
                    ,.dataStoreUrl = .outputUrl
                    ,.resultsOfChecks = .checkOutput
                    ,.activeSites = .activeSites
                    ,.dataFolderUrl = .prelimDataFolderUrl
                    ,.lastMonthDataFolderUrl = .lastMonthDataFolderUrl
                    ,.cdmRomReportUrl = .cdmRomReportUrl
                    ,.lastMonthDataPullDate = .lastMonthDataPullDate
                    )
  rm(.checkOutput)
  # Generate the html report
  registrydqchecksreportdown::generateReport(
    .inputDatasetUrl = glue::glue("{.outputUrl}{.folderName}/checks/{.registry}_{.prelimDataPullDate}_{.timestamp}_checks.rds")
    ,.reportOutputUrl = .reportOutputUrl
    ,.fileName = .folderName
  )
  
  print(glue::glue("Report Output Url: {.reportOutputUrl}"))
  return(.reportOutputUrl)
}
