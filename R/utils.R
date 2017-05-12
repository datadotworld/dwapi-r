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

#' Return the current dwapi version
#' @return Current package version
sdk_version <- function() {
  is.nothing <- function(x)
    is.null(x)
  if (!is.nothing(utils::sessionInfo()$otherPkgs$dwapi)) {
    ret <- utils::sessionInfo()$otherPkgs$dwapi$Version
  } else {
    ret <- "X.X.X"
  }
  ret
}

#' Return the dwapi user-agent
#' @return User-agent string
user_agent <- function() {
  ret <- sprintf("dwapi-R - %s", sdk_version())
  ret
}

#' Extract the dataset key from URL or as provided
#' @param tentative_key key or URL
#' @return dataset key extracted form URL or as provided
extract_dataset_key <- function(tentative_key) {
  url <- httr::parse_url(tentative_key)
  return(url$path)
}

#' Parse simple responses (success or error).
#' @param response httr response.
#' @return Deserialized success or error.
parse_success_or_error <- function(response) {
  success <- response$status_code %in% 200:299
  if (length(response$content > 0)) {
    if (success) {
      return(
        success_message(rjson::fromJSON(httr::content(
          x = response,
          as = "text",
          encoding = "UTF-8"
        ))))
    } else {
      stop(
        error_message(rjson::fromJSON(httr::content(
          x = response,
          as = "text",
          encoding = "UTF-8"
        )))
      )
    }
  } else {
    if (success) {
      return(httr::http_status(response))
    } else {
      stop(httr::http_status(response))
    }
  }
}

construct_query_param_str <- function(query_param_named_list) {
  query_param_strings <-
    lapply(names(query_param_named_list), function(param) {
      sparql_literal <-
        convert_to_sparql_literal(query_param_named_list[[param]])
      paste(param, sparql_literal, sep = "=")
    })
  ret <- paste(query_param_strings, collapse = ",")
  ret
}

convert_to_sparql_literal <- function(v) {
  type <- class(v)
  iri_template <-
    switch(
      type,
      logical = "\"%s\"^^<http://www.w3.org/2001/XMLSchema#boolean>",
      numeric = "\"%s\"^^<http://www.w3.org/2001/XMLSchema#decimal>",
      integer = "\"%s\"^^<http://www.w3.org/2001/XMLSchema#integer>",
      character = "\"%s\""
    )
  if (is.null(iri_template)) {
    stop(
      sprintf(
        "parameter value %s is of not supported type %s.
        Supported types are logical, numeric, integer, character.",
        v,
        type
      )
    )
  }
  return(sprintf(iri_template, v))
}
