#' On Unload
#' @noRd
#' @param libpath libpath
#' @keywords internal
.onUnload <- function(libpath) {
  library.dynam.unload("RcppKagome", libpath)
}
