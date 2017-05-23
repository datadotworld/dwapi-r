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

#' Download file from dataset onto the local file system.
#' @param dataset Dataset URL or path.
#' @param file_name File name, including file extension.
#' @param output Local file path, where dataset file will be saved.
#' @return Server response message.
#' @examples
#' \dontrun{
#'   dwapi::download_file(dataset = 'user/dataset',
#'    file_name = 'file.csv', output = 'tmp/file.csv')
#' }
#' @export
download_file <-
  function(dataset, file_name, output) {
    url <- sprintf(
      "%s/file_download/%s/%s",
      getOption("dwapi.download_url"),
      extract_dataset_key(dataset),
      file_name
    )
    response <-
      httr::GET(
        url,
        httr::add_headers(Authorization = sprintf("Bearer %s", auth_token())),
        httr::progress(),
        httr::user_agent(user_agent())
      )
    ret <- httr::http_status(response)
    if (response$status_code == 200) {
      raw <- httr::content(x = response, as = "raw")
      writeBin(raw, output)
    } else {
      stop(sprintf(
        "Failed to download %s (HTTP Error: %s)",
        file_name,
        response$status_code
      ))
    }
    ret
  }
