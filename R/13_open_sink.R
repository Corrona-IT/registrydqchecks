#' open sink txt file to store console output in the console_output.txt
#'
#' @returns a txt file named console_output.txt
#' @export
#'
open_sink <- function(){
  
  # Close sink file if it is open 
  sink()
  
  sink("console_output.txt", split = TRUE)
  sink(stdout(), type = c("output", "message"), split = TRUE)
  sink(stderr(), type = c("output", "message"), split = TRUE)
}