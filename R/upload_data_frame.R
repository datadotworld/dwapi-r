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

#' Upload a data frame as a file to a dataset.
#' @param dataset Dataset URL or path.
#' @param data_frame Data frame object.
#' @param file_name File name, including file extension.
#' @return Server response message.
#' @examples
#' df = data.frame(a = c(1,2,3),b = c(4,5,6))
#' \dontrun{
#'   dwapi::upload_data_frame(file_name = 'sample.csv',
#'     data_frame = df, dataset = 'user/dataset')
#' }
#' @export
upload_data_frame <-
  function(dataset, data_frame, file_name) {
    if (!is.data.frame(data_frame)) {
      stop("input is not a data frame")
    }
    if (!endsWith(file_name, ".csv")) {
      stop("we only support upload dataframe as a .csv file")
    }
    tmp_path <- tempfile(fileext = "csv")
    if (!dir.exists(dirname(tmp_path))) {
      dir.create(dirname(tmp_path), recursive = TRUE)
    }
    tryCatch({
      message(sprintf("tmp file %s created.", tmp_path))
      utils::write.csv(
        data_frame,
        file = tmp_path,
        fileEncoding = "UTF-8",
        na = "",
        row.names = FALSE
      )
      ret <-
        dwapi::upload_file(dataset, tmp_path, file_name)
      ret
    },
      finally = {
        unlink(tmp_path, recursive = TRUE)
      })
  }
