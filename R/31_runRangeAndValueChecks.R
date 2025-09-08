#' runRangeAndValueChecks Run nc1 which checks the numeric and categorical variables against their supposed values
#'
#' @param .dsName The name of the dataset being checked
#' @param .dsToCheck The dataset to run the checks on
#' @param .codebookVariables The codebook variables for this specific check
#' @param .uniqueKeys The unique keys for the dataset being checked
#'
#' @return The results of the numeric range and categorical value checks
#' 
#' @importFrom dplyr bind_rows arrange relocate last_col
#' @importFrom glue glue
runRangeAndValueChecks <- function(.dsName
                                   ,.dsToCheck
                                   ,.codebookVariables
                                   ,.uniqueKeys){

  .ncCheck1Num <- runNumericRangeChecks(.dsName = .dsName
                                        ,.dsToCheck = .dsToCheck
                                        ,.codebookVariables = .codebookVariables
                                        ,.uniqueKeys = .uniqueKeys)
  .ncCheck1Cat <- runCategoricalValueChecks(.dsName = .dsName
                                            ,.dsToCheck = .dsToCheck
                                            ,.codebookVariables = .codebookVariables
                                            ,.uniqueKeys = .uniqueKeys)
  
  .ncCheck1Output <- dplyr::bind_rows(.ncCheck1Num, .ncCheck1Cat) |>
    dplyr::arrange(variableName) |>
    addCheckId(glue::glue("nc1_{.dsName}")) |>
    dplyr::relocate("calculatedVariable", .after = dplyr::last_col())

  .columnsToReplace <- c("expectedValue", "expectedLabels")
  .ncCheck1Output <- replaceNullWithNa(.ncCheck1Output, .columnsToReplace)
  
  .checkOutput <- list(
    "checkId" = "nc1"
    ,"checkTitle" = "Values of numeric variables are within expected ranges and categorical variables are within expected levels"
    ,"checkDescription" = "Confirm that values fall within a prespecified range (for continuous variables) or within a prespecified list of values (for discrete variables)."
    ,"checkShortDescription" = "numeric and categorical value checks"
    ,"sendCheckToRom" = TRUE
    ,"highPriority" = FALSE
    ,"pass" = ifelse(nrow(.ncCheck1Output) > 0, FALSE, TRUE)
    ,"values" = list(
      "n" = nrow(.ncCheck1Output)
      ,"N" = NA
      ,"pct" = NA
    )
    ,"listing" = .ncCheck1Output
  )
  
  return(.checkOutput)
}



#' replaceNullWithNa Replace NULL values with NA in specified columns of a dataframe
#'
#' @param df A dataframe in which to replace NULL values
#' @param columns A vector of column names or indices where NULL values should be replaced with NA
#'
#' @return The dataframe with NULL values replaced with NA in the specified columns
#' 
#' @importFrom dplyr mutate_at
replaceNullWithNa <- function(df, columns) {
  df <- df |>
    dplyr::mutate(dplyr::across(dplyr::all_of(columns),
                    ~ vapply(as.list(.x),
                    \(y) if (is.null(y)) NA_character_ else paste(y, collapse = ","),
                    character(1))))
  return(df)
}