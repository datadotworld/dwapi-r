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

#' Create object for adding dataset file sources.
#' @param url Source URL of file.
#' @return Object of type \code{file_source_create_request}.
file_source_create_request <- function(url) {
  source <- file_source_create_or_update_request(url)
  # file_source_create_request
  class(source) <- "file_source_create_request"
  return(source)
}

#' Create object for adding/updating dataset file sources.
#' @param url Source URL of file.
#' @return Object of type \code{file_source_create_or_update_request}.
file_source_create_or_update_request <- function(url) {
  if (url == "") {
    stop("url is required")
  }
  source <- list(url = url)
  # file_source_create_or_update_request
  class(source) <- "file_source_create_or_update_request"
  return(source)
}
