#' Check the missingness for the given items
#'
#' @param .dsToCheck A dataframe to check
#' @param .listOfEssentialVars A character vector with the variables deemed "essential"
#'
#' @returns A list with pass/fail, and a dataframe with the information on the missingness for those variables
#' 
#' @importFrom dplyr bind_rows filter arrange mutate desc
checkForGivenItemsNonresponse <- function(.dsToCheck, .listOfEssentialVars){
  
  # Initialize the dataframe that will be returned
  .listOfVarMissingness <- data.frame(
    "varName" = character()
    ,"nMissingThisMonth" = integer()
    ,"nRowsThisMonth" = integer()
    ,"propMissingThisMonth" = numeric()
    ,"pctMissingThisMonth" = numeric()
    ,"acceptableMissingness" = numeric()
    ,"nonExtremeMissingness" = numeric()
    ,"missingnessThresholdMultiplier" = numeric()
    ,"skipLogic" = character()
  )
  
  
  .listOfObsMissingVars <- data.frame(
    "subject_id" = character() 
    ,"varName" = character()
    , stringsAsFactors = FALSE)
  
  
  # Loop through the given variables and add a row to the dataframe
  for(.var in .listOfEssentialVars$varName){
    
    .currEssentialVariable <- .listOfEssentialVars |>
      dplyr::filter(varName == .var)

    tryCatch({
      if(is.na(.currEssentialVariable$skipLogic)){
        .nRows <- nrow(.dsToCheck)
        .nMissing <-
          sum(is.na(.dsToCheck[[.var]]))
        # Identify rows with missing values
        .missingRow <- .dsToCheck[is.na(.dsToCheck[[.var]]), ]
        
      } else {
        .subsetDsToCheck <- .dsToCheck |>
          dplyr::filter(eval(parse(text = .currEssentialVariable$skipLogic)))
        .nRows <- nrow(.subsetDsToCheck)
        .nMissing <-
          sum(is.na(.subsetDsToCheck[[.var]]))
        # Identify rows with missing values
        .missingRow <- .subsetDsToCheck[is.na(.subsetDsToCheck[[.var]]), ]
      }
      
      .propMissing = round(.nMissing / .nRows, digits = 3)
      
    }, error = function(e){
      .nRows <- NA
      .nMissing <- NA
      .propMissing <- NA
      .missingRows <- NA
      
      print(.var)
      print(paste0("Error occurred while evaluating expression: ", .currEssentialVariable$skipLogic))
    })
    
    # Build the row to add to the html dataframe
    .varMissingRow <- data.frame(
      "varName" = .var
      ,"nMissingThisMonth" = .nMissing
      ,"nRowsThisMonth" = .nRows
      ,"propMissingThisMonth" = .propMissing
      ,"pctMissingThisMonth" = round(100*.propMissing, digits = 2)
      ,"acceptableMissingness" = 100 * .currEssentialVariable$acceptableMissingness
      ,"nonExtremeMissingness" = 100 * .currEssentialVariable$nonExtremeMissingness
      ,"missingnessThresholdMultiplier" = .currEssentialVariable$missingnessThresholdMultiplier
      ,"skipLogic" = .currEssentialVariable$skipLogic
      )
    
    .listOfVarMissingness <- dplyr::bind_rows(.listOfVarMissingness,.varMissingRow)
    
    # Build the row to add to the observation level dataframe
    
    # Check if .missingRow is not empty before adding to .listOfObsMissingVars
    if (nrow(.missingRow) > 0) {
      .obsMissingRow <- data.frame(
        "subject_id" =  .missingRow[[.listOfEssentialVars$varName[1]]],
        "varName" = .var,
        stringsAsFactors = FALSE
      )
      
      .listOfObsMissingVars <- dplyr::bind_rows(.listOfObsMissingVars, .obsMissingRow)
    }}


  # Reorder the listing output to be sorted in descending order by amount of missingness
  .listOfVarMissingness <- .listOfVarMissingness |>
    dplyr::arrange(dplyr::desc(propMissingThisMonth)) |>
    dplyr::mutate(
      passMissing = ifelse(propMissingThisMonth < nonExtremeMissingness, TRUE, FALSE)
    ) |>
    dplyr::filter(passMissing == FALSE)
  
  # Define output list structure
  .returnOutput <- list(
    "checkId" = "cc7"
    ,"checkTitle" = "Item nonresponse for essential variables is not extreme"
    ,"checkDescription" = "Confirm that item nonresponse for essential variables is below a specified threshold."
    ,"checkShortDescription" = "item missingness"
    ,"sendCheckToRom" = FALSE
    ,"pass" = ifelse(nrow(.listOfVarMissingness) > 0, FALSE, TRUE)
    ,"essentialVariablesMissingness" = .listOfVarMissingness
    ,"listOfObsMissingVars" = .listOfObsMissingVars
  )
  
  return(.returnOutput)
}