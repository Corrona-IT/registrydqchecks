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
    
    # Look for "anchor" (case-insensitive)
    last_anchor_index <- which(tolower(lastMonthAllChecksExcel |> names()) == "anchor")
    last_anchor_name <- paste0("...",last_anchor_index+1)
    this_anchor_index <- which(tolower(thisMonthAllChecksExcel |> names()) == "anchor")
    this_anchor_name <- paste0("...",this_anchor_index+1)

    # Identify unique check identifiers from last month
    lastMonthDsToWorkWith <- lastMonthAllChecksExcel |>
      dplyr::filter(substr(.data[[last_anchor_name]],1,2) %in% c("nc", "rc")) |>
      dplyr::select(all_of(last_anchor_name)) |>
      dplyr::distinct()
    
    # Identify unique check identifiers from this month
    thisMonthDsToWorkWith <- thisMonthAllChecksExcel |>
      dplyr::filter(substr(.data[[this_anchor_name]],1,2) %in% c("nc", "rc")) |>
      dplyr::select(all_of(this_anchor_name)) |>
      dplyr::distinct()

    # Loop through check identifiers
    ### Extract check datasets
    ### Extract investigation items
    ### Create combined dataset with check data and investigation items
    for(check in lastMonthDsToWorkWith[[last_anchor_name]]){
      if(check %in% thisMonthDsToWorkWith[[this_anchor_name]]){
        
        thisMonthCheckDs <- data.frame()
        lastMonthCheckDs <- data.frame()
        
        print(check)
        
        # Extract location of check subdata for this month
        thisMonthCheckLocMin <- min(which(thisMonthAllChecksExcel[[this_anchor_name]] == check))
        thisMonthCheckLocMax<- max(which(thisMonthAllChecksExcel[[this_anchor_name]] == check))
        thisMonthCheckLocHeader <- thisMonthCheckLocMin - 1
        
        # Extract the check subdata for this month
        thisMonthCheckDs <- thisMonthAllChecksExcel |>
          dplyr::slice(thisMonthCheckLocHeader:thisMonthCheckLocMax) |>
          dplyr::select(starts_with("...")) |>
          # dplyr::select(-any_of(anchor)) |>
          janitor::row_to_names(row_number = 1) |>
          janitor::clean_names() |>
          dplyr::select(-dplyr::starts_with("na"))
        
        
        # Extract location of check subdata for last month
        lastMonthCheckLocMin <- min(which(lastMonthAllChecksExcel[[last_anchor_name]] == check))
        lastMonthCheckLocMax<- max(which(lastMonthAllChecksExcel[[last_anchor_name]] == check))
        lastMonthCheckLocHeader <- lastMonthCheckLocMin - 1
        
        # Extract the check Investigator subdata for last month
        lastMonthInvestigatorDs <- lastMonthAllChecksExcel |>
          dplyr::slice((lastMonthCheckLocHeader+1):lastMonthCheckLocMax) |>
          dplyr::select(any_of(c("Investigator",	"Date Investigated",	"Resolution",	"Date Resolved",	"Notes", "Extra1", "Extra2", "newCheck"))) |>
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
          # dplyr::select(-any_of(anchor)) |>
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
            ,lastMonthFullDs |> dplyr::mutate(.present = 1L)
            ,by = joinVars
          ) |>
            dplyr::mutate(newCheck = dplyr::if_else(is.na(.present), "NEW!", "")) |>
            dplyr::select(-.present)
          
          # Build dataset to print out
          toPrint <- finalDs |>
            dplyr::select(any_of(c("Investigator", "Date Investigated", "Resolution", "Date Resolved", "Notes", "Extra1", "Extra2", "newCheck")))
          
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

