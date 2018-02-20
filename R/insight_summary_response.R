"dwapi-r
Copyright 2018 data.world, Inc.

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

#' Get the insight required fields
#' @keywords internal
get_insight_required_fields <- function() {
  c(
    "id",
    "title",
    "body",
    "author",
    "created",
    "updated"
  )
}

#' Get the insight optional fields
#' @keywords internal
get_insight_optional_fields <- function() {
  c(
    "description",
    "sourceLink",
    "dataSourceLinks"
  )
}

#' Deserialize \code{get_insight} response object.
#' @param structure httr response object.
#' @return Object of type \code{\link{insight_summary_response}}.
#' @seealso \code{\link{get_insights}} \code{\link{get_insight}}
#' @importFrom stats setNames
insight_summary_response <- function(structure) {

  fields <- c(get_insight_required_fields(), get_insight_optional_fields())
  ret <- setNames(lapply(
    fields, function(field_name) structure[[field_name]]), fields)

  class(ret) <- "insight_summary_response"
  ret

}
