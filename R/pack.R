#' Pack output of kagome
#'
#' Alias of \code{RcppKagome::pack_list} and \code{RcppKagome::pack_df}
#'
#' @param obj Object
#' @param ... Other arguments
#' @return data.frame
#'
#' @family pack-fn
#' @export
pack <- function(obj, ...) {
  if (inherits(obj, "data.frame")) {
    pack_df(obj, ...)
  } else {
    pack_list(obj, ...)
  }
}

#' Pack ouput of kagome
#'
#' @param list Output of \code{RcppKagome::kagome}.
#' @param .collapse This argument is passed to \code{stringi::stri_join()}.
#' @return data.frame.
#'
#' @family pack-fn
#' @export
pack_list <- function(list, .collapse = " ") {
  res <- lapply(list, function(elem) {
    elem %>%
      map(~ purrr::pluck(., "Surface")) %>%
      purrr::flatten_chr() %>%
      stringi::stri_join(collapse = .collapse)
  }) %>%
    imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}


#' Pack prettified output
#'
#' @param df Output of \code{RcppKagome::prettify}.
#' @param pull Column name to be packed into data.frame. Default value is `token`.
#' @param .collapse This argument is passed to \code{stringi::stri_join()}.
#' @return data.frame.
#'
#' @family pack-fn
#' @export
pack_df <- function(df, pull = "token", .collapse = " ") {
  res <- df %>%
    dplyr::group_by(.data$doc_id) %>%
    dplyr::group_map(
      ~ dplyr::pull(.x, {{ pull }}) %>%
        stringi::stri_join(collapse = .collapse)
    ) %>%
    imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}
