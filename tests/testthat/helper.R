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

dw_test_that <- function(...) {
  auth_token_bkp <- getOption("dwapi.auth_token")
  on.exit({
    options(dwapi.auth_token = auth_token_bkp)
  })

  options(dwapi.auth_token = "API_TOKEN")
  return(testthat::test_that(...))
}

success_message_response <- function() {
  return(
    success_message_response_with_content(
      "resources/api.data.world/v0/SuccessMessage.sample.json",
      "application/json"
    )
  )
}

success_message_response_with_content <-
  function(path_to_local_content, content_type) {
    content <- readBin(path_to_local_content,  what = "raw", n = 1e6)
    return (structure(
      list(
        status_code = 200,
        content = content,
        headers = list("Content-Type", content_type)
      ),
      class = "response"
    ))
  }

cleanup_tmp_dir <- function() {
  unlink(tempdir(), recursive = TRUE, force = FALSE)
}

create_tmp_dir <- function() {
  tmp_dir <- tempdir()
  if(!dir.exists(tmp_dir)) {
    dir.create(tmp_dir, recursive = TRUE)
  }
  return(tmp_dir)
}
