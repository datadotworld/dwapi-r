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

#' Append an R data frame to a data.world stream.
#'
#' Append an R data frame to a data.world stream.
#' If the data.world API
#' returns an HTTP status of 429 (Too Many Requests), this function uses
#' \code{\link[httr]{RETRY}} to retry the request.
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param stream_id Stream unique identifier as defined by the user the first
#' time the stream was used. Only lower case letters, numbers and
#' dashes are allowed.
#' @param data_frame The data frame containing the rows to append to the
#' stream
#' @param retry_times the number of times to retry the request
#' @param retry_quiet whether to suppress diagnostic messages during retries
#' @return Server response message.
#' @examples
#' \dontrun{
#'   aDf <- data.frame(ID=1:2, Value=c('One', 'Two'), stringsAsFactors = FALSE)
#'   dwapi::append_data_frame_to_stream(owner_id = 'user',
#'     dataset_id = 'dataset', stream_id = 'mystream',
#'     aDf)
#'   aDf <- data.frame(ID=1:2, Value=c('One', 'Two'), stringsAsFactors = FALSE)
#'   dwapi::append_data_frame_to_stream(owner_id = 'user',
#'     dataset_id = 'dataset', stream_id = 'mystream',
#'     aDf, retry_times = 10, retry_quiet = TRUE)
#' }
#' @export
append_data_frame_to_stream <- function(owner_id, dataset_id,
                                        stream_id, data_frame,
                                        retry_times = 3,
                                        retry_quiet = FALSE) {

  url <- paste0(getOption("dwapi.api_url"), "/", "streams", "/",
                owner_id, "/", dataset_id, "/", stream_id)

  auth <- sprintf("Bearer %s", auth_token())
  content_type <- "application/json-l"

  conn <- rawConnection(raw(0), open = "w")
  jsonlite::stream_out(data_frame, conn, verbose = FALSE)
  body <- rawConnectionValue(conn)
  close(conn)

  post_message <- function(http_verb, ...) {
    http_verb(
      url,
      body = body,
      httr::add_headers(
        `Content-Type` = content_type,
        Authorization = auth
      ),
      httr::user_agent(user_agent()),
      ...
    )
  }

  response <- post_message(httr::POST)
  if (response$status_code == 429) {

    wait_period <- response$header[["retry-after"]]
    wait_period <- as.numeric(wait_period)

    response <- post_message(http_verb = httr::RETRY,
                             verb = "POST",
                             times = retry_times,
                             pause_min = wait_period,
                             quiet = retry_quiet)

  }

  ret <- httr::http_status(response)

  if (!(response$status_code == 200 | response$status_code == 202)) {
      error_msg <-
      error_message(rjson::fromJSON(httr::content(
        x = response,
        as = "text",
        encoding = "UTF-8"
      )))
    stop(error_msg$message)
  }

  ret

}

#' Append a record, consisting of a list of depth one, to a stream.
#'
#' Append a record, consisting of a list of depth one, to a stream.
#' The list
#' must consist of atomic vectors of length one.  If the data.world API
#' returns an HTTP status of 429 (Too Many Requests), this function uses
#' \code{\link[httr]{RETRY}} to retry the request.
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param stream_id Stream unique identifier as defined by the user the first
#' time the stream was used. Only lower case letters, numbers and
#' dashes are allowed.
#' @param record the record list
#' @param retry_times the number of times to retry the request
#' @param retry_quiet whether to suppress diagnostic messages during retries
#' @return Server response message.
#' @examples
#' \dontrun{
#'   record <- list(ID=1, Value='One')
#'   dwapi::append_record_to_stream(owner_id = 'user',
#'     dataset_id = 'dataset', stream_id = 'mystream',
#'     record)
#' }
#' @export
append_record_to_stream <- function(owner_id, dataset_id,
                                    stream_id, record,
                                    retry_times = 3,
                                    retry_quiet = FALSE) {

  if (!is.list(record)) {
    stop(paste0("append_list_to_stream requires representation of the record ",
                "as a list"))
  }

  record <- lapply(record, function(element) {
    if (!is.atomic(element) | length(element) != 1) {
      stop("Each element of record must be an atomic vector of length 1")
    }
    element
  })

  append_data_frame_to_stream(owner_id, dataset_id, stream_id,
                              data.frame(record, stringsAsFactors = FALSE),
                              retry_times, retry_quiet)

}

#' Append a record, consisting of named parameters, to a stream.
#'
#' Append a record, consisting of named parameters, to a stream.
#' Each value
#' must be an atomic vector of length one.  If the data.world API
#' returns an HTTP status of 429 (Too Many Requests), this function uses
#' \code{\link[httr]{RETRY}} to retry the request.
#' @param owner_id User name and unique identifier of the creator of a
#' dataset or project
#' @param dataset_id Dataset unique identifier
#' @param stream_id Stream unique identifier as defined by the user the first
#' time the stream was used. Only lower case letters, numbers and
#' dashes are allowed.
#' @param ... named parameters giving the variables and values in the record
#' to be streamed
#' @param retry_times the number of times to retry the request
#' @param retry_quiet whether to suppress diagnostic messages during retries
#' @return Server response message.
#' @examples
#' \dontrun{
#'   dwapi::append_values_to_stream(owner_id = 'user',
#'     dataset_id = 'dataset', stream_id = 'mystream',
#'     ID=1, Value='One')
#' }
#' @export
append_values_to_stream <- function(owner_id, dataset_id,
                                    stream_id,
                                    retry_times = 3,
                                    retry_quiet = FALSE, ...) {

  record <- list(...)

  record <- lapply(record, function(element) {
    if (!is.atomic(element) | length(element) != 1) {
      stop("Each value to be streamed must be an atomic vector of length 1")
    }
    element
  })

  append_record_to_stream(owner_id, dataset_id, stream_id,
                          record,
                          retry_times, retry_quiet)

}
