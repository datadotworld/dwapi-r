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

dw_test_that("get_project, successful query", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url,
                   "https://api.data.world/v0/projects/user/project")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetProjectResponse.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_project("user", "project")
  )
  expect_equal(class(response), "project_summary_response")
  expect_equal(response$owner, "ownerid")
  expect_equal(response$id, "projectid")
})

dw_test_that("get_project, unsuccessful query", {
  expect_error(with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url,
                   "https://api.data.world/v0/projects/user/project")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      error_message_with_content(404, "abc", "No such entity exists.")
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_project("user", "project")
  ), regexp = "No such entity")
})
