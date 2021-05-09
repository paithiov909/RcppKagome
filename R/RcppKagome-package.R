#' RcppKagome: 'Rcpp' Interface to Kagome
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @importFrom RcppParallel RcppParallelLibs
#' @importFrom furrr future_imap_dfr
#' @importFrom furrr future_map_dfr
#' @importFrom jsonlite fromJSON
#' @importFrom stringi stri_conv stri_enc_toutf8
#' @import dplyr
#' @import purrr
#' @import stringr
#' @import purrr
#' @useDynLib RcppKagome, .registration=TRUE
## usethis namespace: end
#' @docType package
#' @keywords internal
"_PACKAGE"
