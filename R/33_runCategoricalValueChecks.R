#' runCategoricalValueChecks Run a check to ensure categorical variables have the appropriate values
#'
#' @param .dsName The name of the dataset being checked
#' @param .dsToCheck The dataset being checked
#' @param .codebookVariables The codebook variables for this specific check
#' @param .uniqueKeys The unique keys for the dataset
#'
#' @return Results of the check
#' 
#' @importFrom dplyr filter select mutate all_of bind_rows rename
#' @importFrom purrr map
#' @importFrom glue glue
runCategoricalValueChecks <- function(.dsName
                                      ,.dsToCheck
                                      ,.codebookVariables
                                      ,.uniqueKeys){

  
  # Initialize a df for the results of the checks
  .categoricalValueChecks <- data.frame()
  
  # Subset codebook variables to categorical variables
  # Clean the expected categorical variables
  ### Remove quotes, split at commas, pick off number before =, text after =
  .varsToCheck <- .codebookVariables |>
    dplyr::filter(!is.na(catValues))
  
  if(nrow(.varsToCheck) == 0){
    return(NULL)
  }
    
  .varsToCheck <- .varsToCheck |>
    dplyr::select(varName, varLabel, calculatedVariable, catValues) |>
    dplyr::mutate(split = strsplit(catValues, ",")) |>
    dplyr::mutate(cleanCol = purrr::map(split, removeQuotes)) |>
    dplyr::mutate(
      numValues = purrr::map(cleanCol, extractValueNumbers)
      ,catValues = purrr::map(cleanCol, extractValueLabels)
    )

  # Loop through each categorical variable in the dataset
  for(.varName1 in .varsToCheck$varName){

    .currentCheckVar <- .varsToCheck |>
      dplyr::filter(varName == {{.varName1}})
    
    # Catch error if issue with reading in
    tryCatch({
      # Pull off the expected numeric and associated labels for the specific variable
      .dsToCheckLevels <- as.numeric(names(table(.dsToCheck[[.varName1]])))
      .expectedLevels <- unlist(.varsToCheck[.varsToCheck$varName == glue::glue("{.varName1}"),]$numValues)
      .expectedLabels <- unlist(.varsToCheck[.varsToCheck$varName == glue::glue("{.varName1}"),]$cleanCol)
      
      # Create a list of items in the dataset and not in the expected levels
      notIn <- .dsToCheckLevels[!.dsToCheckLevels %in% .expectedLevels]
      
      # Create a dataframe of all the rows that have an item not in the expected levels
      .outOfRange <- .dsToCheck |>
        dplyr::select(dplyr::all_of(.uniqueKeys), !!.varName1) |>
        dplyr::filter(!is.na(get(.varName1))) |>
        dplyr::filter(get(.varName1) %in% notIn) |>
        dplyr::mutate(
          dataset = .dsName
          ,calculatedVariable = .currentCheckVar$calculatedVariable
          ,numVal = as.character(get(.varName1))
          ,variableName = glue::glue("{.varName1}")
          ,variableLabel = .currentCheckVar$varLabel
          ,expectedValue = list(.expectedLevels)
          ,expectedLabels = list(.expectedLabels)
        ) |>
        dplyr::rename(
          catValue = numVal
        ) |> dplyr::select(
          dplyr::all_of(.uniqueKeys), variableLabel, variableName, catValue, expectedValue, expectedLabels, calculatedVariable
        )
      
      .categoricalValueChecks <- dplyr::bind_rows(.categoricalValueChecks, .outOfRange) |>
        cleanUniqueKeyClasses(uniqueKeyVars = list(.uniqueKeys))
    }
    ,warning = function(w){
      print(paste("Warning caught:", conditionMessage(w)))
      print(paste("Warning related to variable in codebook - see Warning above:", .varName1))
    }
    ,error = function(e){
      print(paste("Error caught:", conditionMessage(e)))
      print(paste("Warning related to variable in codebook - see Warning above:", .varName1))
    }
    )
  }

  return(.categoricalValueChecks)
}


#' removeQuotes A function to remove quotes from each element in a character string
#'
#' @param vec A vector to remove quotes from
#' 
#' @importFrom stringr str_replace_all
removeQuotes <- function(vec){
  stringr::str_replace_all(vec, '"', '')
}

#' extractValueNumbers Extract the numbers before the equal sign in each element in a vector
#'
#' @param vec A vector to extract numbers from
#'
#' @return A vector of numbers of the levels of the variable
#' 
#' @importFrom stringr str_extract
extractValueNumbers <- function(vec){
  numVector <- stringr::str_extract(vec, "-?\\d+(\\.\\d+)?(?=\\s*=)") |> as.double()

  return(unlist(numVector))
}



#' extractValueLabels Extract the values after the equal sign in each element in a vector
#'
#' @param vec A vector to extract labels from
#'
#' @return A vector of the labels of the levels of the variable
#' 
#' @importFrom stringr str_extract
extractValueLabels <- function(vec){
  charVector <- stringr::str_extract(vec, "(?<=\\=\\s{0,1000}).*$")
  
  return(unlist(charVector))
}


