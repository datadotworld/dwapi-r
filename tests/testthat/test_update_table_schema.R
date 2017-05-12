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

dw_test_that("update_table_schema making the correct HTTR request", {
  request <- dwapi::table_schema_update_request(c(
    table_schema_field_update_request("field1", "description1"),
    table_schema_field_update_request("field2", "description2")
  ))
  response <- with_mock(
    `httr::PATCH` = function(url, body, header, user_agent)  {
      expect_equal(url,
        "https://query.data.world/tables/ownerid/datasetid/tableid/schema")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(body, rjson::toJSON(request))
      expect_equal(user_agent$options$useragent, user_agent())
      return(success_message_response())
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::update_table_schema("ownerid/datasetid", "tableid", request)
  )
  expect_equal(class(response), "success_message")
})
