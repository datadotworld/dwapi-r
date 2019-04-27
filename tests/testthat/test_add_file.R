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

test_that("add_file to a file_batch_update_request", {
  request <- dwapi::file_batch_update_request()
  expect_equal(0, length(request$files))
  request <-
    dwapi::add_file(request = request,
                    name = "file.csv",
                    url = "https://data.world/some_file.csv")
  expect_equal(1, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  request <-
    dwapi::add_file(request = request,
                    name = "file2.csv",
                    url = "https://data.world/some_file2.csv")
  expect_equal(2, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  expect_equal("file2.csv", request$files[[2]]$name)
})

test_that("add_file to a dataset_create_request", {
  request <- dwapi::dataset_create_request(
    title = "datasetid",
    visibility = "OPEN")
  expect_equal(0, length(request$files))
  request <-
    dwapi::add_file(request = request,
                    name = "file.csv",
                    url = "https://data.world/some_file.csv")
  expect_equal(1, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  request <-
    dwapi::add_file(request = request,
                    name = "file2.csv",
                    url = "https://data.world/some_file2.csv")
  expect_equal(2, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  expect_equal("file2.csv", request$files[[2]]$name)
})

test_that("add_file to a dataset_replace_request", {
  request <- dwapi::dataset_replace_request(
    title = "datasetid",
    visibility = "OPEN")
  expect_equal(0, length(request$files))
  request <-
    dwapi::add_file(request = request,
                    name = "file.csv",
                    url = "https://data.world/some_file.csv")
  expect_equal(1, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  request <-
    dwapi::add_file(request = request,
                    name = "file2.csv",
                    url = "https://data.world/some_file2.csv")
  expect_equal(2, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  expect_equal("file2.csv", request$files[[2]]$name)
})

test_that("add_file to a dataset_update_request", {
  request <- dwapi::dataset_update_request()
  expect_equal(0, length(request$files))
  request <-
    dwapi::add_file(request = request,
                    name = "file.csv",
                    url = "https://data.world/some_file.csv")
  expect_equal(1, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  request <-
    dwapi::add_file(request = request,
                    name = "file2.csv",
                    url = "https://data.world/some_file2.csv")
  expect_equal(2, length(request$files))
  expect_equal("file.csv", request$files[[1]]$name)
  expect_equal("file2.csv", request$files[[2]]$name)
})
