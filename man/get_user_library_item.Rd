% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_user_library.R
\name{get_user_library_item}
\alias{get_user_library_item}
\title{Search for library items owned by, liked by, or contributed-to by
the currently authenticated user.}
\usage{
get_user_library_item(
  type = c("datasets", "projects"),
  role = c("own", "liked", "contributing"),
  limit = NULL,
  next_page_token = NULL
)
}
\arguments{
\item{type}{the type of asset (one of: datasets, projects)}

\item{role}{the user's role with respect to the asset
(one of: own, liked, contributing)}

\item{limit}{Maximum number of items to return}

\item{next_page_token}{Unique token used to retrieve next page}
}
\value{
a named list with at most two elements.  It will
always contain a list, named \code{records},
of objects of a list structure type appropriate for the
kind of asset queried. If the call to \code{get_datasets()}
was made with a non-null
\code{limit} parameter, and if further pages remain for
retrieval, then
the list will also contain a single-element character vector,
named \code{next_page_token},
with the token to use in a subsequent call to get the next page.
}
\description{
Search for library items owned by, liked by, or contributed-to by
the currently authenticated user.
}
\keyword{internal}
