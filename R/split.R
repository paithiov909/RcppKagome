#' Japanese sentence splitter
#'
#' Call sentence splitter.
#'
#' @param text Character vector.
#' @param ... All other arguments are passed to \code{jsonlite::fromJSON}.
#' @return list.
#'
#' @export
split_sentences <- function(text, ...) {
  json <- tokenize_sentences(stringi::stri_enc_toutf8(text))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  return(res)
}
