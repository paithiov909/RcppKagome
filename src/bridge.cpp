// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::depends(RcppThread)]]
#define STRICT_R_HEADERS
#define R_NO_REMAP
#define RCPPTHREAD_OVERRIDE_THREAD 1
#include <cstdlib>
#include <Rcpp.h>
#include "../inst/include/libkagome.h"

using namespace Rcpp;

//' Trigger kagome tokenizer
//'
//' For internal use. The argument should be UTF8 encoded. This function just
//' returns an UTF8-encoded json as a character scalar.
//'
//' @param text Character vector.
//' @return res Character scalar (JSON string).
//'
//' @name tokenize_morphemes
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::CharacterVector tokenize_morphemes(Rcpp::CharacterVector text)
{
  char* tokens;
  std::function< Rcpp::String(Rcpp::String) > func = [&](Rcpp::String x) {
    const char* s = x.get_cstring();
    const std::size_t n = std::strlen(s);
    const std::ptrdiff_t len = n;
    const GoString mes = { s, len };

    tokens = tokenize(mes);

    const std::string res = tokens;
    const Rcpp::String result = res;

    return result;
  };
  const Rcpp::CharacterVector result = sapply(text, func);
  free(tokens);
  return result;
}

//' Split sentence
//'
//' For internal use. The argument should be UTF8 encoded.
//'
//' @param text Character vector.
//' @return res List.
//'
//' @name tokenize_sentences
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::List tokenize_sentences(Rcpp::CharacterVector text)
{
  char* sentences;
  std::function< Rcpp::String(Rcpp::String) > func = [&](Rcpp::String x) {
    const char* s = x.get_cstring();
    const std::size_t n = std::strlen(s);
    const std::ptrdiff_t len = n;
    const GoString mes = { s, len };

    sentences = split(mes);

    const std::string res = sentences;
    const Rcpp::String result = res;

    return result;
  };
  const Rcpp::List result = lapply(text, func);
  free(sentences);
  return result;
}

//' Tiny Segmenter
//'
//' For internal use. The argument should be UTF8 encoded.
//'
//' @param text character vector
//' @return character vector
//'
//' @name tokenize_segments
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::CharacterVector tokenize_segments(Rcpp::CharacterVector text)
{
  char* response;
  std::function< Rcpp::String(Rcpp::String) > func = [&](Rcpp::String x) {
    const char* s = x.get_cstring();
    const std::size_t n = std::strlen(s);
    const std::ptrdiff_t len = n;
    const GoString m = { s, len };

    response = segment(m);

    const std::string res = response;
    const Rcpp::String result = res;

    return result;
  };
  const Rcpp::CharacterVector result = sapply(text, func);
  free(response);
  return result;
}
