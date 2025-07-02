#' perpetuateExcelComments A function to read in the CDM/ROM report from last month and pull comments and place them in the new report
#'
#' @param .lastMonthCheckExcelFileUrl A direct URL to the Excel file from last month
#' @param .thisMonthCheckExcelFileUrl A direct URL to the Excel file from this month
#' 
#' @importFrom glue glue
#' @importFrom readxl read_xlsx
#' @importFrom openxlsx loadWorkbook writeData saveWorkbook
#' @importFrom dplyr slice select filter distinct bind_cols starts_with intersect
#' @importFrom janitor row_to_names clean_names
perpetuateExcelComments <- function(.lastMonthCheckExcelFileUrl
                                    ,.thisMonthCheckExcelFileUrl
                                    ){
    # Read in Excel file with the checks
    lastMonthAllChecksExcel <- readxl::read_xlsx(glue::glue("{.lastMonthCheckExcelFileUrl}"), sheet = "qualityChecks")
    thisMonthAllChecksExcel <- readxl::read_xlsx(glue::glue("{.thisMonthCheckExcelFileUrl}"), sheet = "qualityChecks")
    
    # Identify unique check identifiers from last month
    lastMonthDsToWorkWith <- lastMonthAllChecksExcel |>
      dplyr::filter(substr(`...7`,1,2) %in% c("nc", "rc")) |>
      dplyr::select(`...7`) |>
      dplyr::distinct()
    
    # Identify unique check identifiers from this month
    thisMonthDsToWorkWith <- thisMonthAllChecksExcel |>
      dplyr::filter(substr(`...7`,1,2) %in% c("nc", "rc")) |>
      dplyr::select(`...7`) |>
      dplyr::distinct()

    # Loop through check identifiers
    ### Extract check datasets
    ### Extract investigation items
    ### Create combined dataset with check data and investigation items
    for(check in lastMonthDsToWorkWith$`...7`){
      if(check %in% thisMonthDsToWorkWith$`...7`){
        
        thisMonthCheckDs <- data.frame()
        lastMonthCheckDs <- data.frame()
        
        print(check)
        
        # Extract location of check subdata for this month
        thisMonthCheckLocMin <- min(which(thisMonthAllChecksExcel$`...7` == check))
        thisMonthCheckLocMax<- max(which(thisMonthAllChecksExcel$`...7` == check))
        thisMonthCheckLocHeader <- thisMonthCheckLocMin - 1
        
        # Extract the check subdata for this month
        thisMonthCheckDs <- thisMonthAllChecksExcel |>
          dplyr::slice(thisMonthCheckLocHeader:thisMonthCheckLocMax) |>
          dplyr::select(starts_with("...")) |>
          dplyr::select(-`...6`) |>
          janitor::row_to_names(row_number = 1) |>
          janitor::clean_names() |>
          dplyr::select(-dplyr::starts_with("na"))
        
        
        # Extract location of check subdata for last month
        lastMonthCheckLocMin <- min(which(lastMonthAllChecksExcel$`...7` == check))
        lastMonthCheckLocMax<- max(which(lastMonthAllChecksExcel$`...7` == check))
        lastMonthCheckLocHeader <- lastMonthCheckLocMin - 1
        
        # Extract the check Investigator subdata for last month
        lastMonthInvestigatorDs <- lastMonthAllChecksExcel |>
          dplyr::slice((lastMonthCheckLocHeader+1):lastMonthCheckLocMax) |>
          dplyr::select("Investigator",	"Date Investigated",	"Resolution",	"Date Resolved",	"Notes") |>
          dplyr::mutate(
            `Investigator` = as.character(`Investigator`)
            ,`Date Investigated` = as.Date(`Date Investigated`, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"), optional = TRUE)
            ,`Resolution` = as.character(`Resolution`)
            ,`Date Resolved` = as.Date(`Date Resolved`, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"), optional = TRUE)
            ,`Notes` = as.character(`Notes`)
          )
        
        # Extract the check subdata for last month
        lastMonthCheckDs <- lastMonthAllChecksExcel |>
          dplyr::slice(lastMonthCheckLocHeader:lastMonthCheckLocMax) |>
          dplyr::select(starts_with("...")) |>
          dplyr::select(-`...6`) |>
          janitor::row_to_names(row_number = 1) |>
          janitor::clean_names() |>
          dplyr::select(-dplyr::starts_with("na"))
        
        # ID just the variables that overlap to merge on
        joinVars <- dplyr::intersect(names(thisMonthCheckDs), names(lastMonthCheckDs))
        
        # Create dataset from last month with Investigator info
        lastMonthFullDs <- dplyr::bind_cols(lastMonthCheckDs, lastMonthInvestigatorDs)
        
        # Create dataset from this month with Investigator info
        thisMonthFullDs <- dplyr::bind_cols(thisMonthCheckDs)
        
        # If any vars in common - merge the datasets on these vars
        if (length(joinVars) > 0) {
          finalDs <- dplyr::left_join(
            thisMonthFullDs
            ,lastMonthFullDs
            ,by = joinVars
          )
          
          # Build dataset to print out
          toPrint <- finalDs[c("Investigator", "Date Investigated", "Resolution", "Date Resolved", "Notes")]
          
          # Load the Excel file to write information into
          wb = openxlsx::loadWorkbook(glue::glue("{.thisMonthCheckExcelFileUrl}"))
          
          # Write Investigator information to this month's Excel file
          openxlsx::writeData(wb, sheet = "qualityChecks", x = toPrint, startCol = 1, startRow = thisMonthCheckLocMin + 1, colNames = FALSE)
          
          # Save the workbook with the Investigation items added
          openxlsx::saveWorkbook(wb, glue::glue("{.thisMonthCheckExcelFileUrl}"), overwrite = TRUE)
        } else {
          print("No common variables to join on.")
        }

      }
    }
}

