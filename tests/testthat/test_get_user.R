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

dw_test_that("get_user making the correct HTTR request", {
  response <- with_mock(
    `httr::GET` = function(url, header, user_agent)  {
      expect_equal(url,
                   "https://api.data.world/v0/user")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())

      return(
        success_message_with_content(
          "resources/api.data.world/v0/UserInfoResponse.sample.json",
          "application/json"
        )
      )
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::get_user()
  )
  expect_equal(class(response), "user_info_response")
  check_user_info_response(response)
  expect_equal(response[["avatarUrl"]],
               "https://cdn.filepicker.io/api/file/ABCDEF1234567890")
  expect_equal(response$id, "ownerid")
  expect_equal(response[["displayName"]], "DW User")
  expect_equal(response$created, "2017-01-11T01:35:35.426Z")
  expect_equal(response$updated, "2017-11-02T16:08:36.509Z")
})
