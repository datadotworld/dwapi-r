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

#' Deserialize \code{get_dataset} response file sources.
#' @param structure httr response object.
#' @return Object of type \code{file_source_summary_response}
file_source_summary_response <- function(structure) {
  me <- list(
    # nolint start
    # required
    sync_status = structure$syncStatus,
    url = structure$url,
    # optional
    id = structure$id,
    sync_summary = structure$syncSummary,
    last_sync_start = structure$lastSyncStart,
    last_sync_success = structure$lastSyncSuccess,
    last_sync_failure = structure$lastSyncFailure
    # nolint end
  )
  class(me) <- "file_source_summary_response"
  return(me)
}
