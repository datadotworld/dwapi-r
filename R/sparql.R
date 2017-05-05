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
#' @param dataset Dataset URL or path.
#' @param query SPARQL query.
#' @param query_params List of named query parameters.
#' @return Data frame with data from query results.
#' @examples
#' \dontrun{
#'  dwapi::sparql(dataset="user/dataset",
#'    query="SELECT *
#'           WHERE {
#'             ?s ?p ?o .
#'           } LIMIT 10")
#'
#' dwapi::sparql(dataset="user/dataset",
#'   query="SELECT *
#'          WHERE {
#'          [ :Year ?year ; :Region ?region ; :Indicator_Coverage_and_Disaggregation ?score ]
#'          FILTER(?score > $v1)
#'          } LIMIT 10",
#'   queryParameters = list("$v1"=5.5))
#' }
#' @export
sparql <- function(dataset, query, query_params = list()) {
  url <- sprintf("%s/sparql/%s",
    getOption("dwapi.query_url"),
    extract_dataset_key(dataset))
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
