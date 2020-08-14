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

dw_test_that("downloadFileAsDataFrame making the correct HTTR request", {
  mock_response_path <- "resources/file1.csv"
  owner <- "ownerid"
  dataset <- "datasetid"
  response <- with_mock(
    `httr::GET` = function(url, header, progress, user_agent)  {
      if (url == paste0(
        "https://api.data.world/v0/file_download/",
        "ownerid/datasetid/file1.csv"
      )) {
        expected <- success_message_with_content(
          mock_response_path, "application/csv")
      } else if (url == paste0(
        "https://query.data.world/tables/ownerid/datasetid/file1/schema"
      )) {
        expected <- success_message_with_content(
          "resources/query.data.world/file1.schema.json",
          "application/json")
      } else {
        fail(paste0("Invalid url: ", url))
      }
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      expected
    },
    `mime::guess_type` = function(...) NULL,
    `dwapi::sparql` = function(owner_id, dataset_id, q) {
      tribble(
        ~filename, ~tablename,
        "file1.csv", "file1"
      )
    },
    dwapi::download_file_as_data_frame(owner, dataset,
      file_name = "file1.csv")
  )
  expect <- readr::read_csv(mock_response_path, col_types = "iicD")
  purrr::walk2(expect, response, function(expect_col, response_col) {
    expect_equal(expect_col, response_col)
  })
  expect_equal(0,
               length(base::setdiff(class(tibble::tibble()), class(response))))
  expect_equal(0, ncol(dplyr::select_if(response, is.factor)))
})

dw_test_that("downloadFileAsDataFrame handles supplied col_types", {
  mock_response_path <- "resources/file1.csv"
  owner <- "ownerid"
  dataset <- "datasetid"
  response <- with_mock(
    `httr::GET` = function(url, header, progress, user_agent)  {
      if (url == paste0(
        "https://api.data.world/v0/file_download/",
        "ownerid/datasetid/file1.csv"
      )) {
        expected <- success_message_with_content(
          mock_response_path, "application/csv")
      } else if (url == paste0(
        "https://query.data.world/tables/ownerid/datasetid/file1/schema"
      )) {
        expected <- success_message_with_content(
          "resources/query.data.world/file1.schema.json",
          "application/json")
      } else {
        fail(paste0("Invalid url: ", url))
      }
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      expected
    },
    `mime::guess_type` = function(...) NULL,
    `dwapi::sparql` = function(owner_id, dataset_id, q) {
      tribble(
        ~filename, ~tablename,
        "file1.csv", "file1"
      )
    },
    dwapi::download_file_as_data_frame(owner, dataset,
                                       file_name = "file1.csv",
                                       col_types = "idcD")
  )
  expect <- readr::read_csv(mock_response_path, col_types = "idcD")
  purrr::walk2(expect, response, function(expect_col, response_col) {
    expect_equal(expect_col, response_col)
  })
  expect_equal(0,
               length(base::setdiff(class(tibble::tibble()), class(response))))
  expect_equal(0, ncol(dplyr::select_if(response, is.factor)))
})
