# extract_dq_results <- function(ds_url, ds_name){
#   
#   dq_results <- readRDS(glue::glue("{dq_url}{ds_name}.rds"))
#   
#   
#   # Extract info
#   curr_pullDate <- dq_results$runnerSummary$pullDate
#   curr_timestamp <- dq_results$runnerSummary$timestamp
#   curr_registry <- dq_results$runnerSummary$registry
#   curr_runner <- dq_results$runnerSummary$user
#   
#   
#   curr_runnerSummary <- dq_results$runnerSummary
#   curr_summary <- dplyr::bind_cols(
#     registry = curr_runnerSummary$registry
#     ,pullDate = curr_runnerSummary$pullDate
#     ,timestamp = curr_runnerSummary$timestamp
#     # ,user = curr_runnerSummary$user
#     # ,dataFolderUrl = curr_runnerSummary$dataFolderUrl
#     # ,lastMonthDataFolderUrl = curr_runnerSummary$lastMonthDataFolderUrl
#   )
#   
#   curr_cc_summary <- curr_summary |>
#     dplyr::bind_cols(dq_results$checkSummary$criticalCheckSummary) |>
#     dplyr::select(
#       registry, pullDate, timestamp, dataset, dplyr::all_of(dplyr::starts_with("cc"))
#     )
#   
#   curr_nc_summary <- curr_summary |>
#     dplyr::bind_cols(dq_results$checkSummary$nonCriticalCheckSummary) |>
#     dplyr::select(registry, pullDate, timestamp, dataset, nFailed, nTotal, pctFailed)
#   
#   
#   
#   curr_ncchecks <- dq_results$nonCriticalChecks
#   check_results_to_store <- dplyr::tibble()
#   for(dsName in names(curr_ncchecks)){
#     curr_df <- dplyr::tibble(
#       dataset := dsName
#     )
#     for(checkId in names(curr_ncchecks[[dsName]]$codebookChecks)){
#       curr_result <- curr_ncchecks[[dsName]]$codebookChecks[[checkId]]
#       result_to_store <- dplyr::bind_cols(
#         checkId = checkId
#         ,pass = curr_result$pass
#       )
#       df <- dplyr::tibble(
#         !!checkId := curr_result$pass
#       )
#       curr_df <- curr_df |>
#         dplyr::bind_cols(
#           df
#         )
#     }
#     for(checkId in names(curr_ncchecks[[dsName]]$nPctList)){
#       curr_result <- curr_ncchecks[[dsName]]$nPctList[[checkId]]
#       result_to_store <- dplyr::bind_cols(
#         checkId = checkId
#         ,pass = curr_result$pass
#       )
#       df <- dplyr::tibble(
#         !!checkId := curr_result$pass
#       )
#       curr_df <- curr_df |>
#         dplyr::bind_cols(
#           df
#         )
#     }
#     check_results_to_store <- check_results_to_store |>
#       dplyr::bind_rows(curr_df)
#     
#   }
#   
#   
#   final_nc <- curr_summary |>
#     dplyr::bind_cols(check_results_to_store) |>
#     dplyr::select(
#       registry
#       ,pullDate
#       ,timestamp
#       ,dataset
#       ,dplyr::all_of(dplyr::starts_with("nc"))
#       ,dplyr::all_of(dplyr::starts_with("rc"))
#     )
# 
#   return_result <- list(
#     "curr_registry" = curr_registry
#     ,"curr_pullDate" = curr_registry
#     ,"curr_timestamp" = curr_registry
#     ,"curr_summary" = curr_summary
#     ,"curr_cc_summary" = curr_cc_summary
#     ,"curr_nc_summary" = curr_nc_summary
#     ,"final_nc" = final_nc
#   )
# 
#   return(return_result)
# }
# 
# 
# 
# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-06_DQReport_2025-06-03_1159/checks/"
# ds_name <- "ad_2025-06-02_2025-06-03_1159_checks"
# 
# # Read in file
# 
# a <- extract_dq_results(
#   ds_url = dq_url
#   ,ds_name = ds_name
# )
# 
# 
# 
# 
# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-05_DQReport_2025-06-04_1112/checks/"
# ds_name <- "ad_2025-05-02_2025-06-04_1112_checks"
# 
# # Read in file
# 
# b <- extract_dq_results(
#   ds_url = dq_url
#   ,ds_name = ds_name
# )
# 
# 
# 
# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-04_DQReport_2025-05-08_1327/checks/"
# ds_name <- "ad_2025-04-02_2025-05-08_1327_checks"
# 
# # Read in file
# 
# c <- extract_dq_results(
#   ds_url = dq_url
#   ,ds_name = ds_name
# )
# 
# 
# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-03_DQReport_2025-03-10_1456/checks/"
# ds_name <- "ad_2025-03-05_2025-03-10_1456_checks"
# 
# # Read in file
# 
# d <- extract_dq_results(
#   ds_url = dq_url
#   ,ds_name = ds_name
# )
# 
# 
# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-02_DQReport_2025-02-17_1511/checks/"
# ds_name <- "ad_2025-02-04_2025-02-17_1511_checks"
# 
# # Read in file
# 
# e <- extract_dq_results(
#   ds_url = dq_url
#   ,ds_name = ds_name
# )
# 
# 
# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-01_DQReport_2025-01-03_1547/checks/"
# ds_name <- "ad_2025-01-03_2025-01-03_1547_checks"
# 
# # Read in file
# 
# f <- extract_dq_results(
#   ds_url = dq_url
#   ,ds_name = ds_name
# )
# 
# 
# 
# # Store in central db
# stacked_nc <- dplyr::bind_rows(
#   a$final_nc
#   ,b$final_nc
#   ,c$final_nc
#   ,d$final_nc
#   ,e$final_nc
#   ,f$final_nc
# )
# 
# 
# 
# stacked_cc <- dplyr::bind_rows(
#   a$curr_cc_summary
#   ,b$curr_cc_summary
#   ,c$curr_cc_summary
#   ,d$curr_cc_summary
#   ,e$curr_cc_summary
#   ,f$curr_cc_summary
# )
# 
# 
# ggplot2::ggplot(stacked_cc, ggplot2::aes(x = pullDate, y = cc2)) +
#   ggplot2::geom_jitter(width = 0.3, height = 0, alpha = 0.7, color = "steelblue") +
#   ggplot2::facet_wrap(~ dataset) +
#   ggplot2::labs(x = "Date", y = "CC2 Value") +
#   ggplot2::theme_minimal()
