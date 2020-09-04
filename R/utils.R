#' Prettify kagome output
#'
#' @param list output of \code{RcppKagome::kagome}
#' @return data.frame
#'
#' @import dplyr
#' @importFrom purrr imap_dfr
#' @importFrom purrr map_dfr
#'
#' @export
prettify <- function(list) {
  purrr::imap_dfr(list, function(v, i) {
    purrr::map_dfr(v, function(elem) {
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
}
