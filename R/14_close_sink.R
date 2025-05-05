#' close sink file
#'
#' @param registry_abbrev registry abbreviation (ie. "aa")
#' @param output_location report output location (ie. reportLocationUrl)
#'
#' @returns saved console_output.txt file in the output location folder
#' @export
#'
close_sink <- function(registry_abbrev, output_location){
  sink()
  file.copy(from = "console_output.txt", 
            to = glue("{output_location}{registry_abbrev}_console_output.txt"))
  file.remove("console_output.txt")
}