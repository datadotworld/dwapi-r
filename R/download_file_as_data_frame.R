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

#' Download dataset file onto a data frame.
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param file_name File name, including file extension.
#' @param col_types column types specified in the same manner as the
#' col_types parameter of readr::read_csv(), or pass NULL (the default) to
#' detect column types automatically from the data.world table schema
#' @return Data frame with the contents of CSV file.
#' @examples
#' \dontrun{
#'   my_df <- dwapi::download_file_as_data_frame(
#'     "user", "dataset",
#'     file_name = "file.csv")
#' }
#' @export
download_file_as_data_frame <-
  function(owner_id, dataset_id, file_name, col_types = NULL) {
    if (!endsWith(file_name, ".csv")) {
      stop("only support csv extension files.")
    }
    tmp_path <- tempfile(fileext = "csv")
    if (!dir.exists(dirname(tmp_path))) {
      dir.create(dirname(tmp_path), recursive = TRUE)
    }
    tryCatch({
      download_status <-
        dwapi::download_file(owner_id, dataset_id, file_name, tmp_path)
      if (download_status$category == "Success") {
        parse_downloaded_csv(
          tmp_path, owner_id, dataset_id,
          gsub(x = file_name, pattern = "(.+)\\.csv", replacement = "\\1"),
          col_types)
      } else {
        stop(sprintf(
          "Failed to download %s (HTTP Error: %s)",
          file_name,
          download_status
        ))
      }
    },
    finally = {
      unlink(tmp_path, recursive = TRUE)
    })
  }
