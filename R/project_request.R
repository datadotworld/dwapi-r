"dwapi-r
Copyright 2018 data.world, Inc.

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

#' Create request object for new projects.
#' @param title Project title.
#' @param visibility Project visibility, must be PRIVATE or OPEN.
#' @param objective (optional) Short project objective.
#' @param summary (optional) Long-form project summary (Markdown supported).
#' @param tags Character vector of project tags (letters, numbers and spaces).
#' @param license Dataset license ("Public Domain", "PDDL", "CC-0",
#' "CC-BY", "ODC-BY", "CC-BY-SA", "ODC-ODbL", "CC BY-NC-SA" or Other).
#' @param files (optional) List of \code{\link{file_create_request}} objects.
#' @param linked_datasets List of
#' \code{\link{linked_dataset_create_or_update_request}} objects.
#' @return Request object of type \code{project_create_request}.
#' @seealso \code{\link{create_project}}
#' @examples
#' request <- dwapi::project_create_request(title='My Project', visibility = 'OPEN',
#'   objective = 'objective', tags = c('sdk') , license = 'Public Domain')
#' @export
project_create_request <-
  function(title,
           visibility = c("PRIVATE", "OPEN"),
           objective = NULL,
           summary = NULL,
           tags = character(),
           license = NULL,
           files = list(),
           linked_datasets = list()) {

    validate_project_request_params(visibility, tags, files, linked_datasets)

    ret <- base_project_request(title,
                                visibility,
                                objective,
                                summary,
                                tags,
                                license,
                                files,
                                linked_datasets,
                                "project_create_request")

  }

#' Create request object for replacement of existing projects.
#' @param title Project title.
#' @param visibility Project visibility, must be PRIVATE or OPEN.
#' @param objective (optional) Short project objective.
#' @param summary (optional) Long-form project summary (Markdown supported).
#' @param tags Character vector of project tags (letters, numbers and spaces).
#' @param license Dataset license ("Public Domain", "PDDL", "CC-0",
#' "CC-BY", "ODC-BY", "CC-BY-SA", "ODC-ODbL", "CC BY-NC-SA" or Other).
#' @param files (optional) List of \code{\link{file_create_request}} objects.
#' @param linked_datasets List of
#' \code{\link{linked_dataset_create_or_update_request}} objects.
#' @return Request object of type \code{project_replace_request}.
#' @seealso \code{\link{replace_project}}
#' @examples
#' request <- dwapi::project_replace_request(title='My Project', visibility = 'OPEN',
#'   objective = 'objective', tags = c('sdk') , license = 'Public Domain')
#' @export
project_replace_request <-
  function(title,
           visibility = c("PRIVATE", "OPEN"),
           objective = NULL,
           summary = NULL,
           tags = character(),
           license = NULL,
           files = list(),
           linked_datasets = list()) {

    validate_project_request_params(visibility, tags, files, linked_datasets)

    ret <- base_project_request(title,
                                visibility,
                                objective,
                                summary,
                                tags,
                                license,
                                files,
                                linked_datasets,
                                "project_replace_request")

  }

#' Create request object to update existing projects.
#' @param title Project title.
#' @param visibility Project visibility, must be PRIVATE or OPEN.
#' @param objective (optional) Short project objective.
#' @param summary (optional) Long-form project summary (Markdown supported).
#' @param tags Character vector of project tags (letters, numbers and spaces).
#' @param license Dataset license ("Public Domain", "PDDL", "CC-0",
#' "CC-BY", "ODC-BY", "CC-BY-SA", "ODC-ODbL", "CC BY-NC-SA" or Other).
#' @param files (optional) List of \code{\link{file_create_request}} objects.
#' @param linked_datasets List of
#' \code{\link{linked_dataset_create_or_update_request}} objects.
#' @return Request object of type \code{project_update_request}.
#' @seealso \code{\link{update_project}}
#' @examples
#' request <- dwapi::project_update_request(title='My Project', visibility = 'OPEN',
#'   objective = 'objective', tags = c('sdk') , license = 'Public Domain')
#' @export
project_update_request <-
  function(title = NULL,
           visibility = NULL,
           objective = NULL,
           summary = NULL,
           tags = NULL,
           license = NULL,
           files = NULL,
           linked_datasets = NULL) {

    ret <- base_project_request(title,
                                visibility,
                                objective,
                                summary,
                                tags,
                                license,
                                files,
                                linked_datasets,
                                "project_update_request")

    ret <- Filter(Negate(is.null), ret)
    ret <- Filter(length, ret) # removes empty body child

    ret

  }

validate_project_request_params <- function(visibility = c("PRIVATE", "OPEN"),
                                            tags,
                                            files, linked_datasets) {

  visibility <- match.arg(visibility)

  if (!is.character(tags)) {
    stop(paste0("tags must specify a character vector; encountered type ",
                "of ", class(tags)))
  }

  files <- lapply(files, function(item) {
    if (class(item) != "file_create_request") {
      stop(paste0("All members of files list must be of type ",
                  "file_create_request; ",
                  "found an element of type ", class(item)))
    }
    item
  })

  linked_datasets <- lapply(linked_datasets, function(item) {
    if (class(item) != "linked_dataset_create_or_update_request") {
      stop(paste0("All members of linked_datasets list must be of type ",
                  "linked_dataset_create_or_update_request; ",
                  "found an element of type ", class(item)))
    }
    item
  })

}

base_project_request <-
  function(title = NULL,
           visibility = NULL,
           objective = NULL,
           summary = NULL,
           tags = NULL,
           license = NULL,
           files = NULL,
           linked_datasets = NULL, request_class) {

    ret <- list(
      title = title,
      visibility = visibility,
      objective = objective,
      summary = summary,
      tags = tags,
      license = license,
      files = files,
      linkedDatasets = linked_datasets
    )

    class(ret) <- request_class

    ret

  }
