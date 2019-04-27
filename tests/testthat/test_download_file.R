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

dw_test_that("downloadFile making the correct HTTR request", {
  tmp_dir <- create_tmp_dir()
  mock_response_local_path <- "resources/file1.csv"
  owner <- "ownerid"
  dataset <- "datasetid"
  tmp_output <- file.path(tmp_dir, "file1.csv")
  response <- with_mock(
    `httr::GET` = function(url, header, progress, user_agent)  {
      expect_equal(url,
          paste(
            "https://api.data.world/v0/file_download/",
            "ownerid/datasetid/file1.csv",
            sep = ""
          ))
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      return(
        success_message_with_content(
          mock_response_local_path, "application/csv")
      )
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::download_file(
      owner, dataset,
      file_name = "file1.csv",
      output = tmp_output
    )
  )
  expect <- readr::read_csv(mock_response_local_path)
  actual <- readr::read_csv(tmp_output)
  purrr::walk2(expect, actual, function(expect_col, response_col) {
    expect_equal(expect_col, response_col)
  })
})
