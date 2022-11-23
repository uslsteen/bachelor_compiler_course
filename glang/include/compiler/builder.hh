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

public:
  Builder() = delete;

  Builder(const std::string &name);

  /**
   * @brief Get the cur scope object
   * 
   * @return auto 
   */
  auto get_cur_scope() { return m_current_scope; }

  /**
   * @brief 
   * 
   */
  void codegen() { m_current_scope->codegen(g_cont); }
  
  /**
   * @brief 
   * 
   * @param[in] out 
   */
  void dump(std::ostream &out);
  //
};
//
} // namespace glang

#endif //! GLANG_BUILDER_HH
