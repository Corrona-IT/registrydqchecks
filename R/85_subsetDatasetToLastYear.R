#' subsetDatasetToLastYear Function to subset dataset to last year for given date variables
#'
#' @param .dataset The dataset to subset
#' @param .timeVar1 The primary time variable to check for
#' @param .timeVar2 The secondary variable to check for
#' @param .dataPullDate The date of the current datapull
#'
#' @importFrom lubridate %m-%
#'
#' @return The subset dataset
#' @export
subsetDatasetToLastYear <- function(.dataset, .timeVar1, .timeVar2, .dataPullDate) {
  .comparisonDate <- as.Date(.dataPullDate) %m-% lubridate::years(1)
  message(.comparisonDate, " is the comparison date")
  
  if (.timeVar1 %in% colnames(.dataset)) {
    # Use variable1 to subset dataset if it exists
    subset <- .dataset[as.Date(.dataset[[.timeVar1]]) > .comparisonDate, ]
    message("NOTE: Using ", .timeVar1, " to subset the dataset")
    return(subset)
  } else if (.timeVar2 %in% colnames(.dataset)) {
    # Use variable2 to subset dataset if variable1 does not exist but variable2 exists
    subset <- .dataset[as.Date(.dataset[[.timeVar2]]) > .comparisonDate, ]
    message("NOTE: Using ", .timeVar2, " to subset the dataset")
    return(subset)
  } else if ("report_subset_date" %in% colnames(.dataset)) {
    # Use report_subset_date to subset dataset if variable1 and variable2 do not exist but report_subset_date exists
    subset <- .dataset[as.Date(.dataset[[report_subset_date]]) > .comparisonDate, ]
    message("NOTE: Using ", report_subset_date, " to subset the dataset")
    return(subset)
  } else {
    # Log an error if neither variable1 nor variable2 exist in datasetA
    message("NOTE: neither ", .timeVar1, " nor ", .timeVar2, " nor report_subset_date exist in this dataset. No subsetting was done on the dataset")
    return(.dataset)  # Return the original dataset without subsetting
  }
}