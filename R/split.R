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
  json <- tokenize_sentences(stringi::stri_enc_toutf8(text))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  return(res)
}

#' A Go implementation of TinySegmenter
#'
#' Call TinySegmenter.
#'
#' @details
#' This function is a wrapper of `nyarla/go-japanese-segmenter`.
#' The `go-japanese-segmenter` library contians dictionary data
#' and dictionary code from the original `TinySegmenter.js` library written by Taku Kudo.
#' For more details, please look a glance at the license notice from 'See Also' section.
#'
#' @param text Character vector.
#' @param ... All other args are passed to \code{jsonlite::fromJSON}.
#' @return list.
#'
#' @seealso \url{https://github.com/nyarla/go-japanese-segmenter#licenses}
#'
#' @export
split_segments <- function(text, ...) {
  json <- tokenize_segments(stringi::stri_enc_toutf8(text))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  return(purrr::map(res, ~ purrr::discard(., ~ . == "")))
}
