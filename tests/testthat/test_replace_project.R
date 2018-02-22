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

dw_test_that("replace_project making the correct HTTR request", {
  request <- dwapi::project_replace_request(
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
    `httr::PUT` = function(url, body, header, user_agent)  {
      expect_equal(url,
                   "https://api.data.world/v0/projects/ownerid/projectid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(rjson::toJSON(request), body)
      expect_equal(user_agent$options$useragent, user_agent())
      return(success_message_response())
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::replace_project("ownerid", "projectid",
      replace_project_req = request)
  )
  expect_equal(class(response), "success_message")
})
