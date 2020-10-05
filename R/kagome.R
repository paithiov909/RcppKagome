#' Japanese morphological analyzer
#'
#' Call kagome tokenizer.
#'
#' @param text character vector
#' @param ... all other args are passed to \code{jsonlite::toJSON}
#' @return list
#'
#' @importFrom stringi stri_conv
#' @importFrom jsonlite fromJSON
#'
#' @export
kagome <- function(text, ...) {
  json <- .Call("_RcppKagome_tokenize",
    PACKAGE = "RcppKagome",
    stringi::stri_conv(text, to = "UTF-8")
  )
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  return(res)
}
