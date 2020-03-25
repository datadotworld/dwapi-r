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

#' Delete a single file from a dataset.
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param file_name File name, including the file extension.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' \dontrun{
#'   dwapi::delete_file('user', 'dataset',
#'     file_name = 'file.csv')
#' }
#' @export
delete_file <-
  function(owner_id, dataset_id, file_name) {
    api_url <-
      sprintf("%s/datasets/%s/%s/files/%s",
        getOption("dwapi.api_url"),
        owner_id, dataset_id,
        file_name)
    auth <- sprintf("Bearer %s", auth_token())
    response <-
      httr::DELETE(
        api_url,
        httr::add_headers(Authorization = auth),
        httr::user_agent(user_agent())
      )
    ret <- parse_success_or_error(response)
    ret
  }

#' Delete one or more files from a dataset.
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param file_names List of file names, including file extensions.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' \dontrun{
#'   dwapi::delete_files('user', 'dataset',
#'     file_names = list('file1.csv', 'file2.csv'))
#' }
#' @export
delete_files <-
  function(owner_id, dataset_id, file_names) {
    query_param <-
      lapply(file_names, function(name)
        sprintf("name=%s", name))
    if (length(query_param) == 0) {
      print("empty names input = no-op")
    } else {
      api_url <-
        paste(
          sprintf(
            "%s/datasets/%s/%s/files?", getOption("dwapi.api_url"),
            owner_id, dataset_id),
          paste0(query_param, collapse = "&"),
          sep = ""
        )
      auth <- sprintf("Bearer %s", auth_token())
      response <-
        httr::DELETE(
          api_url,
          httr::add_headers(Authorization = auth),
          httr::user_agent(user_agent())
        )
      ret <- parse_success_or_error(response)
      ret
    }
  }
