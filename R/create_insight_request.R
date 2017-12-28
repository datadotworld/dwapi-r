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

#' Create insight object for new insights
#' @param title Insight title
#' @param description Optional insight description
#' @param image_url URL of image representing the insight
#' @param embed_url URL of content to embed
#' @param markdown_body Markdown text containing the insight
#' @param source_link Permalink to source code or platform this
#' insight was generated with
#' @param data_source_links List containing one or more permalinks
#' to the data sources used to generate this insight
#' @return Request object of type \code{insight_create_request}.
#' @seealso \code{\link{create_insight}}
#' @examples
#' request <- dwapi::insight_create_request(title='A title',
#'   description = 'A description',
#'   image_url = 'https://site.org/image.png',
#'   source_link = 'https://site.org/data')
#' @export
insight_create_request <-
  function(title, description = NULL,
           image_url = NULL, embed_url = NULL, markdown_body = NULL,
           source_link = NULL, data_source_links = NULL) {

    if (is.null(title) || is.na(title) || trimws(title) == "") {
      stop("title can't be null or empty")
    }

    if (all(is.null(image_url), is.null(embed_url), is.null(markdown_body))) {
      stop("Must provide one of image_url, embed_url, or markdown_body")
    }

    if (sum(!is.null(image_url), !is.null(embed_url),
            !is.null(markdown_body)) > 1) {
      stop("Must provide only one of image_url, embed_url, or markdown_body")
    }

    ret <- list(
      title = title,
      description = description,
      body = list(
        imageUrl = image_url,
        embedUrl = embed_url,
        markdownBody = markdown_body
      ),
      sourceLink = source_link,
      dataSourceLinks = data_source_links
    )

    class(ret) <- "insight_create_request"

    ret

  }
