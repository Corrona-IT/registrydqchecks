# # remotes::install_github("corrona-it/registrydqchecksreportdown@develop")
# 
# # Open sink file to store console output
# # temp_log_file <- registrydqchecks::open_sink()
# 
# # Choose from aa, ad, gpp, ibd, ms, nmo, psa, pso, ra, raj
# .registryAbbreviation <- "ad"
# 
# .dataPullYear <- "2025"
# .dataPullFolderDate <- "2025-09-04"
# .dataPullDate <- "2025-09-04"
# 
# .lastMonthDataPullYear <- "2025"
# .lastMonthDataPullFolderDate <- "2025-08-04"
# .lastMonthDataPullDate <- "2025-08-04"
# 
# source("config.R")
# 
# # validateCodebook(codebookUrl = .testCodebookUrl[[.registryAbbreviation]]
# #                   ,datasetNames = .testDataSetsToCheck[[.registryAbbreviation]])
# 
# # checks <- readRDS("C:/Users/scott.kreider/Documents/scrap/exampleOutput/aa_2025-07-05_2025-07-21_1442_checks.rds")
# # manualNcChecks <- checks$nonCriticalChecks
# manualNcChecks <- NULL
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
# .nonCriticalChecks = manualNcChecks
# .outputUrl = glue::glue("{.reportOutputUrl}/{.registryAbbreviation}/{.dataPullYear}/{.dataPullDate}/")
# .isR = .testIsR[[.registryAbbreviation]]
# 
# .dsName = "GPP_drugevents"
# 
# copyRomListingToFolder(.reportOutputUrl = outputUrl
#                        ,.romReportUrl = .exampleRomOutputFolder
#                        ,.registry = .registryAbbreviation
#                        ,.dataPullDate = .dataPullDate
#                        ,.overwrite = FALSE)
# 
# # registrydqchecks::close_sink(temp_log_file = temp_log_file
# #                              ,registry_abbrev = .registry
# #                              ,output_location = outputUrl)
