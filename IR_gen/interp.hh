#ifndef INTERP_HH
#define INTERP_HH

#include <llvm/ExecutionEngine/ExecutionEngine.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/raw_ostream.h>
//
#include <iostream>
#include <map>
#include <string>
#include <vector>
//
//! NOTE: ugly, but it's temporary solution
#include "../game_of_life/graph_wrapp/graph_wrapp.hh"

namespace ir_app {
class Interpreter final {
  using func_ptr = void*;

  std::map<std::string, func_ptr> m_sys_func_tab{};
  const std::vector<std::pair<std::string, func_ptr>> m_sys_funcs{};
  //
  std::unique_ptr<llvm::ExecutionEngine> m_exec{};

public:
  Interpreter(llvm::Module *module)
      : m_exec(llvm::EngineBuilder(std::unique_ptr<llvm::Module>(module))
                   .create()) {
  }

  void interpret() {
    m_sys_func_tab["get_random_val"] = reinterpret_cast<void*>(get_random_val);
    m_sys_func_tab["graph_init"] = reinterpret_cast<void*>(graph_init);
    m_sys_func_tab["is_open_window"] = reinterpret_cast<void*>(is_open_window);
    m_sys_func_tab["flush"] = reinterpret_cast<void*>(flush);
    m_sys_func_tab["window_clear"] = reinterpret_cast<void*>(window_clear);
    m_sys_func_tab["set_pixel"] = reinterpret_cast<void*>(set_pixel);

    m_exec->InstallLazyFunctionCreator(
        [this](const std::string &name) { return m_sys_func_tab[name]; });
    m_exec->finalizeObject();
  }
};
} // namespace ir_app

#endif //! INTERP_HH