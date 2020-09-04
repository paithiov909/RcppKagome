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
  lapply(text, function(str) {
    json <- .Call("_RcppKagome_tokenize",
      PACKAGE = "RcppKagome",
      stringi::stri_conv(str, to = "UTF-8")
    )
    Encoding(json) <- "UTF-8"
    return(jsonlite::fromJSON(json, ...))
  })
}
