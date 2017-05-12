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

#' Create request object for updating table schema.
#' @param fields List of \code{\link{table_schema_field_update_request}} objects.
#' @return Object of type \code{table_schema_update_request}.
#' @seealso \code{\link{update_table_schema}}
#' @examples
#' field_update_req <- dwapi::table_schema_field_update_request("field", "new desc")
#' schema_update_req <- dwapi::table_schema_update_request(c(field_update_req))
#' @export
table_schema_update_request <- function(fields) {
  me <- list(
    fields = fields
  )
  class(me) <- "table_schema_update_request"
  me
}

#' Create request object for updating table schema fields.
#' @param name Table field name.
#' @param description Table field description.
#' @return Object of type \code{table_schema_field_update_request}
#' @examples
#' field_update_req <- dwapi::table_schema_field_update_request("field", "new desc")
#' @export
table_schema_field_update_request <- function(name, description) {
  me <- list(
    name = name,
    description = description
  )
  class(me) <= "table_schema_field_update_request"
  me
}
