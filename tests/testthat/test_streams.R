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

dw_test_that("stream dataset making the correct HTTR request", {
  test_df <- data.frame(a = 1:5, b = 5:1, stringsAsFactors = FALSE)
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      expect_equal(
        url,
        "https://api.data.world/v0/streams/ownerid/datasetid/streamid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "application/json-l")
      expect_equal(user_agent$options$useragent, user_agent())
      body_conn <- rawConnection(body, "r")
      body_df <- jsonlite::stream_in(body_conn, verbose = FALSE)
      close(body_conn)
      expect_equivalent(body_df, test_df)
      structure(
        list(status_code = 202),
        class = "response"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::append_data_frame_to_stream(
      owner_id = "ownerid",
      dataset_id = "datasetid",
      stream_id = "streamid",
      data_frame = test_df
    )
  )
  expect_equal(response$reason, "Accepted")
  expect_true(grepl(x = response$message, pattern = "Accepted"))
  expect_true(grepl(x = response$message, pattern = "202"))
})

dw_test_that("stream dataset with retries", {
  m_retry <- mockery::mock(invisible())
  m_post <- mockery::mock(invisible())
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      m_post()
      expect_equal(
        url,
        "https://api.data.world/v0/streams/ownerid/datasetid/streamid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "application/json-l")
      expect_equal(user_agent$options$useragent, user_agent())
      structure(
        list(status_code = 429),
        class = "response"
      )
    },
    `httr::RETRY` = function(verb, url, body, header,
                             user_agent, times, pause_min, quiet)  {
      m_retry()
      expect_equal(
        url,
        "https://api.data.world/v0/streams/ownerid/datasetid/streamid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "application/json-l")
      expect_equal(user_agent$options$useragent, user_agent())
      structure(
        list(status_code = 202),
        class = "response"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::append_data_frame_to_stream(
      owner_id = "ownerid",
      dataset_id = "datasetid",
      stream_id = "streamid",
      data_frame = data.frame(a = 1:5, b = 5:1, stringsAsFactors = FALSE)
    )
  )
  mockery::expect_called(m_retry, 1)
  mockery::expect_called(m_post, 1)
  expect_equal(response$reason, "Accepted")
  expect_true(grepl(x = response$message, pattern = "Accepted"))
  expect_true(grepl(x = response$message, pattern = "202"))
})

dw_test_that("stream list making the correct HTTR request", {
  test_list <- list(a = 1, b = "Foo")
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      expect_equal(
        url,
        "https://api.data.world/v0/streams/ownerid/datasetid/streamid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "application/json-l")
      expect_equal(user_agent$options$useragent, user_agent())
      body_conn <- rawConnection(body, "r")
      body_df <- jsonlite::stream_in(body_conn, verbose = FALSE)
      close(body_conn)
      expect_equivalent(body_df, data.frame(test_list,
                                            stringsAsFactors = FALSE))
      structure(
        list(status_code = 202),
        class = "response"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::append_record_to_stream(
      owner_id = "ownerid",
      dataset_id = "datasetid",
      stream_id = "streamid",
      record = test_list
    )
  )
  expect_equal(response$reason, "Accepted")
  expect_true(grepl(x = response$message, pattern = "Accepted"))
  expect_true(grepl(x = response$message, pattern = "202"))
})

dw_test_that("stream values making the correct HTTR request", {
  response <- with_mock(
    `httr::POST` = function(url, body, header, user_agent)  {
      expect_equal(
        url,
        "https://api.data.world/v0/streams/ownerid/datasetid/streamid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Content-Type"]], "application/json-l")
      expect_equal(user_agent$options$useragent, user_agent())
      body_conn <- rawConnection(body, "r")
      body_df <- jsonlite::stream_in(body_conn, verbose = FALSE)
      close(body_conn)
      expect_equivalent(body_df, data.frame(list(a = 1, b = "Foo"),
                                            stringsAsFactors = FALSE))
      structure(
        list(status_code = 202),
        class = "response"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::append_values_to_stream(
      owner_id = "ownerid",
      dataset_id = "datasetid",
      stream_id = "streamid",
      a = 1, b = "Foo"
    )
  )
  expect_equal(response$reason, "Accepted")
  expect_true(grepl(x = response$message, pattern = "Accepted"))
  expect_true(grepl(x = response$message, pattern = "202"))
})

test_that("Invalid record scenarios", {
  # field of length > 1
  expect_error(
    dwapi::append_record_to_stream("ownerid", "datasetid", "streamid",
                                   list(a = 1:2))
  )
  # non-atomic field
  expect_error(
    dwapi::append_record_to_stream("ownerid", "datasetid", "streamid",
                                   list(a = list(a = 1)))
  )
})
