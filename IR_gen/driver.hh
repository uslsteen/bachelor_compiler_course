#ifndef DRIVER_HH
#define DRIVER_HH

#include "transltr.hh"
#include "interp.hh"

namespace ir_app {

class Driver final {

  llvm::LLVMContext m_context{};
  llvm::Module* m_module;

public:
  /**
   * @brief Construct a new Driver object
   * 
   */
  Driver() {
    m_module = new llvm::Module("main.cc", m_context);
  }

  /**
   * @brief 
   * 
   */
  void launch() {
    Translator translator{m_context, m_module};
    translator.translate();
    translator.dump(std::cout);

    // Interpreter interpreter{m_module};
    // interpreter.interpret();
  }

  /**
   * @brief Destroy the Driver object
   * 
   */
  ~Driver() {
    delete m_module;
  }

};

} // namespace ir_gen

#endif //! DRIVER_HH
