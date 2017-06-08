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

dw_test_that("SPARQL query making the correct HTTR request", {
  sql_query <- "SELECT * WHERE { ?s ?p ?o . }"
  dataset <- "ownerid/datasetid"
  mock_response_path <- "resources/file1.csv"
  query_parameters <- list(
    key1 = "value1",
    "?key2" = 1L,
    "?key3" = 1,
    "?key4" = TRUE,
    "?key5" = 1.5
  )
  response <- with_mock(
    `httr::GET` = function(url, query, header, user_agent)  {
      expect_equal(url,
        sprintf("https://query.data.world/sparql/%s", dataset))
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(header$headers[["Accept"]], "text/csv")
      expect_equal(query[["query"]], sql_query)
      expect_equal(
        query[["parameters"]],
        paste(
          "key1=\"value1\"",
          "?key2=\"1\"^^<http://www.w3.org/2001/XMLSchema#integer>",
          "?key3=\"1\"^^<http://www.w3.org/2001/XMLSchema#decimal>",
          "?key4=\"TRUE\"^^<http://www.w3.org/2001/XMLSchema#boolean>",
          "?key5=\"1.5\"^^<http://www.w3.org/2001/XMLSchema#decimal>",
          sep = ",")
      )
      expect_equal(user_agent$options$useragent, user_agent())
      return(
        success_message_with_content(
          mock_response_path, "application/csv")
      )
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::sparql(
      dataset = dataset,
      query = sql_query,
      query_params = query_parameters
    )
  )
  expect_equal(is.data.frame(response), TRUE)
  expected <- read.csv(mock_response_path)
  expect_equal(all(expected == as.data.frame(response)), TRUE)
})
