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

dw_test_that("uploadFile making the correct HTTR request", {
  local_path <- "resources/file1.csv"
  expected <- curl::form_file(local_path)
  response <- with_mock(
    `httr::PUT` = function(url, body, header, progress, user_agent)  {
      expect_equal(url,
        "https://api.data.world/v0/uploads/ownerid/datasetid/files/file1.csv")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "application/octet-stream")
      expect_equal(class(body), "form_file")
      expect_equal(user_agent$options$useragent, user_agent())
      expect_equal(body$path, expected$path)
      return(success_message_response())
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::upload_file(
      file_name = "file1.csv",
      path = local_path,
      dataset = "ownerid/datasetid"
    )
  )
  expect_equal(class(response), "success_message")
})

dw_test_that("uploadFiles making the correct HTTR request", {
  local_path1 <- "resources/file1.csv"
  local_path2 <- "resources/file2.csv"
  response <- with_mock(
    `httr::POST` = function(url, body, header, progress, user_agent)  {
      expect_equal(url,
        "https://api.data.world/v0/uploads/ownerid/datasetid/files")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "multipart/form-data")
      expect_equal(names(body), c("file", "file"))
      expect_equal(curl::form_file(local_path1)$path, body[[1]]$path)
      expect_equal(curl::form_file(local_path2)$path, body[[2]]$path)
      expect_equal(user_agent$options$useragent, user_agent())
      return(success_message_response())
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::upload_files(
      dataset = "ownerid/datasetid",
      paths = list (local_path1, local_path2)
    )
  )
  expect_equal(class(response), "success_message")
})
