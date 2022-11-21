#include "driver/driver.hh"

namespace yy {

Driver::Driver(const std::string &name)
    : m_lexer(new Lexer{}), m_module(new llvm::Module{name, m_context}) {

  std::string tmp{};

  std::ifstream input{};
  input.open(name);

  if (input.is_open()) {
    while (input) {
      std::string line{};
      std::getline(input, line);
      m_source_code.push_back(line);
    }
  }

  m_lexer->switch_streams(input, std::cout);
}

bool Driver::parse() {
  yy::parser parser(this);
  bool res = parser.parse();

  if (res)
    std::cerr << "Compile error\n";
}

parser::token_type Driver::yylex(parser::semantic_type *yylval,
                                 parser::location_type *loc) {
  parser::token_type tkn_type =
      static_cast<parser::token_type>(m_lexer->yylex());
  switch (tkn_type) {
  case yy::parser::token_type::INT: {
    yylval->as<int64_t>() = std::stoll(m_lexer->YYText());
    break;
  }
  //
  case yy::parser::token_type::NAME: {
    std::string word(m_lexer->YYText());
    parser::semantic_type tmp;
    tmp.as<std::string>() = word;
    yylval->swap<std::string>(tmp);
    break;
  }
  default: {
    break;
  }
  }

  *loc = m_lexer->get_cur_loc();
  return tkn_type;
}

void Driver::report_syntax_error(const parser::context &ctx) {
  auto loc = ctx.location();
  auto lookahead = ctx.token();

  std::cerr << "syntax error in ";
  std::cerr << "line: " << loc.begin.line;
  std::cerr << ", column: " << loc.begin.column << std::endl;

  if (lookahead == s_type::S_UNKNOWN) {
    dump_unexpected(ctx);
    return;
  }

  dump_unexpected(ctx);
  dump_expected(ctx);
}

void Driver::dump_expected(const yy::parser::context &ctx) {

  parser::symbol_kind_type expectd_tokns[tokens_size];
  size_t num_of_expectd_tokns = ctx.expected_tokens(expectd_tokns, tokens_size);

  std::cerr << "expected:";

  for (size_t i = 0; i < num_of_expectd_tokns; ++i) {
    if (i != 0)
      std::cerr << " or ";

    std::cerr << " <" << parser::symbol_name(expectd_tokns[i]) << "> ";
  }

  std::cerr << std::endl;
}

void Driver::dump_unexpected(const yy::parser::context &ctx) {

  auto loc = ctx.location();
  auto lookahead = ctx.token();

  std::cerr << "before: "
            << "<" << parser::symbol_name(lookahead) << ">" << std::endl;
  std::cerr << loc.begin.line << "   |   " << m_source_code[loc.begin.line - 1]
            << std::endl;
  std::cerr << "    |   ";

  for (int i = 0; i < loc.end.column - 1; ++i) {
    if (i == (ctx.lookahead().location.begin.column - 1))
      std::cerr << "^";

    else
      std::cerr << "~";
  }

  std::cerr << std::endl;
}
} // namespace yy
