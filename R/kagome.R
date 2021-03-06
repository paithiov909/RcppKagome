#' Japanese morphological analyzer
##
#' Calls kagome tokenizer.
##
#' @param text Character vector.
#' @param ... All other arguments are passed to \code{jsonlite::fromJSON}.
#' @return list.
##
#' @export
kagome <- function(text, ...) {
  json <- tokenize_morphemes(stringi::stri_enc_toutf8(text))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  res <- lapply(res, function(list) {
    return(list[order(as.integer(names(list)))])
  })
  return(res)
}

