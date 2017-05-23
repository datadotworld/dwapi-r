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

#' Upload a single file to a dataset.
#' @param dataset Dataset URL or path.
#' @param path File path on local file system.
#' @param file_name File name, including file extension.
#' @return Server response message.
#' @examples
#' \dontrun{
#'   dwapi::upload_file(file_name = 'file.csv',
#'     path = 'file.csv', dataset = 'user/dataset')
#' }
#' @export
upload_file <-
  function(dataset, path, file_name) {
    url <- sprintf("%s/uploads/%s/files/%s",
      getOption("dwapi.api_url"),
      extract_dataset_key(dataset),
      file_name)
    auth <- sprintf("Bearer %s", auth_token())
    content_type <- "application/octet-stream"
    response <-
      httr::PUT(
        url,
        body = httr::upload_file(path),
        httr::add_headers(`Content-Type` = content_type, Authorization = auth),
        httr::progress(),
        httr::user_agent(user_agent())
      )
    ret <- parse_success_or_error(response)
    ret
  }

#' Upload one or more files to a dataset.
#' @param dataset Dataset URL or path.
#' @param paths List of file paths on local file system.
#' @return Server response message.
#' @examples
#' \dontrun{
#'   dwapi::upload_files(dataset = 'user/dataset',
#'     paths = c('file1.csv', 'file2.csv'))
#' }
#' @export
upload_files <- function(dataset, paths) {
  url <- sprintf("%s/uploads/%s/files", getOption("dwapi.api_url"),
    extract_dataset_key(dataset))
  auth <- sprintf("Bearer %s", auth_token())
  content_type <- "multipart/form-data"
  body_values <- lapply(paths, function(path)
    httr::upload_file(path))
  body_names <- lapply(paths, function(path)
    "file")
  body <- structure(body_values, names = body_names)
  response <-
    httr::POST(
      url,
      body = body,
      httr::add_headers(`Content-Type` = content_type, Authorization = auth),
      httr::progress(),
      httr::user_agent(user_agent())
    )
  ret <- parse_success_or_error(response)
  ret
}
