#' On Load
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
#' @keywords internal
NULL

#' On Unload
#' @noRd
#' @param libpath libpath
#' @keywords internal
.onUnload <- function(libpath) {
  library.dynam.unload("RcppKagome", libpath)
}
