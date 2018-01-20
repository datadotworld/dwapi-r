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

dw_test_that("update_insight making the correct HTTP request", {
  request <- dwapi::insight_update_request(
    title = "iid",
    description = "description",
    image_url = "https://test"
  )
  expect_true(setequal(c("title", "description", "body"), names(request)))
  expect_equal(request$body[["imageUrl"]], "https://test")
  response <- with_mock(
    `httr::PATCH` = function(url, body, header, user_agent)  {
      expect_equal(url,
                   "https://api.data.world/v0/insights/ownerid/projectid/iid")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(rjson::toJSON(request), body)
      expect_equal(user_agent$options$useragent, user_agent())
      success_message_response()
    },
    `mime::guess_type` = function(...) NULL,
    dwapi::update_insight("ownerid", "projectid", "iid", request)
  )
  expect_equal(class(response), "success_message")
})
