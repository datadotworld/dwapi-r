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

#' Create request object for adding or updating dataset files.
#' @param file_sources (optional) List of \code{\link{file_create_or_update_request}} objects.
#' @return Object of type \code{file_batch_update_request}.
#' @seealso \code{\link{add_files_by_source}}, \code{\link{add_file}}
#' @examples
#' request <- dwapi::file_batch_update_request()
#' request <- dwapi::add_file(
#'   request = request, name = 'file.csv', url = 'http://data.world/file.csv')
#' @export
file_batch_update_request <- function(file_sources = list()) {
  if (!is.list(file_sources)) {
    stop("file_sources must be an array")
  }
  me <- list(files = file_sources)
  class(me) <- "file_batch_update_request"
  return(me)
}
