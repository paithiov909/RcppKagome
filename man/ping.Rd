% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/kagomer-re-exports.R
\name{ping}
\alias{ping}
\title{Send a HEAD request to Kagome server}
\usage{
ping(url = Sys.getenv("KAGOME_URL"))
}
\arguments{
\item{url}{URL stirng.}
}
\value{
the status code of response is returned invisibly.
}
\description{
Send a HEAD request to Kagome server
}
