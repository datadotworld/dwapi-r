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

#' Fetch latest files from source and update dataset.
#' @param dataset Dataset URL or path.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' \dontrun{
#'   dwapi::sync(dataset='user/dataset')
#' }
#' @export
sync <- function(dataset) {
  url <- sprintf("%s/datasets/%s/sync", getOption("dwapi.api_url"),
    extract_dataset_key(dataset))
  auth <- sprintf("Bearer %s", auth_token())
  response <-
    httr::POST(
      url,
      httr::add_headers(`Content-Type` = "application/json",
        Authorization = auth),
      httr::user_agent(user_agent())
    )
  ret <- parse_success_or_error(response)
  ret
}
