#' Get names of features of each dictionaries supported.
#'
#' @param dic The name of dictionary.
#' @return character vector.
#'
#' @export
get_feature_names <- function(dic = c("ipa", "uni", "ko")) {
  dic <- arg_match(dic)
  res <- c(
    "doc_id",
    "token",
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
  if (dic == "ko") {
    res <- c(
      "doc_id",
      "token",
      "pos",
      "meaning",
      "has_patchim",
      "reading",
      "type",
      "analytic1",
      "analytic2",
      "expression"
    )
  }
  if (dic == "uni") {
    res <- c(
      "doc_id",
      "token",
      "POS",
      "POS1",
      "POS2",
      "POS3",
      "cType",
      "cForm",
      "lForm",
      "lemma",
      "orth",
      "pron",
      "orthBase",
      "pronBase",
      "goshu",
      "iType",
      "iForm",
      "fType",
      "fForm"
    )
  }
  return(res)
}

#' Prettify kagome output
#'
#' @param list Output of \code{RcppKagome::kagome}.
#' @param col_names Column names of output data.frame.
#' @return data.frame.
#'
#' @export
prettify <- function(list, col_names = get_feature_names("ipa")) {
  imap_dfr(list, function(v, i) {
    map_dfr(v, function(elem) {
      df <- data.frame(
        "sentence_id" = i,
        "token" = elem$Surface,
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
      colnames(df) <- col_names
      return(df)
    })
  }) %>%
    dplyr::mutate(doc_id = as.factor(doc_id)) %>%
    dplyr::mutate_if(
      is.character,
      ~ dplyr::na_if(., "*")
    )
}
