#' On Attach
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
#' @useDynLib libkagome, .registration = TRUE
#' @useDynLib RcppKagome, .registration = TRUE
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
#' @keywords internal
.onAttach <- function(libname, pkgname) {}

#' On Load
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
#' @keywords internal
.onLoad <- function(libname, pkgname) {}

#' On Unload
#' @noRd
#' @param libpath libpath
#' @keywords internal
.onUnload <- function(libpath) {
  library.dynam.unload("libkagome", libpath)
  library.dynam.unload("RcppKagome", libpath)
}
