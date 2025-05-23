#' runNumericRangeChecks Run a check to ensure numeric variables fall within an appropriate range
#'
#' @param .dsName The name of the dataset being checked
#' @param .dsToCheck The dataset being checked
#' @param .codebookVariables The codebook variabled needed for this specific check
#' @param .uniqueKeys The unique keys for the dataset being checked
#'
#' @return Results of the check
#' 
#' @importFrom dplyr filter select mutate all_of bind_rows
runNumericRangeChecks <- function(.dsName
                                  ,.dsToCheck
                                  ,.codebookVariables
                                  ,.uniqueKeys){
  
  # Pull off all the numeric variables indicated with a range in the codebook
  .varsToCheck <- .codebookVariables |>
    dplyr::filter(!is.na(numRange)) |>
    dplyr::select(varName, varLabel, calculatedVariable, numRange) |>
    dplyr::mutate(
      numRangeLower = as.numeric(sub("\\[(.*),.*\\]", "\\1", numRange))
      ,numRangeUpper = as.numeric(sub("\\[.*,(.*)\\]", "\\1", numRange))
    )
  
  .numericRangeChecks <- data.frame()
  
  if(nrow(.varsToCheck) == 0){
    return(NULL)
  }
  
  # Loop through each numeric variable and perform the range checks
  for(.varName1 in .varsToCheck$varName){
    tryCatch({
      .currentCheckVar <- .varsToCheck |>
        dplyr::filter(varName == {{.varName1}})
      
      .subsetDsToCheck <- .dsToCheck |>
        dplyr::select(dplyr::all_of(.uniqueKeys), !!.varName1) |>
        dplyr::filter(!is.na(get(.varName1))) |>
        dplyr::filter(get(.varName1) < (.currentCheckVar$numRangeLower - 0.0001) | get(.varName1) > (.currentCheckVar$numRangeUpper + 0.0001)) |>
        dplyr::mutate(
          dataset = .dsName
          ,variableName = .varName1
          ,variableLabel = .currentCheckVar$varLabel
          ,calculatedVariable = .currentCheckVar$calculatedVariable
          ,expectedUpper = .currentCheckVar$numRangeUpper
          ,expectedLower = .currentCheckVar$numRangeLower
          ,numValue = as.numeric(get(.varName1))
        ) |>
        dplyr::select(
          dplyr::all_of(.uniqueKeys), variableLabel, variableName, numValue, expectedLower, expectedUpper, calculatedVariable
        )
      
      .numericRangeChecks <- dplyr::bind_rows(.numericRangeChecks, .subsetDsToCheck) |>
        cleanUniqueKeyClasses(uniqueKeyVars = list(.uniqueKeys))

    }
    ,warning = function(w){
      print(paste("Warning caught:", conditionMessage(w)))
      print(paste("Warning related to variable in codebook - see Warning above:", .varName1))
    }
    ,error = function(e){
      print(paste("Error caught:", conditionMessage(e)))
      print(paste("Warning related to variable in codebook - see Warning above:", .varName1))
    }
    )
    
  }

  return(.numericRangeChecks)
}

