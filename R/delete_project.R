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

#' Delete a project.
#' @param project_owner ID of project owner
#' @param project_id ID of project to delete
#' @return Object of type \code{\link{success_message}}.
#' @examples
#' \dontrun{
#'   dwapi::delete_project(
#'     project_owner = 'user',
#'     project_id = 'project')
#' }
#' @export
delete_project <-
  function(project_owner, project_id) {

    url <- paste0(getOption("dwapi.api_url"), "/", "projects", "/",
                  project_owner, "/", project_id)
    auth <- paste0("Bearer ", auth_token())

    response <-
      httr::DELETE(
        url,
        httr::add_headers(`Content-Type` = "application/json",
                          Authorization = auth),
        httr::user_agent(user_agent())
      )

    parse_success_or_error(response)

  }
