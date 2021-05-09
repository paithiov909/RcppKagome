// [[Rcpp::depends(RcppParallel, RcppThread)]]
#define STRICT_R_HEADERS
#define R_NO_REMAP
#define RCPPTHREAD_OVERRIDE_THREAD 1

#ifndef RCPPKAGOME_GRAIN_SIZE
#define RCPPKAGOME_GRAIN_SIZE 100
#endif

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

// SentenceSplitter
class SentenceSplitter {
public:
  const std::vector<std::string>* text_;
  std::vector<std::string>& results_;
  SentenceSplitter( const std::vector<std::string>* text, std::vector<std::string>& results )
    : text_(text), results_(results)
    {}
  void operator() ( const tbb::blocked_range<std::size_t>& range ) const
  {
    for ( std::size_t i = range.begin(); i < range.end(); ++i ) {

      const char* s = (*text_)[i].c_str();
      const std::size_t n = std::strlen(s);
      const std::ptrdiff_t len = n;
      const GoString mes = { s, len };

      char* sentences = split(mes);
      const std::string res = sentences;

      free(sentences);
      results_[i] = res;

    }
  }
};

// TinySegmenter
class TinySegmenter {
public:
  const std::vector<std::string>* text_;
  std::vector<std::string>& results_;
  TinySegmenter( const std::vector<std::string>* text, std::vector<std::string>& results )
    : text_(text), results_(results)
    {}
  void operator() ( const tbb::blocked_range<std::size_t>& range ) const
  {
    for ( std::size_t i = range.begin(); i < range.end(); ++i ) {

      const char* s = (*text_)[i].c_str();
      const std::size_t n = std::strlen(s);
      const std::ptrdiff_t len = n;
      const GoString mes = { s, len };

      char* segments = segment(mes);
      const std::string res = segments;

      free(segments);
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
//' @return Character vector (JSON strings).
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
  const std::size_t grainsize = RCPPKAGOME_GRAIN_SIZE;

  KagomeTokenizer func = KagomeTokenizer(&text, results);
  tbb::parallel_for( tbb::blocked_range<std::size_t>(0, text.size(), grainsize), func );

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
//' @return List.
//'
//' @name tokenize_sentences
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::List tokenize_sentences(std::vector<std::string> text)
{
  std::vector<std::string> results(text.size());
  const std::size_t grainsize = RCPPKAGOME_GRAIN_SIZE;

  SentenceSplitter func = SentenceSplitter(&text, results);
  tbb::parallel_for( tbb::blocked_range<std::size_t>(0, text.size(), grainsize), func );

  Rcpp::List result;
  for ( std::size_t l = 0; l < results.size(); ++l ) {
    result.push_back(results[l]);
  }

  return result;
}

//' Tiny Segmenter
//'
//' For internal use. The argument should be UTF8 encoded.
//'
//' @param text Character vector.
//' @return Character vector.
//'
//' @name tokenize_segments
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::CharacterVector tokenize_segments(std::vector<std::string> text)
{
  std::vector<std::string> results(text.size());
  const std::size_t grainsize = RCPPKAGOME_GRAIN_SIZE;

  TinySegmenter func = TinySegmenter(&text, results);
  tbb::parallel_for( tbb::blocked_range<std::size_t>(0, text.size(), grainsize), func );

  Rcpp::CharacterVector result;
  for ( std::size_t l = 0; l < results.size(); ++l ) {
    result.push_back(results[l]);
  }

  return result;
}

