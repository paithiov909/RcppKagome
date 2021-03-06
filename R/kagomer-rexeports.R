#' Sends a HEAD request to Kagome server
#' @inherit kagomer::ping
#' @importFrom kagomer ping
#' @export
ping <- function(url = Sys.getenv("KAGOME_URL")) {
  kagomer::ping(url)
}


#' Creates json data
#' @inherit kagomer::serialize
#' @importFrom kagomer serialize
#' @export
serialize <- function(sentences,
                      mode = "normal",
                      dict = "ipa") {
  kagomer::serialize(sentences, mode, dict)
}


#' Creates asynchronous requests
#' @inherit kagomer::queue
#' @importFrom kagomer queue
#' @export
queue <- function(params,
                  url = paste(Sys.getenv("KAGOME_URL"), "tokenize", sep = "/")) {
  kagomer::queue(params, url)
}


#' Kicks requests
#' @inherit kagomer::kick
#' @importFrom kagomer kick
#' @export
kick <- function(requests,
                 keep = c("surface"),
                 .skip_enc_reset = FALSE) {
  kagomer::kick(requests, keep, .skip_enc_reset)
}

