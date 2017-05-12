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

#' Execute SQL query against a dataset.
#' @param dataset Dataset URL or path.
#' @param query SQL query.
#' @param query_params List of positional query parameters.
#' @return Data frame with data from query results.
#' @examples
#' \dontrun{
#'   dwapi::sql(dataset="user/dataset",
#'     query="SELECT *
#'            FROM TableName
#'            LIMIT 10")
#'
#'   dwapi::sql(dataset="user/dataset",
#'     query="SELECT *
#'            FROM TableName where `field1` = ? AND `field2` > ?
#'            LIMIT 10",
#'     queryParameters = list("value", 5.0))
#' }
#' @export
sql <- function(dataset, query, query_params = list()) {
  url <- sprintf("%s/sql/%s",
    getOption("dwapi.query_url"),
    extract_dataset_key(dataset))
  request_query <- list(query = query)
  if (length(query_params) > 0) {
    named_query_params <- list()
    for (i in 0:(length(query_params) - 1)) {
      named_query_params[[paste("$data_world_param", i, sep = "")]] <-
        query_params[[i + 1]]
    }
    request_query$parameters <-
      construct_query_param_str(named_query_params)
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
