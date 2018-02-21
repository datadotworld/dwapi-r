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

#' Deserialize \code{get_dataset} response object.
#' @param structure httr response object.
#' @return Object of type \code{\link{dataset_summary_response}}.
#' @seealso \code{\link{get_dataset}}
dataset_summary_response <- function(structure) {
  me <- list(
    # required
    owner = structure$owner,
    id = structure$id,
    title = structure$title,
    visibility = structure$visibility,
    updated = structure$updated,
    created = structure$created,
    status = structure$status,
    # optional
    description = structure$description,
    summary = structure$summary,
    tags = structure$tags,
    license = structure$license,
    files = list()
  )
  if (length(structure$files) > 0) {
    for (i in 1:length(structure$files)) {
      me$files[[i]] <-
        file_summary_response(structure$files[[i]])
    }
  }
  class(me) <- "dataset_summary_response"
  me
}
