#ifndef DRIVER_HH
#define DRIVER_HH
//
#include "parser/parser.hh"
#include "compiler/builder.hh"
//
#include <filesystem>
#include <fstream>
#include <iostream>
#include <memory>
#include <vector>
//
namespace yy {

constexpr int tokens_size = 30;

class Driver final {
private:
  //! NOTE: wrap into unique ptr
  Lexer *m_lexer;
  glang::Builder builder;
  //
  std::vector<std::string> m_source_code{};
  //
public:
  Driver(const std::string &name);
  //
  ~Driver() {
    delete m_lexer;
  }
  //
  using symb_type = parser::symbol_kind::symbol_kind_type;
  //
  bool parse();
  parser::token_type yylex(parser::semantic_type *yylval,
                           parser::location_type *loc);
  //
  void report_syntax_error(const parser::context &ctx);
  void dump_expected(const yy::parser::context &ctx);
  void dump_unexpected(const yy::parser::context &ctx);

  //
  void codegen() {
    builder.codegen();
  }
  
  //
  void dump(std::ostream &out) {
    builder.dump(out);
  }

  auto get_cur_scope() {
    return builder.get_cur_scope();
  }

};

} // namespace yy

#endif // DRIVER_HH