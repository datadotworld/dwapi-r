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

#' Download data package.
#'
#' A data package is a portable dataset file format.
#' Learn more about the Data Package specification at
#' \url{http://frictionlessdata.io/data-packages/}.
#'
#' @param dataset Dataset URL or path.
#' @param output_path Directory path, where data package will be saved.
#' @examples
#' \dontrun{
#'   data.world::download_datapackage(
#'     dataset = "user/dataset",
#'     output_path = "tmp/user/dataset")
#' }
#' @export
download_datapackage <- function(dataset, output_path = NULL) {
  dataset_key <- extract_dataset_key(dataset)
  ds_key_parts <- unlist(strsplit(dataset_key, "/", fixed = TRUE))
  if (is.null(output_path)) {
    output_path <- path.expand(file.path(
      getOption("dwapi.cache_dir"),
      ds_key_parts[[1]],
      ds_key_parts[[2]],
      "latest"
    ))
  }
  url <- sprintf("%s/datapackage/%s",
    getOption("dwapi.download_url"),
    dataset)
  response <- httr::GET(
    url,
    httr::add_headers(Authorization = sprintf("Bearer %s", auth_token())),
    httr::progress(),
    httr::user_agent(user_agent())
  )
  httr::stop_for_status(response)

  raw <- httr::content(x = response, as = "raw")
  output_tmp_path <- tempfile()
  if (dir.exists(output_tmp_path)) {
    unlink(output_tmp_path, recursive = TRUE)
  }

  tryCatch({
    dir.create(output_tmp_path,
      recursive = TRUE,
      showWarnings = FALSE)
    zip_file_name <- sprintf("%s/datapackage.zip", output_tmp_path)
    writeBin(raw, zip_file_name)
    extracted <-
      utils::unzip(zip_file_name, overwrite = TRUE, exdir = output_tmp_path)
    descriptor_path <-
      extracted[endsWith(extracted, "datapackage.json")]
    if (is.null(descriptor_path) || length(descriptor_path) == 0) {
      stop(sprintf(
        "%s does not contain a datapackage.json file.",
        zip_file_name
      ))
    } else {
      datapackage_root <- dirname(descriptor_path)
      if (!dir.exists(dirname(output_path))) {
        dir.create(dirname(output_path),
          recursive = TRUE,
          showWarnings = FALSE)
      }
      file.rename(datapackage_root, output_path)
    }
    return(descriptor_path)
  },
    finally = {
      unlink(output_tmp_path, recursive = TRUE)
    })
}
