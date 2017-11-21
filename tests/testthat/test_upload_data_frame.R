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

dw_test_that("uploadDataFrame making the correct HTTR request", {
  df <- data.frame(a = c(1, 2, 3), b = c(4, 5, 6))
  response <- with_mock(
    `httr::PUT` = function(url, body, header, progress, user_agent)  {
      expect_equal(url,
        "https://api.data.world/v0/uploads/ownerid/datasetid/files/df.csv")
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(
        header$headers[["Content-Type"]], "application/octet-stream")
      expect_equal(class(body), "form_file")
      actual <- as.data.frame(readr::read_csv(body$path))
      expect_equal(all(df == actual), TRUE)
      expect_equal(user_agent$options$useragent, user_agent())
      return(success_message_response())
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::upload_data_frame(
      dataset = "ownerid/datasetid",
      file_name = "df.csv",
      data_frame = df
    )
  )
  expect_equal(class(response), "success_message")
})
