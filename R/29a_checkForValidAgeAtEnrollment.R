#' checkForValidAgeAtEnrollment DQ check for CC10 - Check that age
#'
#' @param .dsToCheck The dataset to check
#' @param .codebookVariables The codebook variables for the dataset
#' @param .uniqueKeys The list of unique keys
#' @param .dsName The name of the dataset being checked
#'
#' @returns The results of the check
#' 
#' @importFrom dplyr bind_rows
checkForValidAgeAtEnrollment <- function(.dsName
                                         ,.dsToCheck
                                         ,.codebookVariables
                                         ,.uniqueKeys){
  
  if("age" %in% names(.dsToCheck)){
    .ccCheck10Num <- runNumericRangeChecks(.dsName = .dsName
                                          ,.dsToCheck = .dsToCheck
                                          ,.codebookVariables = .codebookVariables[.codebookVariables$varName == "age",]
                                          ,.uniqueKeys = .uniqueKeys)
    
    .ccCheck10Output <- dplyr::bind_rows(.ccCheck10Num)
  } else{
    .ccCheck10Output = data.frame()
  }
  
  
  .checkOutput <- list(
    "checkId" = "cc10"
    ,"checkTitle" = "Internal consistency between age at enrollment and inclusion criterion"
    ,"checkDescription" = "For Adult registries, confirm that patient was age 18+ at registry enrollment. For Adolescent registries, confirm that the patient meet age requirement for the registry."
    ,"checkShortDescription" = "valid age at enrollment"
    ,"sendCheckToRom" = TRUE
    ,"pass" = ifelse(nrow(.ccCheck10Output) > 0, FALSE, TRUE)
    ,"values" = list(
      "n" = nrow(.ccCheck10Output)
      ,"N" = nrow(.dsToCheck)
      ,"pct" = nrow(.ccCheck10Output) / nrow(.dsToCheck)
    )
    ,"listing" = .ccCheck10Output
  )
  
  return(.checkOutput)
}