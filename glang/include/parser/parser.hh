#ifndef PARSER_HH
#define PARSER_HH
//
#include <iostream>
#include <ctype.h>
//
#ifndef yyFlexLexer
#include <FlexLexer.h>
#endif // yyFlexLexer
//
#include "../../src/grammar/compiler.tab.hh"
//
class Lexer : public yyFlexLexer {
private:
  yy::location m_cur_loc{};
  size_t m_last_line = 0;

public:
  Lexer() = default;
  ~Lexer() override = default;

  Lexer(const Lexer &other) = delete;
  Lexer &operator=(const Lexer &other) = delete;

  Lexer(Lexer &&other) = delete;
  Lexer &operator=(Lexer &&other) = delete;

  yy::location get_cur_loc() const { return m_cur_loc; }
  size_t get_last_line() const { return m_last_line; }

  void update_loc();
  bool is_empty(const char* str) const;

  int yylex() override;
};

#endif // PARSER_HH