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

testthat::test_that("is.blank works", {
  testthat::expect_identical(
    c(TRUE, TRUE, TRUE, FALSE, FALSE),
    is.blank(c(NA_character_, "", " ", "A", "A "))
  )
  testthat::expect_equal(0, length(is.blank(character())))
  testthat::expect_warning({
    testthat::expect_identical(is.blank(c(1L, 2L, NA_integer_)),
                                c(FALSE, FALSE, TRUE))
    },
    regexp = "non-character.+integer"
  )
  testthat::expect_true(is.blank(NULL))
})
