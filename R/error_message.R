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

#' Deserialize error response object.
#' @param structure httr response object
#' @return Object of type \code{\link{error_message}}
error_message <- function(structure) {
  me <- list(
    # optional
    code = structure$code,
    message = structure$message,
    details = structure$details
  )
  class(me) <- "error_message"
  return(me)
}
