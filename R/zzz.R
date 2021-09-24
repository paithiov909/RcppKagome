#' On load
#' @noRd
#' @param libname libname
#' @param pkgname pkgname
.onLoad <- function(libname, pkgname) {
  # if (pkgload::is_dev_package(pkgname)) {}
  return(invisible(NULL))
}

#' On unload
#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  library.dynam.unload("RcppKagome", libpath)
  library.dynam.unload("libkagome", libpath, file.ext = ".a")

}
