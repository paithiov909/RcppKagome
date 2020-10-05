// [[Rcpp::plugins(cpp11)]]
#define STRICT_R_HEADERS
#define R_NO_REMAP
#include <cstdlib>
#include <Rcpp.h>
#include "../inst/include/libkagome.h"

using namespace Rcpp;
using namespace std;

//' Trigger kagome tokenizer
//'
//' For internal use. The argument should be UTF8 encoded. This function just
//' returns an UTF8-encoded json as character scalar.
//'
//' @param text character vector
//' @return res character scalar (JSON string)
//'
//' @name tokenize
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::CharacterVector tokenize(Rcpp::CharacterVector text)
{
   std::function< Rcpp::String(Rcpp::String) > func_obj = [](Rcpp::String x) {
      const char* s = x.get_cstring();
      const std::size_t n = std::strlen(s);
      const std::ptrdiff_t len = n;
      const GoString mes = { s, len };

      char* tokens = tokenize(mes);
      const std::string res = tokens;

      free(tokens);

      const Rcpp::String result = res;
      return result;
   };

   const Rcpp::CharacterVector result = sapply(text, func_obj) ;
   return result;
}
