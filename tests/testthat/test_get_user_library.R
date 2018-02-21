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
  expect_error(dwapi::get_datasets_user_own(limit = "a"),
               regexp = "must be an integer")
})

dw_test_that("get_datasets_own, no params, 1 result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/own")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse1.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_own()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
  for (response_element in response$records) {
    expect_equal(response_element$id, "datasetid")
    expect_equal(response_element$owner, "ownerid")
  }
})

dw_test_that("get_datasets_own, no params, empty result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/own")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse0.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_own()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 0)
})

dw_test_that("get_datasets_own, no params, 2 result objects", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/own")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse2.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_own()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 2)
  for (response_element in response$records) {
    expect_equal(response_element$owner, "ownerid")
  }
})

dw_test_that("get_datasets_own, limit of 1, 1 result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/own")
      expect_equal(length(query), 2)
      expect_true(!is.null(query$limit))
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse1WithNext.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_own(limit = 1)
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 2)
  expect_true(!is.null(response[["nextPageToken"]]))
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
  for (response_element in response$records) {
    expect_equal(response_element$id, "datasetid")
    expect_equal(response_element$owner, "ownerid")
    # no need to test other attributes...defer to get_dataset unit test
  }
})

dw_test_that("get_datasets_own, limit of 1, 1 result, next page token", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/own")
      expect_true(!is.null(query$limit))
      expect_true(!is.null(query$`next`))
      expect_equal(query$`next`, "NPT=")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse1WithNext.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_own(limit = 1, next_page_token = "NPT=")
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 2)
  expect_true(!is.null(response[["nextPageToken"]]))
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
})

dw_test_that("get_datasets_liked, no params, 1 result", {
  # don't need to test all the other scenarios,
  #  since liked uses the same implementation as contributing and own
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/liked")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse1.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_liked()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
})

dw_test_that("get_datasets_contributing, no params, 1 result", {
  # don't need to test all the other scenarios, since
  # contributing uses the same implementation as liked and own
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/datasets/contributing")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetDatasetsResponse1.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_datasets_user_contributing()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
})

dw_test_that("get_projects_own, no params, 1 result", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/projects/own")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        "resources/api.data.world/v0/GetProjectsResponse1.sample.json",
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_projects_user_own()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
  for (response_element in response$records) {
    check_project_summary_response(response_element)
    expect_equal(response_element$id, "projectid")
    expect_equal(response_element$owner, "ownerid")
  }
  p <- response$records[[1]]
  expect_equal(length(p$tags), 2)
  expect_equal(length(p$files), 1)
  expect_equal(length(p[["linkedDatasets"]]), 2)
})

dw_test_that("get_projects_own, no params, 1 result, empty children", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent, query)  {
      expect_equal(url, "https://api.data.world/v0/user/projects/own")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_with_content(
        paste0("resources/api.data.world/v0/",
               "GetProjectsResponseEmptyChildren.sample.json"),
        "application/json"
      )
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::get_projects_user_own()
  )
  expect_equal(class(response), "list")
  expect_equal(length(response), 1)
  expect_equal(class(response$records), "list")
  expect_equal(length(response$records), 1)
  for (response_element in response$records) {
    check_project_summary_response(response_element)
    expect_equal(response_element$id, "projectid")
    expect_equal(response_element$owner, "ownerid")
  }
  p <- response$records[[1]]
  expect_true(!is.null(p$tags))
  expect_true(!is.null(p$files))
  expect_true(!is.null(p$tags))
  expect_equal(length(p$tags), 0)
  expect_equal(length(p[["linkedDatasets"]]), 0)
  expect_equal(length(p[["linkedDatasets"]]), 0)
})
