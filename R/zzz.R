#' Settings
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
#' @useDynLib libkagome
#' @useDynLib RcppKagome
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
#' @keywords internal
NULL

#' On Unload
#' @noRd
#' @param libpath libpath
#' @keywords internal
.onUnload <- function(libpath) {
  library.dynam.unload("libkagome", libpath)
  library.dynam.unload("RcppKagome", libpath)
}
