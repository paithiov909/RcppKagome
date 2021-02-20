#' Pack prettified output
#'
#' @param df Output of \code{RcppKagome::prettify}
#' @param pull Column name to be packed into data.frame. Default value is `token`.
#' @param .collapse This argument will be passed to \code{paste()}.
#' @return data.frame.
#'
#'
#' @import dplyr
#' @import stringr
#' @importFrom furrr future_map_dfr
#' @export
pack <- function(df, pull = "token", .collapse = " ") {
  res <- df %>%
    dplyr::group_by(sentence_id) %>%
    dplyr::group_map(
      ~ dplyr::pull(.x, {{ pull }}) %>%
        stringr::str_c(collapse = .collapse)) %>%
    furrr::future_imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}
