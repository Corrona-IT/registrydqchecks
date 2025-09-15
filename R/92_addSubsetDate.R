#' addExcelReportSubsetDate Add a subset date to the last column in a dataset called report_subset_date
#'
#' @param .ds The dataset to add the column to
#' @param .subsetDateVariable The checkId to add to the dataset
#'
#' @return The original dataset with .checkId added as the first column
#' @export
addExcelReportSubsetDate <- function(.ds, .subsetDateVariable){
  returnDs <- .ds |>
    dplyr::mutate(report_subset_date = .data[[.subsetDateVariable]])
  
  return(returnDs)
}