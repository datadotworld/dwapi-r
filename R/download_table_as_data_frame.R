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

#' Download a dataset table onto a data frame.
#' @param dataset Dataset URL or path.
#' @param table_name Table name.
#' @return Data frame with data from table.
#' @seealso \code{\link{list_tables}}
#' @examples
#' \dontrun{
#'   table_df <- dwapi::download_table_as_data_frame("user/dataset", "table")
#' }
#' @export
download_table_as_data_frame <- function(dataset, table_name) {
  url <- sprintf(
    "%s/tables/%s/%s/rows",
    getOption("dwapi.query_url"),
    extract_dataset_key(dataset),
    table_name
  )
  auth <- sprintf("Bearer %s", auth_token())
  response <- httr::GET(
    url,
    httr::add_headers(`Content-Type` = "text/csv",
      Authorization = auth),
    httr::progress(),
    httr::user_agent(user_agent())
  )
  if (response$status_code == 200) {
    text <- httr::content(x = response,
      as = "text",
      encoding = "UTF-8")
    ret <- readr::read_csv(text)
  } else {
    stop(
      sprintf(
        "Failed to download %s (HTTP Error: %s)",
        table_name,
        response$status_code
      )
    )
  }
  ret
}
