# 0.3.2

* Fix an issue with `download_file_as_data_frame()` and `download_table_as_data_frame()`
that occurs when the table name (for the table schema) is not the same as the file name.

# 0.3.1

* `download_file_as_data_frame()` and `download_table_as_data_frame()` now use the data.world
  table schema api to set the column types of the imported file/table data; callers can also control
  this explicitly with the `col_types=` parameter to both functions

# 0.3.0

* functions that return data frames return them as tibbles
* `readr::read_csv()` is used behind the scenes now, so returned data frames (tibbles)
  automatically have `stringsAsFactors=FALSE`
* functions that take a dataset or project reference represent that reference consistently
  with separate owner_id and dataset_id (or project_id) parameters
* Minor refactorings for consistency across the package:
  * `dataset_*_request()` functions now take an (optional) parameter of `license=` rather than `license_string=`
  * `tags=` parameter on dataset functions is universally a character vector

# 0.2.2

* Environmental variable updates, version cleanup, unused imports removal.

# 0.2.1

* Change `download_file*()` to use API rather than legacy download.data.world endpoint

# 0.2.0

* Wrapper function `download_dataset()` for /download/{owner}/{id} API endpoint

# 0.1.4

* Configurable hostnames via the DW_ENVIRONMENT, DW_DOWNLOAD_HOST, DW_QUERY_HOST, and DW_API_HOST environmental variables.

# 0.1.3

* Wrapper functions for Streams API:
  * `append_data_frame_to_stream`
  * `append_record_to_stream`
  * `append_values_to_stream`

* Wrapper functions for Projects API:
  * `create_project`
  * `replace_project`
  * `update_project`
  * `get_project`
  * `delete_project`
  * `link_dataset`
  * `unlink_dataset`

* Wrapper functions for Insights API:
  * `get_insight`
  * `get_insights`
  * `delete_insight`
  * `replace_insight`
  * `update_insight`

* Wrapper functions for Datasets API:
  * `delete_dataset`

* Misc improvements and bug fixes

# 0.1.2

* Address compatibility issues with testthat 2.0.0
* Additional wrapper functions for API endpoints
  * `get_user`
  * `get_datasets_user_own`, `get_datasets_user_liked`, `get_datasets_user_contributing`
  * `get_projects_user_own`, `get_projects_user_liked`, `get_projects_user_contributing`
  * `create_insight`

# 0.1.1

* Fix tests making them compliant with CRAN policies
* Improve `quickstart` vignette
* Improve accuracy of documentation and examples

# 0.1.0

* Implement all features of [data.world's REST API](https://docs.data.world/documentation/api)
* First attempted CRAN release
