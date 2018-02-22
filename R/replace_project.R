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

#' Create a new project with a specific ID, replacing a project with that ID
#' if it exists.
#' @param owner_id data.world user name of the project owner.
#' @param project_id identifier to use for the new project, or identifier of
#' existing project to replace with the newly created project.
#' @param replace_project_req Request object of type \code{\link{project_replace_request}}.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' request <- dwapi::project_replace_request(
#'   title='testproject', visibility = 'OPEN',
#'   objective = 'Test project by R-SDK', tags = c('rsdk', 'sdk', 'arr'),
#'   license = 'Public Domain')
#'
#' request <- dwapi::add_file(request = request, name = 'file4.csv',
#'   url = 'https://data.world/file4.csv')
#'
#' \dontrun{
#' dwapi::replace_project(create_project_req = request,
#'   owner_id = 'user', project_id = 'projectid')
#' }
#' @export
replace_project <- function(owner_id, project_id, replace_project_req) {

  url <- paste0(getOption("dwapi.api_url"), "/", "projects", "/", owner_id)

  if (!is.null(project_id)) {
    url <- paste0(url, "/", project_id)
  }

  auth <- sprintf("Bearer %s", auth_token())
  accept_header <- "application/json"
  content_type <- "application/json"
  response <-
    httr::PUT(
      url,
      body = rjson::toJSON(replace_project_req),
      httr::add_headers(
        Accept = accept_header,
        `Content-Type` = content_type,
        Authorization = auth
      ),
      httr::user_agent(user_agent())
    )
  ret <- parse_success_or_error(response)
  ret
}
