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

dw_test_that("addFilesBySource making the correct HTTR request", {
  request <- dwapi::file_batch_update_request()
  request <-
    dwapi::add_file(request = request,
      name = "file.csv",
      url = "https://data.world/some_file.csv")
  request <-
    dwapi::add_file(request = request,
      name = "file2.csv",
      url = "https://data.world/some_file2.csv")
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      expect_equal(url,
        "https://api.data.world/v0/datasets/ownerid/datasetid/files")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(rjson::toJSON(request), body)
      expect_equal(user_agent$options$useragent, user_agent())
      return(success_message_response())
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::add_files_by_source(dataset = "ownerid/datasetid",
      file_batch_update_req = request)
  )
  expect_equal(class(response), "success_message")
})

dw_test_that("addFileBySource making the correct HTTR request", {
  request <- dwapi::file_batch_update_request()
  request <-
    dwapi::add_file(request = request,
      name = "file.csv",
      url = "https://data.world/some_file.csv")
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      expect_equal(url,
        "https://api.data.world/v0/datasets/ownerid/datasetid/files")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(rjson::toJSON(request), body)
      expect_equal(user_agent$options$useragent, user_agent())
      return(success_message_response())
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::add_file_by_source(
      dataset = "ownerid/datasetid",
      name = "file.csv",
      url = "https://data.world/some_file.csv"
    )
  )
  expect_equal(class(response), "success_message")
})
