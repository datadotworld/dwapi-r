"dwapi-r
Copyright 2018 data.world, Inc.

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

#' Get insights for a project.
#' @param project_owner username of the owner of the project.
#' @param project_id identifier of the project.
#' @param limit Maximum number of items to return
#' @param next_page_token Unique token used to retrieve next page
#' @return a named list with at most two elements.  It will
#' always contain a list, named \code{records},
#' of objects of type \code{insight_summary_response}.
#' If the call to \code{get_insights()}
#' was made with a non-null
#' \code{limit} parameter, and if further pages remain for
#' retrieval, then
#' the list will also contain a single-element character vector,
#' named \code{next_page_token},
#' with the token to use in a subsequent call to get the next page.
#' @examples
#' \dontrun{
#'   dwapi::get_insights(project_owner = "user", project_id = "project_id")
#' }
#' @export
get_insights <- function(project_owner, project_id,
                         limit=NULL, next_page_token=NULL) {

  if (!is.null(limit)) {
    if (is.character(limit) & !grepl(x = limit, pattern = "^[0-9]+$")) {
      stop(paste0(
        "limit parameter must be an integer, supplied value was ", limit))
    }
    limit <- as.character(limit)
  }

  query_list <- list(
    "limit" = limit,
    "next" = next_page_token
  )

  url <- paste0(
    getOption("dwapi.api_url"),
    "/", "insights", "/",
    project_owner, "/", project_id)

  auth <- paste0("Bearer ", auth_token())

  response <-
    httr::GET(
      url,
      httr::add_headers(Authorization = auth),
      httr::user_agent(user_agent()),
      query = query_list
    )
  if (response$status_code == 200) {
    structured_response <-
      rjson::fromJSON(httr::content(
        x = response,
        as = "text",
        encoding = "UTF-8"
      ))
    ds_list <- lapply(
      structured_response$records, function(record) {
        insight_summary_response(record)
      })
    ret <- list("records" = ds_list)
    if (!is.null(structured_response[["nextPageToken"]])) {
      ret[["nextPageToken"]] <- structured_response[["nextPageToken"]]
    }
  } else {
    stop_on_insights_error(response)
  }

  ret

}

#' Handle a response containing an error by stopping execution with the
#' embedded message
#' @keywords internal
stop_on_insights_error <- function(response) {
  content <- httr::content(
    x = response,
    as = "text",
    encoding = "UTF-8"
  )
  error_msg <- error_message(rjson::fromJSON(content))
  stop(error_msg$message)
}
