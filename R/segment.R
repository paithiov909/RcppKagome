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
segment <- function(text, ...) {
  json <- tokenize_segments(stringi::stri_enc_toutf8(text))
  res <- lapply(json, function(elem) {
    Encoding(elem) <- "UTF-8"
    return(jsonlite::fromJSON(elem, ...))
  })
  return(purrr::map(res, ~ purrr::discard(., ~ . == "")))
}
