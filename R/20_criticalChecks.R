#' Run the critical checks on the specified files
#'
#' @param .dsToCheck A dataframe of the dataset to run the checks on
#' @param .compDsToCheck A dataframe of the dataset to compare the above dataset to
#' @param .listOfEssentialVars A character vector of variables deemed "essential"
#' @param .listOfSupposedVars A character vector of variables that "should" be in the dataset
#' @param .uniqueKeys A character vector of variables that uniquely identify rows in the dataset
#' @param .codebookVariables The codebook variables for the dataset
#' @param .dsName The name of the dataset being checked
#'
#' @returns A list with the results of the critical checks
criticalChecks <- function(.dsToCheck
                            ,.compDsToCheck
                            ,.listOfEssentialVars
                            ,.listOfSupposedVars
                            ,.uniqueKeys
                            ,.codebookVariables
                            ,.dsName){

  # Runs each of the critical checks and stores the results in a variable
  .critCheckResults1 <- checkForDuplicateUniqueIds(.dsToCheck,.uniqueKeys)
  .critCheckResults2 <- checkForOmittedVariables(.dsToCheck,.listOfSupposedVars)
  .critCheckResults3 <- checkForExtraVariables(.dsToCheck,.listOfSupposedVars)
  .critCheckResults4 <- checkForMissingVariableLabels(.dsToCheck)
  .critCheckResults5 <- checkForAddedRows(.dsToCheck,.compDsToCheck)
  .critCheckResults6 <- checkForRemovedRows(.dsToCheck = .dsToCheck,.compDsToCheck = .compDsToCheck,.uniqueKey = .uniqueKeys)

  # Checks if a codebook exists and if not then does not run CC 7 and 8
  if(length(.listOfEssentialVars) > 0){
    .critCheckResults7 <- checkForGivenItemsNonresponse(.dsToCheck,.listOfEssentialVars)
    .critCheckResults8 <- checkForMonthlyMissingness(.dsToCheck,.compDsToCheck,.listOfEssentialVars)  
  } else {
    .critCheckResults7 <- NULL
    .critCheckResults8 <- NULL
  }
  
  .critCheckResults9 <- checkForVariableTypes(.dsToCheck,.codebookVariables)
  .critCheckResults10 <- checkForValidAgeAtEnrollment(.dsName,.dsToCheck,.codebookVariables,.uniqueKeys)
  
  
  # Returns a list with each element being one of the check results
  return(list(
    criticalCheck1 = .critCheckResults1
    ,criticalCheck2 = .critCheckResults2
    ,criticalCheck3 = .critCheckResults3
    ,criticalCheck4 = .critCheckResults4
    ,criticalCheck5 = .critCheckResults5
    ,criticalCheck6 = .critCheckResults6
    ,criticalCheck7 = .critCheckResults7
    ,criticalCheck8 = .critCheckResults8
    ,criticalCheck9 = .critCheckResults9
    ,criticalCheck10 = .critCheckResults10
    )
  )
}
