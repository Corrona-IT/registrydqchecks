# dq_url <- "C:/Users/kreides/Documents/scrap/sample_dq_output/ad_2025-05_DQReport_2025-06-04_1112/checks/"
# ds_name <- "ad_2025-05-02_2025-06-04_1112_checks"
# 
# # Read in file
# dq_results <- readRDS(glue::glue("{dq_url}{ds_name}.rds"))
# 
# 
# # Extract info
# curr_pullDate <- dq_results$runnerSummary$pullDate
# curr_timestamp <- dq_results$runnerSummary$timestamp
# curr_registry <- dq_results$runnerSummary$registry
# curr_runner <- dq_results$runnerSummary$user
# 
# 
# curr_runnerSummary <- dq_results$runnerSummary
# curr_summary <- dplyr::bind_cols(
#   registry = curr_runnerSummary$registry
#   ,pullDate = curr_runnerSummary$pullDate
#   ,timestamp = curr_runnerSummary$timestamp
#   # ,user = curr_runnerSummary$user
#   # ,dataFolderUrl = curr_runnerSummary$dataFolderUrl
#   # ,lastMonthDataFolderUrl = curr_runnerSummary$lastMonthDataFolderUrl
# )
# 
# curr_cc_summary <- curr_summary |>
#   dplyr::bind_cols(dq_results$checkSummary$criticalCheckSummary) |>
#   dplyr::select(
#     registry, pullDate, timestamp, dataset, dplyr::all_of(dplyr::starts_with("cc"))
#   )
# 
# curr_nc_summary <- curr_summary |>
#   dplyr::bind_cols(dq_results$checkSummary$nonCriticalCheckSummary) |>
#   dplyr::select(registry, pullDate, timestamp, dataset, nFailed, nTotal, pctFailed)
# 
# 
# 
# curr_ncchecks <- dq_results$nonCriticalChecks
# check_results_to_store <- dplyr::tibble()
# for(dsName in names(curr_ncchecks)){
#   curr_df <- dplyr::tibble(
#     dataset := dsName
#   )
#   for(checkId in names(curr_ncchecks[[dsName]]$codebookChecks)){
#     curr_result <- curr_ncchecks[[dsName]]$codebookChecks[[checkId]]
#     result_to_store <- dplyr::bind_cols(
#       checkId = checkId
#       ,pass = curr_result$pass
#     )
#     df <- dplyr::tibble(
#         !!checkId := curr_result$pass
#       )
#     curr_df <- curr_df |>
#       dplyr::bind_cols(
#         df
#       )
#   }
#   for(checkId in names(curr_ncchecks[[dsName]]$nPctList)){
#     curr_result <- curr_ncchecks[[dsName]]$nPctList[[checkId]]
#     result_to_store <- dplyr::bind_cols(
#       checkId = checkId
#       ,pass = curr_result$pass
#     )
#     df <- dplyr::tibble(
#       !!checkId := curr_result$pass
#     )
#     curr_df <- curr_df |>
#       dplyr::bind_cols(
#         df
#       )
#   }
#   check_results_to_store <- check_results_to_store |>
#     dplyr::bind_rows(curr_df)
# 
# }
# 
# 
# final_nc <- curr_summary |>
#   dplyr::bind_cols(check_results_to_store) |>
#   dplyr::select(
#     registry
#     ,pullDate
#     ,timestamp
#     ,dataset
#     ,dplyr::all_of(dplyr::starts_with("nc"))
#     ,dplyr::all_of(dplyr::starts_with("rc"))
#     )
# 
# # Store in central db