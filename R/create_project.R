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

#' Create a new project.
#' @param owner_id data.world user name of the project owner.
#' @param create_project_req Request object of type \code{\link{project_create_request}}.
#' @return Object of type \code{\link{create_project_response}}.
#' @examples
#' request <- dwapi::project_create_request(
#'   title='testproject', visibility = 'OPEN',
#'   objective = 'Test project by R-SDK', tags = c('rsdk', 'sdk', 'arr'),
#'   license = 'Public Domain')
#'
#' request <- dwapi::add_file(request = request, name = 'file4.csv',
#'   url = 'https://data.world/file4.csv')
#'
#' \dontrun{
#' dwapi::create_project(create_project_req = request,
#'   owner_id = 'user')
#' }
#' @export
create_project <- function(owner_id, create_project_req) {

  url <- paste0(getOption("dwapi.api_url"), "/", "projects", "/", owner_id)

  auth <- sprintf("Bearer %s", auth_token())
  accept_header <- "application/json"
  content_type <- "application/json"
  response <-
    httr::POST(
      url,
      body = rjson::toJSON(create_project_req),
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
      create_project_response(rjson::fromJSON(httr::content(
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

#' De-serialize a structured list into create_project_reponse object.
#' @param structure httr response object.
#' @return Object of type \code{\link{create_project_response}}.
create_project_response <- function(structure) {
  me <- list(uri = structure$uri,
             # optional
             message = structure$message)
  class(me) <- "create_project_response"
  me
}
