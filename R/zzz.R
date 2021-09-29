#' On unload
#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  library.dynam.unload("RcppKagome", libpath)
  # library.dynam.unload("libkagome", libpath, file.ext = ".a")
}
