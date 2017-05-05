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

#' Add a single file to a dataset.
#' @param dataset Dataset URL or path.
#' @param name File name including the file extension. If a file by that name already
#'  exists in the dataset, the file will be updated/overwritten.
#' @param url Source URL of file.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' \dontrun{
#'   dwapi::add_file_by_source(dataset = 'user/dataset',
#'     name = 'file.csv', url = 'https://data.world/some_file.csv')
#' }
#' @export
add_file_by_source <-
  function(dataset, name, url) {
    request <- dwapi::file_batch_update_request()
    request <-
      dwapi::add_file(request = request,
        name = name,
        url = url)
    ret <-
      dwapi::add_files_by_source(
        dataset = dataset,
        file_batch_update_req = request
      )
    ret
  }

#' Add one or more files to a dataset.
#' @param dataset Dataset URL or path.
#' @param file_batch_update_req Object of type \code{\link{file_batch_update_request}}.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' request <- dwapi::file_batch_update_request()
#' request <- dwapi::add_file(request = request, name = 'file.csv',
#'      url = 'https://data.world/some_file.csv')
#' \dontrun{
#'   dwapi::add_files_by_source(dataset = 'user/dataset',
#'      file_batch_update_req = request)
#' }
#' @export
add_files_by_source <-
  function(dataset,
    file_batch_update_req) {
    api_url <-
      sprintf(
        "%s/datasets/%s/files", getOption("dwapi.api_url"),
        extract_dataset_key(dataset))
    content_type_header <- "application/json"
    auth_header <- sprintf("Bearer %s", auth_token())
    response <-
      httr::POST(
        api_url,
        body = rjson::toJSON(file_batch_update_req),
        httr::add_headers(`Content-Type` = content_type_header,
          Authorization = auth_header),
        httr::user_agent(user_agent())
      )
    ret <- parse_success_or_error(response)
    ret
  }
