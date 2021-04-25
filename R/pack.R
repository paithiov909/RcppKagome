#' Pack ouput of kagome
#'
#' @param list Output of \code{RcppKagome::kagome}.
#' @param .collapse This argument will be passed to \code{stringr::str_c()}.
#' @return data.frame.
#'
#' @export
pack_list <- function(list, .collapse = " ") {
  res <- lapply(list, function(elem) {
    purrr::map(elem, ~ purrr::pluck(., "Surface")) %>%
      purrr::flatten_chr() %>%
      stringr::str_c(collapse = .collapse)
  }) %>%
    furrr::future_imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}


#' Pack prettified output
#'
#' @param df Output of \code{RcppKagome::prettify}.
#' @param pull Column name to be packed into data.frame. Default value is `token`.
#' @param .collapse This argument will be passed to \code{stringr::str_c()}.
#' @return data.frame.
#'
#' @export
pack_df <- function(df, pull = "token", .collapse = " ") {
  res <- df %>%
    dplyr::group_by(sentence_id) %>%
    dplyr::group_map(
      ~ dplyr::pull(.x, {{ pull }}) %>%
        stringr::str_c(collapse = .collapse)
    ) %>%
    furrr::future_imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}
