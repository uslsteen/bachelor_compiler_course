#ifndef DRIVER_HH
#define DRIVER_HH
//
#include "parser/parser.hh"
//
#include <filesystem>
#include <fstream>
#include <iostream>
#include <vector>
//
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
//
namespace yy {

constexpr int tokens_size = 30;

class Driver final {
private:
  Lexer *m_lexer;
  //
  llvm::LLVMContext m_context{};
  llvm::Module *m_module = nullptr;
  //
  std::vector<std::string> m_source_code{};
  //
public:
  Driver(const std::string &name);
  //
  ~Driver() {
    delete m_lexer;
    delete m_module;
  }
  //
  using s_type = parser::symbol_kind::symbol_kind_type;
  //
  bool parse();
  parser::token_type yylex(parser::semantic_type *yylval,
                           parser::location_type *loc);
  //
  void report_syntax_error(const parser::context &ctx);
  void dump_expected(const yy::parser::context &ctx);
  void dump_unexpected(const yy::parser::context &ctx);
};

} // namespace yy

#endif // DRIVER_HH