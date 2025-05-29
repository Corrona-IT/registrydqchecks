# # remotes::install_github("corrona-it/registrydqchecksreportdown@develop")
# 
# # Choose from aa, ad, gpp, ibd, ms, nmo, psa, pso, ra, raj
# .registryAbbreviation <- "ad"
# 
# .dataPullYear <- "2025"
# .dataPullFolderDate <- "2025-05-02"
# .dataPullDate <- "2025-05-02"
# 
# .lastMonthDataPullYear <- "2025"
# .lastMonthDataPullFolderDate <- "2025-04-02"
# .lastMonthDataPullDate <- "2025-04-02"
# 
# source("config.R")
# 
# # validateCodebook(codebookUrl = .testCodebookUrl[[.registryAbbreviation]]
# #                   ,datasetNames = .testDataSetsToCheck[[.registryAbbreviation]])
# 
# # checks <- readRDS("C:/Users/ScottKreider/Documents/scrap/exampleOutput/ad_2024-10-01_2024-10-16_1602_checks.rds")
# # manualNcChecks <- checks$nonCriticalChecks
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
#                   ,.nonCriticalChecks = NULL
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
