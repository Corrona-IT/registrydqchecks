#' Check for how many rows were added to the dataset compared to last month
#'
#' @param .dsToCheck A dataframe to check
#' @param .compDsToCheck A dataframe from last month
#' 
#' @returns A list with pass/fail, number of rows added, number of old rows, and the proportion increase in rows
checkForAddedRows <- function(.dsToCheck,.compDsToCheck){
  
  .threshold <- 10
  
  # Counts and then returns the number of rows in the new vs old dataset and
  #     computes the proportion increase in rows and compares to a given value
  # Define output list structure
  .returnOutput <- list(
    "checkId" = "cc5"
    ,"checkTitle" = "Reasonable volume of new rows"
    ,"checkDescription" = glue::glue("For each analytic file, confirm that the volume of new rows is below a prespecified threshold. ({sprintf('%.2f%%',.threshold)})")
    ,"checkShortDescription" = "number of new rows"
    ,"sendCheckToRom" = FALSE
    ,"threshold" = sprintf('%.2f%%',.threshold)
    ,"pass" = ifelse((nrow(.dsToCheck) - nrow(.compDsToCheck)) / nrow(.compDsToCheck) < .threshold / 100,TRUE,FALSE)
    ,"nAddedRows" = nrow(.dsToCheck) - nrow(.compDsToCheck)
    ,"nRowsThisMonth" = nrow(.dsToCheck)
    ,"nOldRows" = nrow(.compDsToCheck)
    ,"propRowIncrease" = round((nrow(.dsToCheck) - nrow(.compDsToCheck)) / nrow(.compDsToCheck), digits = 3)
    ,"pctRowIncrease" = sprintf('%.2f%%',100 * round((nrow(.dsToCheck) - nrow(.compDsToCheck)) / nrow(.compDsToCheck), digits = 3))
  )
  
  return(.returnOutput)
}

