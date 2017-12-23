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

#' Search for datasets liked by the currently authenticated user.
#' @return a named list with at most two elements.  It will always contain a list, named \code{records},
#' of objects of type \code{\link{dataset_summary_response}}. If the call to \code{get_datasets_user_liked()} was made with a non-null
#' \code{limit} parameter, and if further pages remain for retrieval, then
#' the list will also contain a single-element character vector, named \code{nextPageToken},
#' with the token to use in a subsequent call to get the next page.
#' @examples
#' \dontrun{
#'   dwapi::get_datasets_user_liked()
#' }
#' @export
get_datasets_user_liked <- function(limit=NULL, nextPageToken=NULL, sort=NULL) {
  get_user_library_item('datasets', 'liked', limit, nextPageToken, sort)
}

#' Search for datasets contributed-to by the currently authenticated user.
#' @return a named list with at most two elements.  It will always contain a list, named \code{records},
#' of objects of type \code{\link{dataset_summary_response}}. If the call to \code{get_datasets_user_contributing()} was made with a non-null
#' \code{limit} parameter, and if further pages remain for retrieval, then
#' the list will also contain a single-element character vector, named \code{nextPageToken},
#' with the token to use in a subsequent call to get the next page.
#' @examples
#' \dontrun{
#'   dwapi::get_datasets_user_contributing()
#' }
#' @export
get_datasets_user_contributing <- function(limit=NULL, nextPageToken=NULL, sort=NULL) {
  get_user_library_item('datasets', 'contributing', limit, nextPageToken, sort)
}

#' Search for datasets owned by the currently authenticated user.
#' @return a named list with at most two elements.  It will always contain a list, named \code{records},
#' of objects of type \code{\link{dataset_summary_response}}. If the call to \code{get_datasets_user_own()} was made with a non-null
#' \code{limit} parameter, and if further pages remain for retrieval, then
#' the list will also contain a single-element character vector, named \code{nextPageToken},
#' with the token to use in a subsequent call to get the next page.
#' @examples
#' \dontrun{
#'   dwapi::get_datasets_user_own()
#' }
#' @export
get_datasets_user_own <- function(limit=NULL, nextPageToken=NULL, sort=NULL) {
  get_user_library_item('datasets', 'own', limit, nextPageToken, sort)
}

#' Search for library items owned by, liked by, or contributed-to by the currently authenticated user.
#' @param role the user's role with respect to the asset (one of: own, liked, contributing)
#' @param type the type of asset (one of: datasets, projects)
#' @return a named list with at most two elements.  It will always contain a list, named \code{records},
#' of objects of a list structure type appropriate for the kind of asset queried. If the call to \code{get_datasets()} was made with a non-null
#' \code{limit} parameter, and if further pages remain for retrieval, then
#' the list will also contain a single-element character vector, named \code{nextPageToken},
#' with the token to use in a subsequent call to get the next page.
#' @keywords internal
get_user_library_item <- function(type=c('datasets', 'projects'), role=c('own', 'liked', 'contributing'), limit=NULL, nextPageToken=NULL, sort=NULL) {

  role <- match.arg(role)

  params <- character()

  if (!is.null(limit)) {
    if (!grepl(x=limit, pattern='^[0-9]+$')) {
      stop(paste0('limit parameter must be an integer, supplied value was ', limit))
    }
    params <- c(params, 'limit'=as.character(limit))
  }
  if (!is.null(nextPageToken)) {
    params <- c(params, 'next'=utils::URLencode(nextPageToken, reserved=TRUE))
  }
  if (!is.null(sort)) {
    params <- c(params, 'sort'=utils::URLencode(sort, reserved=TRUE))
  }

  if (length(params) > 0) {
    params <- paste0('?', paste(mapply(paste, names(params), params, USE.NAMES=FALSE, MoreArgs=list('sep'='=')), collapse='&'))
  }

  url <- paste0(getOption("dwapi.api_url"), "/user/", type, "/", role, params)

  auth <- sprintf("Bearer %s", auth_token())

  dsList <- list()

  assetBuilderFunctions <- list(
    'datasets'=dataset_summary_response,
    'projects'=NULL # tbd
  )

  response <-
    httr::GET(
      url,
      httr::add_headers('Content-Type' = "application/json",
                        Authorization = auth),
      httr::user_agent(user_agent())
    )

  if (response$status_code == 200) {
    structured_response <-
      rjson::fromJSON(httr::content(
        x = response,
        as = "text",
        encoding = "UTF-8"
      ))
    if (is.null(structured_response$records)) {
      handle_library_err(response)
    } else {
      dsList <- lapply(structured_response$records, function(assetStructure) {
        assetBuilderFunctions[[type]](assetStructure)
      })
      ret <- list('records'=dsList)
      if (!is.null(structured_response$nextPageToken)) {
        ret$nextPageToken <- structured_response$nextPageToken
      }
    }
  } else {
    handle_library_err(response)
  }

  ret

}

#' Stop execution with a message when the response contains an error condition
#' @param response the response
#' @keywords internal
handle_library_err <- function(response) {
  error_msg <-
    error_message(rjson::fromJSON(httr::content(
      x = response,
      as = "text",
      encoding = "UTF-8"
    )))
  stop(error_msg$message)
}
