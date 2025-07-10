# # remotes::install_github("corrona-it/registrydqchecksreportdown@develop")
# 
# # Open sink file to store console output
# temp_log_file <- registrydqchecks::open_sink()
# 
# # Choose from aa, ad, gpp, ibd, ms, nmo, psa, pso, ra, raj
# .registryAbbreviation <- "ibd"
# 
# .dataPullYear <- "2025"
# .dataPullFolderDate <- "2025-07-01"
# .dataPullDate <- "2025-07-01"
# 
# .lastMonthDataPullYear <- "2025"
# .lastMonthDataPullFolderDate <- "2025-06-01"
# .lastMonthDataPullDate <- "2025-06-01"
# 
# source("config.R")
# 
# # validateCodebook(codebookUrl = .testCodebookUrl[[.registryAbbreviation]]
# #                   ,datasetNames = .testDataSetsToCheck[[.registryAbbreviation]])
# 
# checks <- readRDS("C:/Users/scott.kreider/Documents/scrap/sample_dq_output/ibd_2025-07-01_2025-07-09_1329_checks.rds")
# manualNcChecks <- checks$nonCriticalChecks
# 
# outputUrl <- runRegistryChecks(.registry = .registryAbbreviation
#                   ,.prelimDataFolderUrl = .testDataFolderUrl[[.registryAbbreviation]]
#                   ,.prelimDataPullDate = .dataPullDate
#                   ,.lastMonthDataFolderUrl = .testLastMonthDataFolderUrl[[.registryAbbreviation]]
#                   ,.lastMonthDataPullDate = .lastMonthDataPullDate
#                   ,.codebookUrl = .testCodebookUrl[[.registryAbbreviation]]
#                   ,.siteInfoUrl = .configSiteInfoUrl
#                   ,.cdmRomReportUrl = .exampleRomOutputFolder
#                   ,.datasetsToCheck = .testDataSetsToCheck[[.registryAbbreviation]]
#                   ,.nonCriticalChecks = manualNcChecks
#                   ,.outputUrl = glue::glue("{.reportOutputUrl}/{.registryAbbreviation}/{.dataPullYear}/{.dataPullDate}/")
#                   ,.isR = .testIsR[[.registryAbbreviation]])
# 
# 
# .registry = .registryAbbreviation
# .prelimDataFolderUrl = .testDataFolderUrl[[.registryAbbreviation]]
# .prelimDataPullDate = .dataPullDate
# .lastMonthDataFolderUrl = .testLastMonthDataFolderUrl[[.registryAbbreviation]]
# .lastMonthDataPullDate = .lastMonthDataPullDate
# .codebookUrl = .testCodebookUrl[[.registryAbbreviation]]
# .siteInfoUrl = .configSiteInfoUrl
# .cdmRomReportUrl = .exampleRomOutputFolder
# .datasetsToCheck = .testDataSetsToCheck[[.registryAbbreviation]]
# .nonCriticalChecks = NULL
# .outputUrl = glue::glue("{.reportOutputUrl}/{.registryAbbreviation}/{.dataPullYear}/{.dataPullDate}/")
# .isR = .testIsR[[.registryAbbreviation]]
# 
# .dsName = "exlab"
# 
# # copyRomListingToFolder(.reportOutputUrl = outputUrl
# #                        ,.romReportUrl = .exampleRomOutputFolder
# #                        ,.registry = .registryAbbreviation
# #                        ,.dataPullDate = .dataPullDate
# #                        ,.overwrite = FALSE)
# 
# registrydqchecks::close_sink(temp_log_file = temp_log_file
#                              ,registry_abbrev = .registry
#                              ,output_location = outputUrl)
