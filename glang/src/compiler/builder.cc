#include "compiler/builder.hh"

namespace glang {

Builder::Builder(const std::string &name) : g_cont(GlangContext{name}) {

  //! NOTE: glang standart library

  //! I/O functions
  llvm::FunctionType *glang_printTy = llvm::FunctionType::get(
      g_cont.builder.getVoidTy(), {g_cont.builder.getInt32Ty()}, false);
  llvm::FunctionType *glang_readTy =
      llvm::FunctionType::get(g_cont.builder.getInt32Ty(), false);
  //
  auto *glang_print =
      llvm::Function::Create(glang_printTy, llvm::Function::ExternalLinkage,
                             "__glang_print", g_cont.module);
  auto *glang_read = llvm::Function::Create(
      glang_readTy, llvm::Function::ExternalLinkage, "__glang_read", g_cont.module);
  //
}

void Builder::dump(std::ostream &out) {
  std::string str{};
  llvm::raw_string_ostream os(str);

  g_cont.module.print(os, nullptr);
  os.flush();
  out << str;
}
} // namespace glang
