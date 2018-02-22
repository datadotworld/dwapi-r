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

#' Update an existing project.
#' @param project Project URL or path.
#' @param project_update_req Request object of type \code{\link{project_update_request}}.
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' request <- dwapi::project_update_request(
#'   objective = 'UPDATED OBJECTIVE !')
#'
#' \dontrun{
#'   dwapi::update_project(project_update_req = request,
#'     dataset = 'user/project')
#' }
#' @export
update_project <-
  function(project,
           project_update_req) {
    url <- sprintf(
      "%s/projects/%s",
      getOption("dwapi.api_url"),
      extract_project_key(project))
    auth <- sprintf("Bearer %s", auth_token())
    response <-
      httr::PATCH(
        url,
        body = rjson::toJSON(project_update_req),
        httr::add_headers(`Content-Type` = "application/json",
                          Authorization = auth),
        httr::user_agent(user_agent())
      )
    ret <- parse_success_or_error(response)
    ret
  }
