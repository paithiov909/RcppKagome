// [[Rcpp::plugins(cpp11)]]
#define STRICT_R_HEADERS
#define R_NO_REMAP
#include <string>
#include <R.h>
#include <Rinternals.h>
#include <Rcpp.h>
#include "libkagome.h"

using namespace std;
using namespace Rcpp;

//' Triger kagome tokenizer
//'
//' For internal use. The argument should be UTF8 encoded. This func just
//' returns an UTF8-encoded json string vector.
//'
//' @param text string
//' @return res character vectors that each elem contains escaped json strings.
//'
//' @keywords internal
//' @export
//'
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::CharacterVector tokenize(std::string text)
{
   Rcpp::CharacterVector lt = {};

   const char* t = text.c_str();
   const std::size_t n = std::strlen(t);
   const std::ptrdiff_t len = n;

   GoString s = { t, len };
   const char* tokens = tokenize(s);
   const std::string str = tokens;

   lt.push_back(str);

   return lt;
}
