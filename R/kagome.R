#' Japanese morphological analyzer
#'
#' Call kagome tokenizer.
#'
#' @param text character vector
#' @param ... all other args are passed to jsonlite::toJSON
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
      stringi::stri_conv(text, to = "UTF-8")
    )
    print(json)
    lapply(json, function(elem) {
      s <- elem
      Encoding(s) <- "UTF-8"
      jsonlite::fromJSON(s, ...)
    })
  })
}
