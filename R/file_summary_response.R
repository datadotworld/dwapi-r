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

#' Deserialize \code{get_dataset} response files.
#' @param structure httr response object.
#' @return Object of type \code{file_summary_response}
file_summary_response <- function(structure) {
  me <- list(
    # required
    created = structure$created,
    name = structure$name,
    updated = structure$updated,
    # optional
    description = structure$description,
    labels = structure$labels,
    size_in_bytes = structure$sizeInBytes,
    source = file_source_summary_response(structure$source)
  )
  class(me) <- "file_summary_response"
  return(check_file_summary_response(me))
}

#' Validate \code{get_dataset} response files.
#' @param object Object of type \code{\link{file_summary_response}}
#' @return TRUE/FALSE depending on validity of object.
check_file_summary_response <- function(object) {
  ret <- object
  if (is.null(object$created) |
      is.null(object$name) | is.null(object$updated)) {
    stop("invalid file_summary_response object")
  }
  ret
}
