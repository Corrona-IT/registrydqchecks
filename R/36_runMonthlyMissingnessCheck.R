#' runMonthlyMissingnessCheck Run a check to look at amount of month-to-month missingness for all variables
#'
#' @param .dsToCheck The dataset to run the checks on
#' @param .compDsToCheck The dataset from last month to compare to
#' @param .codebookVariables The codebook-specific variables needed for this check
#'
#' @return Results of the check
#' 
#' @importFrom dplyr filter select bind_rows arrange mutate
runMonthlyMissingnessCheck <- function(.dsToCheck, .compDsToCheck, .codebookVariables){
  
  .nonEssentialVariables <- .codebookVariables |>
    dplyr::filter(is.na(essential) | essential != 1) |>
    dplyr::filter() |>
    dplyr::select(varName, acceptableMissingness, missingnessThresholdMultiplier, skipLogic)
  
  # Initialize the dataframe that will be returned
  .listOfVarMissingness <- data.frame(
    "varName" = character()
    ,"nMissingThisMonth" = integer()
    ,"nRowsThisMonth" = integer()
    ,"propMissingThisMonth" = numeric()
    ,"pctMissingThisMonth" = numeric()
    ,"nMissingLastMonth" = integer()
    ,"nRowsLastMonth" = integer()
    ,"propMissingLastMonth" = numeric()
    ,"pctMissingLastMonth" = numeric()
    ,"acceptableMissingness" = numeric()
    ,"skipLogic" = character()
  )
  
  # Loop through the given variables and add a row to the dataframe
  for(.var in .nonEssentialVariables$varName){
    
    .currNonessentialVariable <- .nonEssentialVariables |>
      dplyr::filter(varName == .var)
    
    tryCatch({
      
      # Generate the number of rows, the number of missing, and the proportion for the check dataset
      if(is.na(.currNonessentialVariable$skipLogic)){
        .nRows <- nrow(.dsToCheck)
        .nMissing <-
          sum(is.na(.dsToCheck[[.var]]))
      } else {
        .subsetDsToCheck <- .dsToCheck |>
          dplyr::filter(eval(parse(text = .currNonessentialVariable$skipLogic)))
        .nRows <- nrow(.subsetDsToCheck)
        .nMissing <-
          sum(is.na(.subsetDsToCheck[[.var]]))
      }
      
      .propMissing = round(.nMissing / .nRows, digits = 3)
      
      # Generate the number of rows, the number of missing, and the proportion for the comparator dataset
      if(is.na(.currNonessentialVariable$skipLogic)){
        .nRowsComp <- nrow(.compDsToCheck)
        .nMissingComp <-
          sum(is.na(.compDsToCheck[[.var]]))
      } else {
        .subsetDsToCheck <- .compDsToCheck |>
          dplyr::filter(eval(parse(text = .currNonessentialVariable$skipLogic)))
        .nRowsComp <- nrow(.subsetDsToCheck)
        .nMissingComp <-
          sum(is.na(.subsetDsToCheck[[.var]]))
      }
      
      .propMissingComp = round(.nMissingComp / .nRowsComp, digits = 3)
      
    }, error = function(e){
      .nRows <- NA
      .nMissing <- NA
      .propMissing <- NA
      
      .nRowsComp <- NA
      .nMissingComp <- NA
      .propMissingComp <- NA
      print(.var)
      print(paste0("Error occurred while evaluating expression: ", .currNonessentialVariable$skipLogic))
    })
    
    
    
    # Build the row to add to the dataframe
    .varMissingRow <- data.frame(
      "varName" = .var
      ,"nMissingThisMonth" = .nMissing
      ,"nRowsThisMonth" = .nRows
      ,"propMissingThisMonth" = .propMissing
      ,"pctMissingThisMonth" = round(100 * .propMissing, digits = 2)
      ,"nMissingLastMonth" = .nMissingComp
      ,"nRowsLastMonth" = .nRowsComp
      ,"propMissingLastMonth" = .propMissingComp
      ,"pctMissingLastMonth" = round(100 * .propMissingComp, digits = 2)
      ,"acceptableMissingness" = 100 * .currNonessentialVariable$acceptableMissingness
      ,"skipLogic" = .currNonessentialVariable$skipLogic
    )
    
    .listOfVarMissingness <- dplyr::bind_rows(.listOfVarMissingness,.varMissingRow)
  }
  
  # Reorder the listing output to be sorted in descending order by amount of missingness
  .listOfVarMissingness <- .listOfVarMissingness |>
    dplyr::arrange(dplyr::desc(propMissingThisMonth)) |>
    dplyr::mutate(
      passMissing = ifelse(abs(propMissingThisMonth - propMissingLastMonth) <= (acceptableMissingness * 3), TRUE, FALSE)
    ) |>
    dplyr::filter(passMissing == FALSE)
  
  
  .checkOutput <- list(
    "checkId" = "nc4"
    ,"checkTitle" = "MoM (month over month) change in item nonresponse is reasonable for non-essential variables"
    ,"checkDescription" = "Confirm that the jump in item nonresponse from prior month to current month for non-essential variables is below a prespecified threshold."
    ,"checkShortDescription" = "general month to month missingness"
    ,"sendCheckToRom" = FALSE
    ,"highPriority" = FALSE
    ,"pass" = ifelse(nrow(.listOfVarMissingness) > 0, FALSE, TRUE)
    ,"values" = list(
      "n" = nrow(.listOfVarMissingness)
      ,"N" = NA
      ,"pct" = NA
    )
    ,"listing" = .listOfVarMissingness
  )
  
  return(.checkOutput)
}