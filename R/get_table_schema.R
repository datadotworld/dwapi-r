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

#' Retrieve schema information for a dataset table.
#' @param dataset Dataset URL or path.
#' @param table_name Table name.
#' @return Object of type \code{\link{table_schema_response}}.
#' @seealso \code{\link{list_tables}}
#' @examples
#' \dontrun{
#'   table_schema <- dwapi::get_table_schema("user/dataset", "table")
#' }
#' @export
get_table_schema <- function(dataset, table_name) {
  url <- sprintf("%s/tables/%s/%s/schema",
    getOption("dwapi.query_url"),
    extract_dataset_key(dataset),
    table_name)
  auth <- sprintf("Bearer %s", auth_token())
  response <- httr::GET(
    url,
    httr::add_headers(`Content-Type` = "application/json",
      Authorization = auth),
    httr::user_agent(user_agent())
  )
  if (response$status_code == 200) {
    json_structure <-
      rjson::fromJSON(httr::content(
        x = response,
        as = "text",
        encoding = "UTF-8"
      ))
    ret <- table_schema_response(json_structure)
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
