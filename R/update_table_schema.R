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

#' Update table schema.
#' @param dataset Dataset URL or path.
#' @param table_name Table name.
#' @param table_schema_update_req Request object of type \code{\link{table_schema_update_request}}
#' @examples
#' field_update_req <- dwapi::table_schema_field_update_request("field", "new desc")
#' schema_update_req <- dwapi::table_schema_update_request(c(field_update_req))
#' \dontrun{
#'   dwapi::update_table_schema("user/dataset", "table", schema_update_req)
#' }
#' @return Object of type \code{\link{success_message}}
#' @export
update_table_schema <- function(dataset, table_name, table_schema_update_req) {
  url <- sprintf("%s/tables/%s/%s/schema",
    getOption("dwapi.query_url"),
    extract_dataset_key(dataset),
    table_name)
  auth <- sprintf("Bearer %s", auth_token())
  response <- httr::PATCH(
    url,
    body = rjson::toJSON(table_schema_update_req),
    httr::add_headers(`Content-Type` = "application/json",
      Authorization = auth),
    httr::user_agent(user_agent())
  )
  ret <- parse_success_or_error(response)
  ret
}
