#' Check for rows that were in last months dataset but are not in this month
#'
#' @param .dsToCheck A dataframe to check
#' @param .compDsToCheck A dataframe from last month
#' @param .uniqueKey A character vector with names of variables that define the unique keys
#'
#' @returns A list with pass/fail, number of removed rows, and a listing of unique keys that were removed
#' 
#' @importFrom dplyr anti_join
#' @importFrom glue glue
checkForRemovedRows <- function(.dsToCheck,.compDsToCheck,.uniqueKey){
  
  # Make (...) parameters into a character vector for use in anti_join
  .uniqueKeys <- .uniqueKey
  
  .tempDsToCheck <- .dsToCheck |>
    cleanUniqueKeyClasses(uniqueKeyVars = list(.uniqueKeys))
  .tempCompDsToCheck <- .compDsToCheck |>
    cleanUniqueKeyClasses(uniqueKeyVars = list(.uniqueKeys))

  # Create dataframe of rows in .compDsToCheck and not in .dsToCheck
  .inOldAndNotInNew <- as.data.frame(dplyr::anti_join(.tempCompDsToCheck,.tempDsToCheck,.uniqueKeys))
  
  rm(.tempDsToCheck, .tempCompDsToCheck)
  
  .pctRemoved <- nrow(.inOldAndNotInNew) / nrow(.compDsToCheck)

  # Define output list structure
  .returnOutput <- list(
    "checkId" = "cc6"
    ,"checkTitle" = "Reasonable volume of disappearing rows"
    ,"checkDescription" = "For each analytic file, confirm that the volume of disappearing rows is below a prespecified threshold. (0)"
    ,"checkShortDescription" = "removed rows"
    ,"sendCheckToRom" = FALSE
    ,"threshold" = sprintf("%.2f%%",2)
    ,"pass" = ifelse(.pctRemoved > 0.02, FALSE, TRUE)
    ,"nRemovedRows" = glue::glue("{nrow(.inOldAndNotInNew)} ({sprintf('%.2f%%',.pctRemoved*100)})")
    ,"inOldAndNotInNew" = as.data.frame(.inOldAndNotInNew[,.uniqueKeys])
  )

  return(.returnOutput)
}

