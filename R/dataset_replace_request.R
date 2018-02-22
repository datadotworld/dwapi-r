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

#' Create request object for replacing existing datasets.
#' @param visibility Dataset visibility ("PRIVATE" or "OPEN").
#' @param title Dataset title
#' @param description (optional) Dataset description.
#' @param summary (optional) Dataset summary (markdown supported).
#' @param tags (optional) List of dataset tags (letters, numbers and spaces).
#' @param files (optional) List of \code{\link{file_create_request}} objects.
#' @param license_string Dataset license ("Public Domain", "PDDL", "CC-0",
#' "CC-BY", "ODC-BY", "CC-BY-SA", "ODC-ODbL", "CC BY-NC-SA" or Other).
#' @return Request object of type \code{dataset_replace_request}.
#' @seealso \code{\link{replace_dataset}}, \code{\link{add_file}}
#' @examples
#' dataset_put_req <- dwapi::dataset_replace_request(visibility = 'OPEN',
#'   description = 'updated description', title = 'updated title')
#' @export
dataset_replace_request <-
  function(title,
    description = NULL,
    summary = NULL,
    tags = NULL,
    license_string = NULL,
    visibility,
    files = NULL) {
    is.nothing <- function(x)
      is.null(x) || is.na(x) || is.nan(x)
    if (visibility != "PRIVATE" & visibility != "OPEN") {
      stop("visibility have to be either PRIVATE or OPEN")
    }
    me <- list()
    me$visibility <- visibility
    me$title <- title
    if (!is.nothing(description)) {
      me$description <- description
    }
    if (!is.nothing(summary)) {
      me$summary <- summary
    }
    if (!is.nothing(tags)) {
      me$tags <- tags
    }
    if (!is.nothing(license_string)) {
      me$license <- license_string
    }
    if (!is.null(files)) {
      me$files <- files
    }
    class(me) <- "dataset_replace_request"
    return(me)
  }
