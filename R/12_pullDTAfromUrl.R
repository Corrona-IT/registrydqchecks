#' (internal function) Pull a .DTA file from a specified path
#'
#' @param .datasetUrl A url string to the .DTA file being pulled
#' 
#' @returns A dataframe of the file being pulled
#'
#' @export
#' 
#' @importFrom haven read_dta
#' @importFrom glue glue
pullDTAfromUrl <- function(.datasetUrl){
  
  # Print url where the dataset is pulled from
  print(glue::glue("Dataset located at: {.datasetUrl}"))
  
  # Read in the Stata file
  .ds <- haven::read_dta(.datasetUrl)
  
  # Return the file
  return(.ds)
}