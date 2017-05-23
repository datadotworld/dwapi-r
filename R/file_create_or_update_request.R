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

#' Create object for adding/updating a dataset file.
#' @param file_name File name including the file extension. If a file by that name already
#' exists in the dataset, the file will be updated/overwritten.
#' @param url (optional) Source URL for file.
#' @param description (optional) File description.
#' @param labels (optional) List of file labels ("raw data", "documentation",
#' "visualization", "clean data", "script" or "report").
#' @return Object of type \code{file_create_or_update_request}.
#' @seealso \code{\link{file_batch_update_request}}, \code{\link{update_dataset}}
#' @examples
#' file_create_or_update_req <- dwapi::file_create_or_update_request(
#'   file_name = "file.csv",
#'   url = "https://data.world/file.csv",
#'   description = "My updated CSV description",
#'   labels = list("raw data", "clean data"))
#' @export
file_create_or_update_request <- function(file_name,
  url = NULL,
  description = NULL,
  labels = NULL) {
  if (file_name == "") {
    stop("name is required")
  }

  me <- list(name = file_name)
  if (!is.null(url)) {
    me$source <- file_source_create_or_update_request(url)
  }
  if (!is.null(description)) {
    me$description <- description
  }
  if (!is.null(labels)) {
    me$labels <- labels
  }

  class(me) <- "file_create_or_update_request"
  return(me)
}

#' Create object for adding a dataset file.
#' @param file_name File name including the file extension. If a file by that name already
#' exists in the dataset, the file will be updated/overwritten.
#' @param url Source URL for file.
#' @param description (optional) File description.
#' @param labels (optional) List of file labels ("raw data", "documentation",
#' "visualization", "clean data", "script" or "report").
#' @return Object of type \code{file_create_request}.
#' @seealso \code{\link{create_dataset}}, \code{\link{replace_dataset}}
#' @examples
#' file_create_req <- dwapi::file_create_request(file_name = "file.csv",
#'   url = "https://data.world/file.csv",
#'   description = "My CSV file",
#'   labels = list("raw data"))
#' @export
file_create_request <- function(file_name,
  url,
  description = NULL,
  labels = NULL) {
  if (file_name == "" | url == "") {
    stop("name and url required")
  }

  me <-
    list(name = file_name, source = file_source_create_request(url))
  if (!is.null(description)) {
    me$description <- description
  }
  if (!is.null(labels)) {
    me$labels <- labels
  }

  class(me) <- "file_create_request"
  return(me)
}
