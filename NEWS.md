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
