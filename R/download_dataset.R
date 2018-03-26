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

#' Download a dataset as a zip archive and store at the specified path.
#' @param dataset Dataset URL or path.
#' @param output_path Local file path where dataset zip file will be saved.
#' @return Server response message.
#' @examples
#' \dontrun{
#'   dwapi::download_dataset(dataset = 'user/dataset',
#'    output_path = tempfile(fileext = 'zip'))
#' }
#' @export
download_dataset <- function(dataset, output_path) {
  url <- paste0(
    getOption("dwapi.api_url"),
    "/", "download", "/", # to avoid lintr errors
    extract_dataset_key(dataset)
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
    writeBin(raw, output_path)
  } else {
    stop(sprintf(
      "Failed to download dataset %s (HTTP Error: %s)",
      dataset,
      response$status_code
    ))
  }
  ret
}
