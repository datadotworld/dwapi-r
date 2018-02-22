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

#' Deserialize \code{get_user} response object.
#' @param structure httr response object.
#' @return Object of type \code{\link{user_info_response}}.
#' @seealso \code{\link{get_dataset}}
user_info_response <- function(structure) {
  required_elements <- get_required_elements()
  optional_elements <- get_optional_elements()
  me <- c(structure[required_elements], structure[optional_elements])
  class(me) <- "user_info_response"
  return(check_user_info_response(me))
}

get_required_elements <- function() {
  c("id", "created", "updated")
}

get_optional_elements <- function() {
  c("avatarUrl", "displayName")
}

#' Validate \code{get_user} response object, returning the object if valid, and stopping with an error message if invalid.
#' @param object Object of type \code{\link{user_info_response}}.
#' @return the object
check_user_info_response <- function(object) {
  if (class(object) != "user_info_response") {
    stop("object is not of class user_info_response")
  }
  ret <- object
  if (!all(sapply(get_required_elements(), function(v) {
    !is.null(object[[v]])
  }
  ))) {
    stop("invalid user_info_response object")
  }
  ret
}
