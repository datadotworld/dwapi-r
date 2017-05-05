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

dw_test_that("downloadFile making the correct HTTR request", {
  tmp_dir <- create_tmp_dir()

  tryCatch ({
    mock_response_local_path <- "resources/file1.csv"
    dataset <- "ownerid/datasetid"
    tmp_output <- sprintf("%sfile1.csv", tmp_dir)
    response <- with_mock(
      `httr::GET` = function(url, header, progress, user_agent)  {
        expect_equal(url,
          sprintf(
            paste(
              "https://download.data.world/file_download/",
              "ownerid/datasetid/file1.csv",
              sep = ""
            ),
            dataset
          ))
        expect_equal(header$headers[["Authorization"]], "Bearer API_TOKEN")
        expect_equal(user_agent$options$useragent, user_agent())
        return(
          success_message_response_with_content(
            mock_response_local_path, "application/csv")
        )
      },
      `mime::guess_type` = function(...)
        NULL,
      dwapi::download_file(
        dataset = dataset,
        file_name = "file1.csv",
        output = tmp_output
      )
    )
    expect <-
      as.data.frame(readr::read_csv(mock_response_local_path))
    actual <- as.data.frame(readr::read_csv(tmp_output))
    expect_equal(all(expect == actual), TRUE)
  },
    finally = {
      cleanup_tmp_dir()
    })
})
