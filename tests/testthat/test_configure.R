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

test_that("should configure should set the token", {
    auth_token_bkp <- getOption("dwapi.auth_token")
    expect_null(auth_token_bkp)
    configure("TEST")
    auth_token_bkp <- getOption("dwapi.auth_token")
    expect_equal(auth_token_bkp, "TEST")
})

test_that("should set default urls", {
    options <- .onLoad()
    expect_equivalent(options["dwapi.api_url"], "https://api.data.world/v0")
    expect_equivalent(options["dwapi.download_url"],
                      "https://download.data.world")
    expect_equivalent(options["dwapi.query_url"], "https://query.data.world")
})

test_that("should allow environment to be overridden", {
    f <- function(x) {
        .onLoad()
    }
    options <- with_mock(
        Sys.getenv = function(x) {
            ifelse(
                x == "DW_ENVIRONMENT",
                "x",
                ""
            )
        },
        f()
    )
    expect_equivalent(options["dwapi.api_url"], "https://x.api.data.world/v0")
    expect_equivalent(options["dwapi.download_url"],
                      "https://x.download.data.world")
    expect_equivalent(options["dwapi.query_url"], "https://x.query.data.world")
})

test_that("should allow DW_DOWNLOAD_HOST to be overridden", {
    f <- function(x) {
        .onLoad()
    }
    test <- "http://test.download.url"
    options <- with_mock(
        Sys.getenv = function(x) {
            ifelse(
                x == "DW_DOWNLOAD_HOST",
                test,
                ""
            )
        },
        f()
    )
    expect_equivalent(options["dwapi.download_url"], test)
})
