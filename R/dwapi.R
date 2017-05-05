"dwapi-r
Copyright 2017 data.world, Inc.

Licensed under the Apache License, Version 2.0 (the \"License\");
you may not use this file except in compliance with the License.

You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an \"AS IS\" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing
permissions and limitations under the License.

This product includes software developed at data.world, Inc.
https://data.world"

#' dwapi: A client for data.world's REST API.
#'
#' The dwapi package makes it easy to access and work with data.world's REST API.
#'
#' @section Configuration:
#'
#' The package can be configured with the \code{\link{configure}} function.
#'
#' Make sure to configure authentication at the begining of every new R session.
#'
#' API authentication tokens can be obtained at \url{https://data.world/settings/advanced}
#'
#' @section API functions:
#'
#' Managing datasets:
#' \enumerate{
#'   \item \code{\link{create_dataset}}
#'   \item \code{\link{update_dataset}}
#'   \item \code{\link{replace_dataset}}
#'   \item \code{\link{sync}}
#'   \item \code{\link{download_datapackage}}
#' }
#'
#' Managing files:
#' \enumerate{
#'   \item \code{\link{download_file}}
#'   \item \code{\link{download_file_as_data_frame}}
#'   \item \code{\link{upload_file}}
#'   \item \code{\link{upload_data_frame}}
#'   \item \code{\link{add_files_by_source}}
#'   \item \code{\link{delete_file}}
#' }
#'
#' Managing tables and schemas (data dictionary):
#' \enumerate{
#'   \item \code{\link{list_tables}}
#'   \item \code{\link{get_table_schema}}
#'   \item \code{\link{update_table_schema}}
#'   \item \code{\link{download_table_as_data_frame}}
#' }
#'
#' Querying:
#' \enumerate{
#'   \item \code{\link{sql}}
#'   \item \code{\link{sparql}}
#' }
#'
#' @section Request object constructors:
#'
#' Complex requests are facilitated by request object constructors. The main ones are:
#' \enumerate{
#'   \item \code{\link{dataset_create_request}}
#'   \item \code{\link{dataset_update_request}}
#'   \item \code{\link{dataset_replace_request}}
#'   \item \code{\link{file_batch_update_request}}
#'   \item \code{\link{table_schema_update_request}}
#' }
#'
#' @docType package
#' @name dwapi
NULL
