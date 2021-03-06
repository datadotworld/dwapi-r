% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_file_as_data_frame.R
\name{download_file_as_data_frame}
\alias{download_file_as_data_frame}
\title{Download dataset file onto a data frame.}
\usage{
download_file_as_data_frame(owner_id, dataset_id, file_name, col_types = NULL)
}
\arguments{
\item{owner_id}{User name and unique identifier of the creator of a
dataset or project}

\item{dataset_id}{Dataset unique identifier}

\item{file_name}{File name, including file extension.}

\item{col_types}{column types specified in the same manner as the
col_types parameter of readr::read_csv(), or pass NULL (the default) to
detect column types automatically from the data.world table schema}
}
\value{
Data frame with the contents of CSV file.
}
\description{
Download dataset file onto a data frame.
}
\examples{
\dontrun{
  my_df <- dwapi::download_file_as_data_frame(
    "user", "dataset",
    file_name = "file.csv")
}
}
