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

#' Execute SPARQL query against a dataset.
#'
#' #' \strong{EXPERIMENTAL}: This is an experimental feature and
#' backwards-compability is not guaranteed in future releases.
#'
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param query SPARQL query.
#' @param query_params List of named query parameters.
#' @return Data frame with data from query results.
#' @examples
#' \dontrun{
#'  dwapi::sparql("user", "dataset",
#'    query="SELECT *
#'           WHERE {
#'             ?s ?p ?o .
#'           } LIMIT 10")
#'
# nolint start
#' dwapi::sparql(dataset="user/dataset",
#'   query="SELECT *
#'          WHERE {
#'          [ :Year ?year ; :Region ?region ; :Indicator_Coverage_and_Disaggregation ?score ]
#'          FILTER(?score > $v1)
#'          } LIMIT 10",
#'   queryParameters = list("$v1"=5.5))
#' }
# nolint end
#' @export
sparql <- function(owner_id, dataset_id, query, query_params = list()) {
  url <- sprintf("%s/sparql/%s/%s",
    getOption("dwapi.query_url"),
    owner_id, dataset_id)
  request_query <- list(query = query)
  if (length(query_params) > 0) {
    request_query$parameters <-
      construct_query_param_str(query_params)
  }
  response <-
    httr::GET(
      url,
      query = request_query,
      httr::add_headers(
        Accept = "text/csv",
        Authorization = sprintf("Bearer %s", auth_token())
      ),
      httr::user_agent(user_agent())
    )
  ret <- httr::http_status(response)
  text <- httr::content(x = response, as = "text")
  if (response$status_code == 200) {
    df <- readr::read_csv(text)
    ret <- df
  } else {
    stop(text)
  }
  ret
}
