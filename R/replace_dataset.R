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

#' Replace an existing dataset.
#' @param dataset Dataset URL or path.
#' @param dataset_replace_req Request object of type \code{\link{dataset_replace_request}}.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' dataset_replace_req <- dwapi::dataset_replace_request(visibility = 'OPEN',
#'  description = 'UPDATED DESCRIPTION !')
#' \dontrun{
#'   dwapi::replace_dataset('user/dataset', dataset_replace_req)
#' }
#' @export
replace_dataset <-
  function(dataset, dataset_replace_req) {
    url <- sprintf("%s/datasets/%s", getOption("dwapi.api_url"),
      extract_dataset_key(dataset))
    message(url)
    auth <- sprintf("Bearer %s", auth_token())
    response <-
      httr::PUT(
        url,
        body = rjson::toJSON(dataset_replace_req),
        httr::add_headers(`Content-Type` = "application/json",
          Authorization = auth),
        httr::user_agent(user_agent())
      )
    ret <- parse_success_or_error(response)
    ret
  }
