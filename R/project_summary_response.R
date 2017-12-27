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

projectRequiredFields <- c(
  "accessLevel",
  "created",
  "id",
  "owner",
  "status",
  "title",
  "updated",
  "visibility"
)

projectOptionalFields <- c(
  "objective",
  "summary",
  "license"
)

projectArrayHandlers <- list(
  "tags"=function(tag) tag,
  "files"=file_summary_response,
  "linkedDatasets"=dataset_summary_response
)

#' Deserialize \code{get_project} response object.
#' @param structure httr response object.
#' @return Object of type \code{\link{dataset_project_response}}.
#' @seealso \code{\link{get_project}}
project_summary_response <- function(structure) {

  fields <- c(projectRequiredFields, projectOptionalFields)
  me <- setNames(lapply(fields, function(fieldName) structure[[fieldName]]), fields)
  me <- c(me, setNames(lapply(names(projectArrayHandlers), function(handlerName) {
    f <- projectArrayHandlers[[handlerName]]
    lapply(structure[[handlerName]], f)
  }), names(projectArrayHandlers)))

  class(me) <- "project_summary_response"
  check_project_summary_response(me)

}

#' Validate \code{get_project} response object.
#' @param object Object of type \code{\link{project_summary_response}}.
check_project_summary_response <- function(object) {
  if (class(object) != "project_summary_response") {
    stop("object is not of class project_summary_response")
  }
  if (any(sapply(projectRequiredFields, function(v) {is.null(object[[v]])}))) {
    stop("invalid project_summary_response object")
  }
  object
}
