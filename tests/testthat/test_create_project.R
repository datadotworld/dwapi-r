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

testthat::test_that("errors on project_create_request", {
  expect_error(
    dwapi::project_create_request(
      title = "datasetid",
      visibility = "DISALLOWED"
    ), regexp = "should be one of")
  expect_error(
    dwapi::project_create_request(
      title = "datasetid",
      visibility = "OPEN",
      tags = 1:10
    ), regexp = "character.+integer")
  expect_error(
    dwapi::project_create_request(
      title = "datasetid",
      visibility = "OPEN",
      files = list("A")
    ), regexp = "file_create_request.+character")
  expect_error(
    dwapi::project_create_request(
      title = "datasetid",
      visibility = "OPEN",
      linked_datasets = list("A")
    ), regexp = "linked_dataset_create_or_update_request.+character")
})

dw_test_that("create_project making the correct HTTR request", {
  request <- dwapi::project_create_request(
    title = "datasetid",
    visibility = "OPEN",
    objective = "it's data",
    tags = c("rsdk", "sdk", "arr"),
    license = "Public Domain",
    files = list(
      dwapi::file_create_request(
        url = "https://test...",
        file_name = "foo.csv"
      )
    ),
    linked_datasets = list(
      linked_dataset_create_or_update_request(
        owner = "ownerid",
        id = "datasetid"
      )
    )
  )
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      expect_equal(url,
                   "https://api.data.world/v0/projects/ownerid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(rjson::toJSON(request), body)
      expect_equal(user_agent$options$useragent, user_agent())
      return(
        success_message_with_content(
          "resources/api.data.world/v0/CreateProjectResponse.sample.json",
          "application/json"
        )
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::create_project("ownerid", create_project_req = request)
  )
  expect_equal(class(response), "create_project_response")
})
