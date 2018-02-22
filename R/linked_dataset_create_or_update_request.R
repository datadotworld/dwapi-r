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

#' Create request object for new linked datasets, or updates to existing
#' datasets.
#' @param owner User name and unique identifier of the creator of the dataset.
#' @param id Unique identifier of dataset.
#' @return Request object of type \code{linked_dataset_create_or_update_request}.
#' @seealso \code{\link{create_project}}
#' @examples
#' request <- dwapi::linked_dataset_create_or_update_request(
#'   owner = 'ownerId', id = 'datasetId')
#' @export
linked_dataset_create_or_update_request <- function(owner, id) {

    ret <- list(
      owner = owner,
      id = id
    )

    class(ret) <- "linked_dataset_create_or_update_request"

    ret

  }
