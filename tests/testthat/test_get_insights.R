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

dw_test_that("invalid limit parameter", {
  expect_error(dwapi::get_insights(project_owner = "user",
                                   project_id = "project",
                                   limit = "a"),
               regexp = "must be an integer")
})

dw_test_that("stop_on_insights_error", {
  expect_error(
    with_mock(
      `httr::content` = function(x, as, encoding, ...) {
        error_message_json(404,
                           "94454588-ea84-42ca-aefd-dc63e16390fe",
                           "HTTP 404 Not Found")
      },
      stop_on_insights_error(NULL)),
    regexp = "404"
  )
})

dw_test_that("get_insights, no params, 1 result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/insights/user/project")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetInsightsResponse1.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_insights("user", "project")
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
  for (response_element in response$records) {
    expect_equal(response_element$id, "11223344-aaaa-bbbb-aaaa-aabbccddeeff")
    expect_equal(response_element$author, "user")
  }
})

dw_test_that("get_insights, no params, empty result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/insights/user/project")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetInsightsResponse0.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_insights("user", "project")
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 0)
})

dw_test_that("get_insights, no params, null records", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/insights/user/project")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetInsightsResponseNullRecs.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_insights("user", "project")
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 0)
})

dw_test_that("get_insights, no params, 2 result objects", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/insights/user/project")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetInsightsResponse2.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_insights("user", "project")
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 2)
  for (response_element in response$records) {
    expect_equal(response_element$author, "user")
  }
})

dw_test_that("get_insights, limit of 1, 1 result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/insights/user/project")
      expect_equal(length(query), 2)
      expect_true(!is.null(query$limit))
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetInsightsResponse1WithNext.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_insights("user", "project", limit = 1)
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 2)
  expect_true(!is.null(response[["nextPageToken"]]))
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
  for (response_element in response$records) {
    expect_equal(response_element$id, "11223344-aaaa-bbbb-aaaa-aabbccddeeff")
    expect_equal(response_element$author, "user")
  }
})

dw_test_that("get_insights, limit of 1, 1 result, next page token", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/insights/user/project")
      expect_true(!is.null(query$limit))
      expect_true(!is.null(query$`next`))
      expect_equal(query$`next`, "NPT=")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetInsightsResponse1WithNext.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_insights("user", "project", limit = 1, next_page_token = "NPT=")
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 2)
  expect_true(!is.null(response[["nextPageToken"]]))
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
})
