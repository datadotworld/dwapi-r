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
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param table_name Table name.
#' @param col_types column types specified in the same manner as the
#' col_types parameter of readr::read_csv(), or pass NULL (the default) to
#' detect column types automatically from the data.world table schema
#' @return Data frame with data from table.
#' @seealso \code{\link{list_tables}}
#' @examples
#' \dontrun{
#'   table_df <- dwapi::download_table_as_data_frame("user", "dataset", "table")
#' }
#' @export
download_table_as_data_frame <- function(owner_id, dataset_id,
                                         table_name, col_types = NULL) {
  url <- sprintf(
    "%s/tables/%s/%s/%s/rows",
    getOption("dwapi.query_url"),
    owner_id, dataset_id,
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
    ret <- parse_downloaded_csv(text, owner_id,
                                dataset_id, table_name, col_types = col_types)
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
