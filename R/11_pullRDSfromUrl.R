#' (internal function) Pull a .RDS file from a specified path
#'
#' @param .datasetUrl A url string to the .RDS file being pulled
#' 
#' @returns A dataframe of the file being pulled
#'
#' @export
#' 
#' @importFrom glue glue
pullRDSfromUrl <- function(.datasetUrl){
  
  # Print url where the dataset is pulled from
  print(glue::glue("Dataset located at: {.datasetUrl}"))
  
  # Read in the R dataset file
  .ds <- readRDS(.datasetUrl)
  
  # Return the file
  return(.ds)
}
