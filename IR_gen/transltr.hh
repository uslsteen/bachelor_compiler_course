#ifndef TRANSLATOR_HH
#define TRANSLATOR_HH

#include <iostream>
#include <string>

#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/raw_ostream.h>

namespace ir_app {
class Translator final {

  llvm::LLVMContext &m_context;
  llvm::IRBuilder<> *m_builder;
  llvm::Module *m_module;

public:
  Translator(llvm::LLVMContext& context, llvm::Module *module)
      : m_context(context), m_module(module) {
    // m_module = new llvm::Module("top", m_context);
    m_builder = new llvm::IRBuilder<>(m_context);
  }

  ~Translator() {
    // delete m_module;
    delete m_builder;
  }

  /**
   * @brief
   *
   */
  void translate();

  void create__main();

  void create__swap();

  void create__draw_field();
  void create__field_init();

  void create__make_next_gen();

  void create__get_neighbours_num();

  void create__get_cell();

  /**
   * @brief Create a graph lib functions
   */
  void create__graph_init();
  void create__window_clear();
  void create__is_open_window();
  void create__flush();
  void create__set_pixel();

  /**
   * @brief Create a get random val object
   *
   */
  void create__get_random_val();

  /**
   * @brief
   *
   * @param out
   */
  void dump(std::ostream &out);

private:
  void createGlobal(const std::string &name);

  llvm::Function *createFunction(llvm::Type *ret_type,
                                 const std::string &func_name);

  llvm::Function *createFunction(llvm::Type *ret_type,
                                 std::vector<llvm::Type *> arg_types,
                                 const std::string &func_name);

  llvm::Function *getFunction(const std::string &func_name);
};
} // namespace ir_app

#endif //! TRANSLATOR_HH