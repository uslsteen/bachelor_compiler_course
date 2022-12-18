#ifndef GLANG_BUILDER_HH
#define GLANG_BUILDER_HH
//
#include <fstream>
#include <iostream>
#include <string>
//
#include "node.hh"
//
namespace glang {

class Builder {

  //! NOTE: wrap into unique ptr
  GlangContext g_cont;
  std::shared_ptr<ScopeNode> m_current_scope = std::make_shared<ScopeNode>();
  std::vector<std::string> m_cur_args{};

public:
  Builder() = delete;
  Builder(const std::string &name);

  /**
   * @brief Get the cur scope object
   *
   * @return auto
   */
  auto &get_cur_scope() { return m_current_scope; }
  auto &get_cur_args() { return m_cur_args; }

  /**
   * @brief
   *
   */
  void codegen() { m_current_scope->codegen(g_cont); }

  void create_IO_inteface();
  void create_Gl_interface();

  /**
   * @brief
   *
   * @param[in] out
   */
  void dump(std::ofstream &out) {
    std::string str{};
    llvm::raw_string_ostream os(str);

    g_cont.module.print(os, nullptr);
    os.flush();
    out << str;
  }
  //
};
//
} // namespace glang

#endif //! GLANG_BUILDER_HH
