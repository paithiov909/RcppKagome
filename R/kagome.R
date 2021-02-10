#' Japanese morphological analyzer
#'
#' Call kagome tokenizer.
#'
#' @param text Character vector
#' @param ... All other arguments are passed to \code{jsonlite::fromJSON}
#' @return list
#'
#' @importFrom stringi stri_conv
#' @importFrom jsonlite fromJSON
#'
#' @export
kagome <- function(text, ...) {
  json <- tokenize_morphemes(stringi::stri_conv(text, to = "UTF-8"))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  res <- lapply(res, function(list) {
    return(list[order(as.integer(names(list)))])
  })
  return(res)
}
