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

dw_test_that("get_table_as_dataframe making the correct HTTR request", {
  mock_response_path <- "resources/file1.csv"
  owner <- "ownerid"
  dataset <- "datasetid"
  response <- with_mock(
    `httr::GET` = function(url, header, progress, user_agent)  {
      expect_equal(
        url, "https://query.data.world/tables/ownerid/datasetid/tableid/rows"
      )
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      return(
        success_message_with_content(
          mock_response_path, "application/csv")
      )
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::download_table_as_data_frame(
      owner, dataset, table_name = "tableid")
  )
  expect <- readr::read_csv(mock_response_path)
  purrr::walk2(expect, response, function(expect_col, response_col) {
    expect_equal(expect_col, response_col)
  })
  expect_equal(0,
               length(base::setdiff(class(tibble::tibble()), class(response))))
  expect_equal(0, ncol(dplyr::select_if(response, is.factor)))
})
