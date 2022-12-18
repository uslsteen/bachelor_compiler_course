#include "compiler/builder.hh"

namespace glang {

Builder::Builder(const std::string &name) : g_cont({name}) {

  //! NOTE: glang standart library

  //! add I/O functions
  create_IO_inteface();

  //! add graph library functions
  create_Gl_interface();
}

void Builder::create_IO_inteface() {
  //
  // llvm::FunctionType *glang_printTy = llvm::FunctionType::get(
  //    g_cont.builder.getVoidTy(), {g_cont.builder.getInt32Ty()}, false);
  ////
  // llvm::FunctionType *glang_readTy =
  //     llvm::FunctionType::get(g_cont.builder.getInt32Ty(), false);

  g_cont.createFunction(g_cont.builder.getVoidTy(),
                        {g_cont.builder.getInt32Ty()}, "__glang_print");
  //
  g_cont.createFunction(g_cont.builder.getInt32Ty(), "__glang_read");
}

void Builder::create_Gl_interface() {

  // int get_random_val();
  auto name = "get_random_val";
  auto &&func_decl = std::make_shared<FuncDeclNode>(name);
  llvm::Function *cur_func =
      g_cont.createFunction(g_cont.builder.getInt32Ty(), name);
  func_decl->set_func(cur_func);
  m_current_scope->insert_decl(name, func_decl);

  // void flush();
  name = "flush";
  func_decl = std::make_shared<FuncDeclNode>(name);
  cur_func = g_cont.createFunction(g_cont.builder.getVoidTy(), name);
  func_decl->set_func(cur_func);
  m_current_scope->insert_decl(name, func_decl);

  // bool is_open_window();
  name = "is_open_window";
  func_decl = std::make_shared<FuncDeclNode>(name);
  cur_func = g_cont.createFunction(g_cont.builder.getVoidTy(), name);
  func_decl->set_func(cur_func);
  m_current_scope->insert_decl(name, func_decl);

  // void graph_init();
  name = "graph_init";
  func_decl = std::make_shared<FuncDeclNode>(name);
  cur_func = g_cont.createFunction(g_cont.builder.getVoidTy(), name);
  func_decl->set_func(cur_func);
  m_current_scope->insert_decl(name, func_decl);

  // void set_pixel(int x, int y, int r, int g, int b);
  name = "set_pixel";
  func_decl = std::make_shared<FuncDeclNode>(name);
  cur_func = g_cont.createFunction(
      g_cont.builder.getVoidTy(),
      {g_cont.builder.getInt32Ty(), g_cont.builder.getInt32Ty(),
       g_cont.builder.getInt32Ty(), g_cont.builder.getInt32Ty(),
       g_cont.builder.getInt32Ty()},
      name);
  func_decl->set_func(cur_func);
  m_current_scope->insert_decl(name, func_decl);

  // void window_clear(uint8_t r, uint8_t g, uint8_t b);
  name = "window_clear";
  func_decl = std::make_shared<FuncDeclNode>(name);
  cur_func = g_cont.createFunction(g_cont.builder.getVoidTy(),
                                   {g_cont.builder.getInt32Ty(),
                                    g_cont.builder.getInt32Ty(),
                                    g_cont.builder.getInt32Ty()}, name);
  func_decl->set_func(cur_func);
  m_current_scope->insert_decl(name, func_decl);
}

} // namespace glang
