#' Prettify kagome output
#'
#' @param list Output of \code{RcppKagome::kagome}
#' @return data.frame
#'
#' @import dplyr
#' @importFrom furrr future_imap_dfr
#' @importFrom furrr future_map_dfr
#'
#' @export
prettify <- function(list) {
  res <- furrr::future_imap_dfr(list, function(v, i) {
    furrr::future_map_dfr(v, function(elem) {
      df <- data.frame(
        "Sid" = i,
        "Surface" = elem$Surface,
        data.frame(t(elem$Feature))
      )
      if (ncol(df) < 11L) {
        df <- data.frame(
          df,
          data.frame(
            "t1" = NA_character_,
            "t2" = NA_character_
          )
        )
      }
      colnames(df) <- c(
        "Sid",
        "Surface",
        "POS1",
        "POS2",
        "POS3",
        "POS4",
        "X5StageUse1",
        "X5StageUse2",
        "Original",
        "Yomi1",
        "Yomi2"
      )
      return(df)
    })
  })
  return(dplyr::mutate(
    res,
    dplyr::across(
      where(is.character),
      ~ dplyr::na_if(., "*")
    )
  ))
}

#' Pack prettified output
#'
#' @param df Output of \code{RcppKagome::prettify}
#' @return data.frame.
#'
#' @import dplyr
#' @importFrom furrr future_map_dfr
#' @export
pack <- function(df) {
  res <- df %>%
    dplyr::group_by(Sid) %>%
    dplyr::group_map(~ paste(.x$Surface, collapse = " ")) %>%
    furrr::future_imap_dfr(~ data.frame(Sid = .y, Text = .x))
  return(res)
}
