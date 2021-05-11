#' RcppKagome: 'Rcpp' Interface to Kagome
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @importFrom RcppParallel RcppParallelLibs
#' @importFrom jsonlite fromJSON
#' @importFrom purrr flatten_chr map map_dfr imap_dfr
#' @importFrom stringi stri_conv stri_enc_toutf8
#' @importFrom stringr str_c
#' @import dplyr
#' @useDynLib RcppKagome, .registration=TRUE
## usethis namespace: end
#' @docType package
#' @keywords internal
"_PACKAGE"
