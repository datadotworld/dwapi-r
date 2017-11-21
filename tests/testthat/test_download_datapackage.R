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

dw_test_that("download_datapackage produces valid directory structure", {
  mock_response_path <- "resources/datapackage.zip"
  dataset <- "jonloyens/an-intro-to-dataworld-dataset"
  output_path <- tempfile()
  response <- with_mock(
    `httr::GET` = function(url, header, progress, user_agent)  {
      expect_equal(url,
        sprintf("https://download.data.world/datapackage/%s", dataset))
      expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
      expect_equal(user_agent$options$useragent, user_agent())
      return(
        success_message_with_content(
          mock_response_path, "application/zip")
      )
    },
    `mime::guess_type` = function(...)
      NULL,
    dwapi::download_datapackage(
      dataset = dataset,
      output_path = output_path
    )
  )
  expect(
    "datapackage.json" %in% list.files(output_path),
    sprintf("%s directory must contain datapackage.json file.", output_path))
})
