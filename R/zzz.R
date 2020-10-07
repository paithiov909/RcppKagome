#' On Load
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
## usethis namespace: end
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  dll_path <- ifelse(
    .Platform$r_arch == "i386",
    system.file("libs/i386", package = pkgname),
    system.file("libs/x64", package = pkgname)
  )
  library.dynam("RcppKagome",
    pkgname,
    .libPaths(),
    DLLpath = dll_path
  )
}

#' On Unload
#' @noRd
#' @param libpath libpath
#' @keywords internal
.onUnload <- function(libpath) {
  library.dynam.unload("RcppKagome", libpath)
}
