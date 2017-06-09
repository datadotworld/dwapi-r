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

dw_test_that("SQL query making the correct HTTR request", {
  sql_query <- "SELECT * FROM TableName LIMIT 10"
  dataset <- "ownerid/datasetid"
  mock_response_path <- "resources/file1.csv"
  query_parameters <- list("value1", 1L, 1, TRUE, 1.5)
  response <- with_mock(
    `httr::GET` = function(url, query, header, user_agent)  {
      expect_equal(url,
        sprintf("https://query.data.world/sql/%s", dataset))
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Accept"]], "text/csv")
      expect_equal(query[["query"]], sql_query)
      expect_equal(
        query[["parameters"]],
        # nolint start
        paste(
          "$data_world_param0=\"value1\"",
          "$data_world_param1=\"1\"^^<http://www.w3.org/2001/XMLSchema#integer>",
          "$data_world_param2=\"1\"^^<http://www.w3.org/2001/XMLSchema#decimal>",
          "$data_world_param3=\"TRUE\"^^<http://www.w3.org/2001/XMLSchema#boolean>",
          "$data_world_param4=\"1.5\"^^<http://www.w3.org/2001/XMLSchema#decimal>",
          sep = ",")
        # nolint end
      )
      expect_equal(user_agent$options$useragent, user_agent())
      return(
        success_message_with_content(
          mock_response_path, "application/csv")
      )
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::sql(
      dataset = dataset,
      query = sql_query,
      query_params = query_parameters
    )
  )
  expect_equal(is.data.frame(response), TRUE)
  expected <- read.csv(mock_response_path)
  expect_equal(all(expected == as.data.frame(response)), TRUE)
})
