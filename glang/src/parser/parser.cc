#include "parser/parser.hh"

void Lexer::update_loc() {
  auto cur_line = lineno();
  auto prev_column = m_cur_loc.end.column;
  m_cur_loc.begin.line = m_cur_loc.end.line = cur_line;

  if (is_empty(yytext))
    m_cur_loc.begin.column = m_cur_loc.end.column = 1;
  else {
    m_cur_loc.begin.column = prev_column;
    m_cur_loc.end.column = m_cur_loc.begin.column + YYLeng();
  }
  //
  m_last_line = cur_line;
}

bool Lexer::is_empty(const char *str) const {
  return std::isspace(*str) && std::iscntrl(*str);
}