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

#' Create an insight.
#' @param project_owner ID of project owner
#' @param project_id ID of project to which insight is to be added
#' @param create_insight_req Request object of
#' type \code{\link{insight_create_request}}.
#' @return Object of type \code{\link{create_insight_response}}.
#' @examples
#' \dontrun{
#'   dwapi::create_insight(
#'     project_owner = 'user',
#'     project_id = 'project',
#'     insight_create_request(title='My Insight', image_url='https://...'))
#' }
#' @export
create_insight <-
  function(project_owner, project_id, create_insight_req) {

    url <- paste0(getOption("dwapi.api_url"), "/", "insights", "/",
                  project_owner, "/", project_id)
    auth <- paste0("Bearer ", auth_token())
    accept_header <- "application/json"
    content_type <- "application/json"

    response <-
      httr::POST(
        url,
        body = rjson::toJSON(create_insight_req),
        httr::add_headers(
          Accept = accept_header,
          `Content-Type` = content_type,
          Authorization = auth
        ),
        httr::user_agent(user_agent())
      )
    ret <- httr::http_status(response)
    if (response$status_code == 200 | response$status_code == 202) {
      ret <-
        create_insight_response(rjson::fromJSON(httr::content(
          x = response,
          as = "text",
          encoding = "UTF-8"
        )))
    } else {
      error_msg <-
        error_message(rjson::fromJSON(httr::content(
          x = response,
          as = "text",
          encoding = "UTF-8"
        )))
      stop(error_msg$message)
    }
    ret
  }

#' De-serialize a structured list into create_insight_response object.
#' @param structure httr response object.
#' @return Object of type \code{\link{create_insight_response}}.
#' @keywords internal
create_insight_response <- function(structure) {
  me <- list(uri = structure$uri,
             # optional
             message = structure$message)
  class(me) <- "create_insight_response"
  me
}
