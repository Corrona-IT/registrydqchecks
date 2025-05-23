% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/02_parameterCheck.R
\name{paramCheck}
\alias{paramCheck}
\title{Parameter Checks}
\usage{
paramCheck(
  .registry,
  .prelimDataFolderUrl,
  .lastMonthDataFolderUrl,
  .codebookUrl,
  .siteInfoUrl,
  .cdmRomReportUrl,
  .outputUrl
)
}
\arguments{
\item{.registry}{The registry abbreviation}

\item{.prelimDataFolderUrl}{The folder URL of the data}

\item{.lastMonthDataFolderUrl}{The folder URL of last month's data}

\item{.codebookUrl}{The URL to the codebook}

\item{.siteInfoUrl}{The URL to the site_info_clean.csv file}

\item{.cdmRomReportUrl}{The CDM/ROM report URL}

\item{.outputUrl}{The output URL}
}
\value{
Print message that all parameters pass
}
\description{
Parameter Checks
}
