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

#' List tables in a dataset.
#'
#' Tables are a logical concept representing normalized data extracted
#' from tabular files uploaded to datasets on data.world.
#'
#' \strong{EXPERIMENTAL}: This is an experimental feature and
#' backwards-compability is not guaranteed in future releases.
#'
#' @param dataset Dataset URL or path.
#' @return list of table names.
#' @examples
#' \dontrun{
#'   tables <- dwapi::list_tables("user/dataset")
#' }
#' @export
list_tables <- function(dataset) {
  url <- sprintf("%s/tables/%s",
    getOption("dwapi.query_url"),
    extract_dataset_key(dataset))
  auth <- sprintf("Bearer %s", auth_token())
  response <- httr::GET(
    url,
    httr::add_headers(`Content-Type` = "application/json",
      Authorization = auth),
    httr::user_agent(user_agent())
  )
  if (response$status_code == 200) {
    ret <-
      rjson::fromJSON(httr::content(
        x = response,
        as = "text",
        encoding = "UTF-8"
      ))
  } else {
    error_msg <-
      error_message(rjson::fromJSON(httr::content(
        x = response,
        as = "text",
        encoding = "UTF-8"
      )))
    stop(error_msg$message)
  }
  ret
}
