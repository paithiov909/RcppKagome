#' On Load
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  library.dynam("libkagome", pkgname, .libPaths(), DLLpath = system.file("libs", package = pkgname))
  library.dynam("RcppKagome", pkgname, .libPaths())
}

#' On Unload
#' @noRd
#' @param libpath libpath
#' @keywords internal
.onUnload <- function(libpath) {
  library.dynam.unload("RcppKagome", libpath)
  library.dynam.unload("libkagome", libpath)
}
