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

#' Add a file to a request object.
#' @param request Request object and container for files.
#' @param name Filename including the file extension. If a file by that name
#' already exists in the dataset, the file will be updated/overwritten.
#' @param url Source URL for file. Optional, if updating existing files.
#' @param description (optional) File description.
#' @param labels (optional) List of file labels ("raw data", "documentation",
#' "visualization", "clean data", "script" or "report").
#' @return Modified request object.
#' @examples
#' file_batch_update_req <- dwapi::file_batch_update_request()
#'
#' file_batch_update_req <- dwapi::add_file(request = file_batch_update_req,
#'   name = 'file.csv', url = 'https://data.world/file3.csv')
#'
#' dataset_create_req <- dwapi::dataset_create_request(title='coffeeCounty',
#'   visibility = 'OPEN', description = 'coffee county , AL - census income' ,
#'   tags = c('rsdk', 'sdk', 'arr') , license_string = 'Public Domain')
#'
#' dataset_create_req <- dwapi::add_file(request = dataset_create_req,
#'   name = 'file4.csv', url = 'https://data.world/file4.csv')
#'
#' dataset_replace_req <- dwapi::dataset_replace_request(visibility = 'OPEN',
#'   description = 'updated description', title = 'updated title', files = list())
#'
#' dataset_replace_req <- dwapi::add_file(request = dataset_replace_req,
#'   name = 'file4.csv', url = 'https://data.world/file4.csv',
#'   description = "My 4th csv", labels = list("clean data"))
#' @export
add_file <-
  function(request,
    name,
    url,
    description = NULL,
    labels = NULL) {
    UseMethod("add_file")
  }

#' @describeIn add_file Default implementation
#' @export
add_file.default <-
  function(request,
    name,
    url,
    description = NULL,
    labels = NULL) {
    print("nope.")
  }

#' @describeIn add_file Add a file to a file_batch_update_request objects
#' @export
add_file.file_batch_update_request <-
  function(request,
    name,
    url,
    description = NULL,
    labels = NULL) {
    existing_files <- request$files
    # O(N) ?
    existing_files[[length(existing_files) + 1]] <-
      dwapi::file_create_or_update_request(name,
        url = url,
        description = description,
        labels = labels)
    request$files <- existing_files
    request
  }

#' @describeIn add_file Add a file to a dataset_create_request object
#' @export
add_file.dataset_create_request <-
  function(request,
    name,
    url,
    description = NULL,
    labels = NULL) {
    existing_files <- request$files
    # O(N) ?
    existing_files[[length(existing_files) + 1]] <-
      dwapi::file_create_request(
        name, url, description = description, labels = labels)
    request$files <- existing_files
    request
  }

#' @describeIn add_file Add a file to a dataset_replace_request object
#' @export
add_file.dataset_replace_request <-
  function(request,
    name,
    url,
    description = NULL,
    labels = NULL) {
    existing_files <- request$files
    # O(N) ?
    existing_files[[length(existing_files) + 1]] <-
      dwapi::file_create_request(
        name, url, description = description, labels = labels)
    request$files <- existing_files
    request
  }

#' @describeIn add_file Add a file to a dataset_update_request object
#' @export
add_file.dataset_update_request <-
  function(request,
    name,
    url = NULL,
    description = NULL,
    labels = NULL) {
    existing_files <- request$files
    # O(N) ?
    existing_files[[length(existing_files) + 1]] <-
      dwapi::file_create_or_update_request(name,
        url = url,
        description = description,
        labels = labels)
    request$files <- existing_files
    request
  }
