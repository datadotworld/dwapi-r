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

#' Create request object for new datasets.
#' @param title Dataset title (3 to 60 characters).
#' @param visibility Dataset visibility ("PRIVATE" or "OPEN").
#' @param description (optional) Dataset description.
#' @param summary (optional) Dataset summary (markdown supported).
#' @param tags (optional) List of dataset tags (letters, numbers and spaces).
#' @param file_create_requests (optional) List of \code{\link{file_create_request}} objects.
#' @param license_string Dataset license ("Public Domain", "PDDL", "CC-0",
#' "CC-BY", "ODC-BY", "CC-BY-SA", "ODC-ODbL", "CC BY-NC-SA" or Other).
#' @return Request object of type \code{dataset_create_request}.
#' @seealso \code{\link{create_dataset}}, \code{\link{add_file}}
#' @examples
#' request <- dwapi::dataset_create_request(title='datasetid', visibility = 'OPEN',
#'   description = 'description', tags = c('sdk') , license_string = 'Public Domain')
#' request <- dwapi::add_file(request = request, name = 'file.csv',
#'   url = 'http://data.world/file.csv')
#' @export
dataset_create_request <-
  function(title,
    visibility,
    description = "",
    summary = "",
    tags = list(),
    license_string = "",
    file_create_requests
    = list()) {
    if (title == "") {
      stop("title can't be empty")
    }

    if (visibility != "PRIVATE" & visibility != "OPEN") {
      stop("visibility have to be either PRIVATE or OPEN")
    }

    me <-
      list(
        title = title,
        visibility = visibility,
        description = description,
        summary = summary,
        tags = tags,
        license = license_string,
        files = file_create_requests
      )
    class(me) <- "dataset_create_request"
    return(me)
  }
