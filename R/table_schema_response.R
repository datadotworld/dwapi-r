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

#' Deserialize \code{get_table_schema} response object.
#' @param structure httr response object.
#' @return Object of type \code{table_schema_response}
#' @seealso \code{\link{get_table_schema}}
table_schema_response <- function(structure) {
  me <- list(
    fields = list()
  )
  if (length(structure$fields) > 0) {
    for (i in 1:length(structure$fields)) {
      me$fields[[i]] <-
        table_schema_field_response(structure$fields[[i]])
    }
  }
  class(me) <- "table_schema_response"
  me
}

#' Deserialize \code{get_table_schema} fields.
#' @param structure httr response object
#' @return Object of type \code{table_schema_field_response}
table_schema_field_response <- function(structure) {
  # nolint start
  me <- list(
    name = structure$name,
    title = structure$title,
    description = structure$description,
    rdf_type = structure$rdfType
  )
  # nolint end
  class(me) <= "table_schema_field_response"
  me
}
