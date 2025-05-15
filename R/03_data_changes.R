#' Data changes function
#' @description Function to run comparison between the current data set and the provided comparison data set
#'
#' @param curr_dataset the current data set to be compared
#' @param comp_dataset the data set to compare to the current data set
#' @param by_vars list of by variables denoting a unique record in the data sets
#' @param output_folder the output folder path
#' @param output_filename the output file name
#' @param title_pagename the title page name for the title page prefixed before ": Data Changes" (ie. AA: Data Changes)
#'
#' @returns an output excel report in the specified output folder and named as the output file name
#' @export
#'
#' @importFrom glue glue
#' @importFrom huxtable as_hux add_rows add_columns insert_row insert_column merge_across set_align
#' set_background_color set_bold set_font_size set_text_color as_Workbook add_footnote
#' @importFrom dplyr filter select distinct left_join case_when mutate rename_all group_by rename tibble bind_rows arrange mutate_if
#' @import lubridate
#' @import openxlsx
#' @importFrom arsenal comparedf
data_changes <- function(curr_dataset, comp_dataset, by_vars, output_folder, output_filename, title_pagename) {
  
  
  # Set by variable list
  by_vars_list <- paste(by_vars, collapse = ", ")
  
  # Check for by variables in both curr_dataset and comp_dataset and only proceed to run the comparison
  # if all by variables exist in both datasets
  if ((! all(by_vars %in% colnames(curr_dataset)) | ! all(by_vars %in% colnames(curr_dataset)))){
    if (! all(by_vars %in% colnames(curr_dataset))){
      print("Not all by variables are in the current dataset")
    } else if (! all(by_vars %in% colnames(curr_dataset))){
      print("Not all by variables are in the comparison dataset")
    }
  } else if (all(by_vars %in% colnames(curr_dataset)) & all(by_vars %in% colnames(curr_dataset))){
    print("Running Comparison")
    # Run comparison
    curr_data <- curr_dataset %>%
      arrange(!!!rlang::syms(by_vars))
    
    comp_data <- comp_dataset %>%
      arrange(!!!rlang::syms(by_vars))
    
    overall_compare <- summary(arsenal::comparedf(comp_data,
                                                  curr_data,
                                                  by = by_vars))
    
    # Clean comparison tables
    frame_summary <- overall_compare$frame.summary.table %>% as_hux() %>%
      huxtable::add_footnote(text = glue("x is the data from previous and y is the data from new.")) %>%
      huxtable::add_footnote(text = glue("by variables {by_vars_list}")) %>%
      huxtable::set_caption("Overall Dataframe summary")
    
    overall_summary <- overall_compare$comparison.summary.table %>%
      mutate(value = as.integer(value)) %>% as_hux() %>%
      huxtable::add_footnote(text = glue("x is the data from previous and y is the data from new.")) %>%
      huxtable::add_footnote(text = glue("by variables {by_vars_list}")) %>%
      huxtable::set_caption("Summary of overall comparison")
    
    diffs.byvar <- overall_compare$diffs.byvar.table %>% as_hux() %>%
      filter(n > 0 | NAs > 0) %>%
      huxtable::add_footnote(text = glue("x is the data from previous and y is the data from new.")) %>%
      huxtable::set_caption("Number of Differences by Variable")
    
    vars.ns <- overall_compare$vars.ns.table %>%
      mutate(position = as.integer(position),
             class = as.character(class)) %>%
      as_hux() %>%
      huxtable::add_footnote(text = glue("x is the data from previous and y is the data from new.")) %>%
      huxtable::set_caption("Variables not shared")
    
    obs.ns <- overall_compare$obs.table %>%
      mutate_if(is.integer, as.character) %>% as_hux() %>%
      huxtable::add_footnote(text = glue("x is the data from previous and y is the data from new.")) %>%
      huxtable::add_footnote(text = glue("by variables {by_vars_list}")) %>%
      huxtable::set_caption("Observations not shared")
    
    diffs <- overall_compare$diffs.table %>%
      mutate(values.x = as.character(values.x),
             values.y = as.character(values.y)) %>%
      mutate_if(is.integer, as.character) %>% as_hux() %>%
      huxtable::add_footnote(text = glue("x is the data from previous and y is the data from new.")) %>%
      huxtable::add_footnote(text = glue("by variables {by_vars_list}")) %>%
      huxtable::set_caption("Detailed Differences in Variables")
    
    ## Title Page Data Creation
    title_name <- glue("{title_pagename}: Data Changes")
    generated_dt_df <- as_hux(t(data.frame(`Generated On` = Sys.Date())))
    comp_df <- as_hux(t(data.frame(`compare` = deparse(substitute(comp_dataset)))))
    curr_df <- as_hux(t(data.frame(`current` = deparse(substitute(curr_dataset)))))
    
    title_page_df <- huxtable::add_rows(generated_dt_df, curr_df, after = nrow(generated_dt_df)) %>%
      huxtable::add_rows(comp_df) %>%
      huxtable::add_columns(y = c("Date Created", "Current dataset name", "Comparison dataset name"), after = 0) %>%
      huxtable::insert_row(after = 0, fill = "") %>%
      huxtable::insert_row(after = 0, fill = "") %>%
      huxtable::insert_column(after=0, fill = "") %>%
      huxtable::insert_column(after=ncol(.), fill="") %>%
      huxtable::insert_row(c(title_name, rep("", times=ncol(.)-1)), after=0) %>%
      huxtable::merge_across(row = 1, col = 1:ncol(.)) %>%
      huxtable::set_align(row=1, value = "center") %>%
      huxtable::set_background_color(row = 1, value="darkorange") %>%
      huxtable::set_bold(row=1, value = TRUE) %>%
      huxtable::set_font_size(row=1, value=20) %>%
      huxtable::set_text_color(row=1, value="white")
    colnames(title_page_df) <- c("V1", "V2", "V3")
    
    # Generate excel report
    new_codebook <- openxlsx::createWorkbook()
    table_body_style <-
      openxlsx::createStyle(fontSize = 10,
                            halign = "left",
                            valign = "center",
                            wrapText = TRUE)
    
    
    ## Add sheets to excel codebook
    new_codebook <- as_Workbook(ht = title_page_df, Workbook = new_codebook, sheet = "Title Page")
    setColWidths(new_codebook, sheet = "Title Page", cols=1:ncol(title_page_df), widths = c(30, 40, 40, 30))
    setRowHeights(new_codebook, sheet= "Title Page", rows=1, heights=50)
    
    sheet_name <- "Quick Summary"
    table_specs <- frame_summary
    new_codebook <- as_Workbook(ht = table_specs, Workbook = new_codebook, sheet = sheet_name)
    openxlsx::setColWidths(new_codebook, sheet = sheet_name, cols = 1:ncol(table_specs), widths = c(30, 10, 10, 20))
    
    sheet_name <- "Overall Summary"
    table_specs <- overall_summary
    new_codebook <- as_Workbook(ht = table_specs, Workbook = new_codebook, sheet = sheet_name)
    openxlsx::setColWidths(new_codebook, sheet = sheet_name, cols = 1:ncol(table_specs), widths = c(40, 10))
    
    sheet_name <- "Num. of Diffs. by Var"
    table_specs <- diffs.byvar
    new_codebook <- as_Workbook(ht = table_specs, Workbook = new_codebook, sheet = sheet_name)
    openxlsx::freezePane(new_codebook, sheet = sheet_name, firstActiveRow = 3, firstActiveCol = 3)
    openxlsx::setColWidths(new_codebook, sheet = sheet_name, cols = 1:ncol(table_specs), widths = c(20, 20, 10, 10))
    
    sheet_name <- "Vars. Not Shared"
    table_specs <- vars.ns
    new_codebook <- as_Workbook(ht = table_specs, Workbook = new_codebook, sheet = sheet_name)
    openxlsx::freezePane(new_codebook, sheet = sheet_name, firstActiveRow = 3, firstActiveCol = 3)
    openxlsx::setColWidths(new_codebook, sheet = sheet_name, cols = 1:ncol(table_specs), widths = rep(20, times = ncol(table_specs)))
    
    sheet_name <- "Obs. Not Shared"
    table_specs <- obs.ns
    new_codebook <- as_Workbook(ht = table_specs, Workbook = new_codebook, sheet = sheet_name)
    openxlsx::setColWidths(new_codebook, sheet = sheet_name, cols = 1:ncol(table_specs), widths = rep(20, times = ncol(table_specs)))
    
    sheet_name <- "Detailed Comparison"
    table_specs <- diffs
    new_codebook <- as_Workbook(ht = table_specs, Workbook = new_codebook, sheet = sheet_name)
    openxlsx::setColWidths(new_codebook, sheet = sheet_name, cols = 1:ncol(table_specs), widths = rep(20, times = ncol(table_specs)))
    
    # Save report
    openxlsx::saveWorkbook(new_codebook, glue("{output_folder}/{output_filename}_changes.xlsx"), overwrite = TRUE)
  }
  
  
}

