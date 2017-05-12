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

#' Library configuration tool.
#'
#' Configuration is not persistent and must be performed for
#' every new R session.
#'
#' @section DO NOT SHARE YOUR AUTHENTICATION TOKEN:
#'
#' For your security, do not include your API authentication token in code that
#' is intended to be shared with others.
#'
#' Call this function via console, always when possible.
#'
#' If you must call it in code do not include the actual API token.
#' Instead, pass the token via a variable in .Renviron, and do not share
#' your .Renviron file. For example:
#'
#' \code{
#'   dwapi::configure(auth_token = Sys.getenv("DW_AUTH_TOKEN"))
#' }
#'
#' @param auth_token data.world's API authentication token.
#' @examples
#' dwapi::configure(auth_token = "YOUR_API_TOKEN_HERE")
#' @export
configure <- function(auth_token = NULL) {
  if (!is.null(auth_token)) {
    options(dwapi.auth_token = auth_token)
  }
  invisible()
}

#' Return the currently configured API authentication token
#'
#' Used by internal functions to obtain auth token required
#' to make API requests. Will fail with an user error to
#' educate users on how to configure their token.
#'
#' @return API token
auth_token <- function() {
  if (!is.null(getOption("dwapi.auth_token"))) {
    return(getOption("dwapi.auth_token"))
  } else {
    stop(paste(
      "API authentication must be configured ",
      "before any functions can be invoked. ",
      "To configure, use dwapi::configure()."))
  }
}
