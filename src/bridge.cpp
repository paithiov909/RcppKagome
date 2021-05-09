// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::depends(RcppThread, RcppParallel)]]
#define STRICT_R_HEADERS
#define R_NO_REMAP
#define RCPP_PARALLEL_USE_TBB 1
#define RCPPTHREAD_OVERRIDE_THREAD 1
#include <cstdlib>
#include <Rcpp.h>
#include <RcppParallel.h>
#include "../inst/include/libkagome.h"

// KagomeTokenizer
class KagomeTokenizer {
public:
  const std::vector<std::string>* text_;
  std::vector<std::string>& results_;
  KagomeTokenizer( const std::vector<std::string>* text, std::vector<std::string>& results )
    : text_(text), results_(results)
    {}
  void operator() ( const tbb::blocked_range<std::size_t>& range ) const
  {
    for ( std::size_t i = range.begin(); i < range.end(); ++i ) {

      const char* s = (*text_)[i].c_str();
      const std::size_t n = std::strlen(s);
      const std::ptrdiff_t len = n;
      const GoString mes = { s, len };

      char* tokens = tokenize(mes);
      const std::string res = tokens;

      free(tokens);
      results_[i] = res;

    }
  }
};


//' Trigger kagome tokenizer
//'
//' For internal use. The argument should be UTF8 encoded. This function just
//' returns UTF8-encoded json strings as a character vector.
//'
//' @param text Character vector.
//' @return res Character vector (JSON strings).
//'
//' @name tokenize_morphemes
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::CharacterVector tokenize_morphemes(std::vector<std::string> text)
{
  std::vector<std::string> results(text.size());

  KagomeTokenizer func = KagomeTokenizer(&text, results);
  tbb::parallel_for( tbb::blocked_range<std::size_t>(0, text.size()), func );

  Rcpp::CharacterVector result;
  for ( std::size_t l = 0; l < results.size(); ++l ) {
    result.push_back(results[l]);
  }

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
