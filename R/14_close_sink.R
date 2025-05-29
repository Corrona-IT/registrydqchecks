#' close sink file
#'
#' @param registry_abbrev registry abbreviation (ie. "aa")
#' @param output_location report output location (ie. reportLocationUrl)
#' @param temp_log_file The temporary log file to print out to the output location
#'
#' @returns saved console_output.txt file in the output location folder
#' @export
#'
close_sink <- function(temp_log_file, registry_abbrev, output_location){
  sink()
  closeAllConnections()
  
  final_log_file <- file.path(output_location, glue::glue("{registry_abbrev}_console_output.txt"))
  file.copy(temp_log_file, final_log_file, overwrite = TRUE)
  file.remove(temp_log_file)
}