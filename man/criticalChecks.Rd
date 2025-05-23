% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/20_criticalChecks.R
\name{criticalChecks}
\alias{criticalChecks}
\title{Run the critical checks on the specified files}
\usage{
criticalChecks(
  .dsToCheck,
  .compDsToCheck,
  .listOfEssentialVars,
  .listOfSupposedVars,
  .uniqueKeys,
  .codebookVariables,
  .dsName
)
}
\arguments{
\item{.dsToCheck}{A dataframe of the dataset to run the checks on}

\item{.compDsToCheck}{A dataframe of the dataset to compare the above dataset to}

\item{.listOfEssentialVars}{A character vector of variables deemed "essential"}

\item{.listOfSupposedVars}{A character vector of variables that "should" be in the dataset}

\item{.uniqueKeys}{A character vector of variables that uniquely identify rows in the dataset}

\item{.codebookVariables}{The codebook variables for the dataset}

\item{.dsName}{The name of the dataset being checked}
}
\value{
A list with the results of the critical checks
}
\description{
Run the critical checks on the specified files
}
