#ifndef DRIVER_HH
#define DRIVER_HH
//
#include "compiler/builder.hh"
#include "parser/parser.hh"
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

  std::ifstream m_in{};
  std::ofstream m_out{};
  //
public:
  //
  Driver(const std::string &src, const std::string &out)
      : m_lexer(new Lexer{}), builder({src}) {

    std::string tmp{};
    //
    m_in.open(src);
    m_out.open(out, std::ofstream::out);
    //
    std::ifstream tmp_input(src);
    //
    if (tmp_input.is_open()) {
      while (tmp_input) {
        std::string line{};
        std::getline(tmp_input, line);
        m_source_code.push_back(line);
      }
    }
    //
    m_lexer->switch_streams(m_in, m_out);
  }

  /**
   * @brief
   *
   * @return true
   * @return false
   */
  bool parse() {
    yy::parser parser(this);
    bool res = parser.parse();

    if (res)
      std::cerr << "Compile error\n";

    return !res;
  }
  //
  ~Driver() {
    m_out.close();
    delete m_lexer;
  }
  //
  using symb_type = parser::symbol_kind::symbol_kind_type;
  //
  parser::token_type yylex(parser::semantic_type *yylval,
                           parser::location_type *loc);
  //
  void report_syntax_error(const parser::context &ctx);
  void dump_expected(const yy::parser::context &ctx);
  void dump_unexpected(const yy::parser::context &ctx);

  //
  void codegen() { builder.codegen(); }

  //
  void dump() { builder.dump(m_out); }

  auto& get_cur_scope() { return builder.get_cur_scope(); }
  auto& get_cur_args() { return builder.get_cur_args(); }
};

} // namespace yy

#endif // DRIVER_HH