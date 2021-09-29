#' Japanese sentence splitter
#'
#' Call sentence splitter.
#'
#' @param text Character vector.
#' @param ... All other arguments are passed to \code{jsonlite::fromJSON}.
#' @return list.
#'
#' @seealso \url{https://zenn.dev/ikawaha/books/kagome-v2-japanese-tokenizer/viewer/filter#%E6%96%87%E3%81%AB%E5%8C%BA%E5%88%87%E3%82%8B}
#'
#' @export
split_sentences <- function(text, ...) {
  json <- tokenize_sentences(stri_enc_toutf8(text))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(fromJSON(elem, ...))
  })
  return(res)
}
