#include "compiler/node.hh"
#include <iostream>

namespace glang {

std::shared_ptr<DeclNode> ScopeNode::get_decl(const std::string &name) const {
  std::shared_ptr<DeclNode> ret = nullptr;
  auto &&name_it = m_symb_tab.find(name);
  //
  if (name_it != m_symb_tab.end())
    return name_it->second;
  //
  if (m_parent)
    return m_parent->get_decl(name);
  //
  return ret;
}

llvm::Value *ScopeNode::codegen(GlangContext &g_cont) {
  for (auto &&child : m_childs)
    child->codegen(g_cont);
  //
  return nullptr;
}

llvm::Value *IntNode::codegen(GlangContext &g_cont) {
  return g_cont.builder.getInt32(m_val);
}

llvm::Value *DeclVarNode::codegen(GlangContext &g_cont) {
  //
  if (!m_alloca)
    m_alloca = g_cont.builder.CreateAlloca(g_cont.builder.getInt32Ty());

  return g_cont.builder.CreateLoad(g_cont.builder.getInt32Ty(), m_alloca);
}

void DeclVarNode::store(GlangContext &g_cont, llvm::Value *val) {
  g_cont.builder.CreateStore(val, m_alloca);
}

llvm::Value *BinOpNode::codegen(GlangContext &g_cont) {
  //
  auto &builder = g_cont.builder;
  llvm::Value *lhs = m_lhs->codegen(g_cont), *rhs = m_rhs->codegen(g_cont);
  //
  switch (m_op) {
  case BinOp::PLUS:
    return builder.CreateAdd(lhs, rhs);
  case BinOp::MIN:
    return builder.CreateSub(lhs, rhs);
  case BinOp::DIV:
    return builder.CreateSDiv(lhs, rhs);
  case BinOp::MOD:
    return builder.CreateSRem(lhs, rhs);
  case BinOp::MUL:
    return builder.CreateMul(lhs, rhs);
  case BinOp::AND:
    return builder.CreateAnd(lhs, rhs);
  case BinOp::OR:
    return builder.CreateOr(lhs, rhs);
  case BinOp::IS_EQ:
    return builder.CreateICmpEQ(lhs, rhs);
  case BinOp::NOT_EQ:
    return builder.CreateICmpNE(lhs, rhs);
  case BinOp::GREATER:
    return builder.CreateICmpSGT(lhs, rhs);
  case BinOp::LESS:
    return builder.CreateICmpSLT(lhs, rhs);
  case BinOp::GR_EQ:
    return builder.CreateICmpSGE(lhs, rhs);
  case BinOp::LS_EQ:
    return builder.CreateICmpSLE(lhs, rhs);
  case BinOp::ASSIGN:

    if (std::shared_ptr<DeclVarNode> decl =
            std::dynamic_pointer_cast<DeclVarNode>(m_lhs))
      decl->store(g_cont, rhs);

    else if (std::shared_ptr<ArrAccessNode> decl =
                 std::dynamic_pointer_cast<ArrAccessNode>(m_lhs))
      decl->store(g_cont, rhs);

    return nullptr;
  }
  //
  return nullptr;
}

llvm::Value *UnOpNode::codegen(GlangContext &g_cont) {
  auto &&module = g_cont.module;
  auto &&builder = g_cont.builder;
  //
  llvm::Value *val = nullptr;
  //
  if (m_val)
    val = m_val->codegen(g_cont);
  //
  switch (m_op) {
  case UnOp::NOT:
    return builder.CreateNot(val);
  //
  case UnOp::OUTPUT: {
    auto *glang_print = module.getFunction("__glang_print");
    assert(glang_print && "Driver shall create decl for __glang_print");
    //
    llvm::Value *args[] = {val};
    return builder.CreateCall(glang_print, args);
  }
  //
  case UnOp::INPUT: {
    auto *glang_read = module.getFunction("__glang_read");
    assert(glang_read && "Driver shall create decl for __glang_read");
    //
    return builder.CreateCall(glang_read);
  }
  };
  return nullptr;
}

llvm::Value *IfNode::codegen(GlangContext &g_cont) {
  auto &&builder = g_cont.builder;
  auto &&cur_func = g_cont.getFunction(m_if_scope->get_pfunc()->get_name());
  //
  llvm::BasicBlock *taken =
      llvm::BasicBlock::Create(g_cont.context, "", cur_func);
  llvm::BasicBlock *not_taken =
      llvm::BasicBlock::Create(g_cont.context, "", cur_func);
  //
  auto *cond_codegen = m_cond->codegen(g_cont);
  //
  builder.CreateCondBr(cond_codegen, taken, not_taken);
  builder.SetInsertPoint(taken);
  //
  m_if_scope->codegen(g_cont);
  //
  // if (!taken->getTerminator()) {
  //  std::cout << "Not terminator\n";
  //}
  //
  builder.CreateBr(not_taken);
  builder.SetInsertPoint(not_taken);
  return nullptr;
}

llvm::Value *WhileNode::codegen(GlangContext &g_cont) {
  auto &&builder = g_cont.builder;
  auto &&cur_func = g_cont.getFunction(m_while_scope->get_pfunc()->get_name());
  //
  llvm::BasicBlock *taken =
      llvm::BasicBlock::Create(g_cont.context, "", cur_func);
  llvm::BasicBlock *not_taken =
      llvm::BasicBlock::Create(g_cont.context, "", cur_func);
  g_cont.last_not_taken = not_taken;
  llvm::BasicBlock *cond_bb =
      llvm::BasicBlock::Create(g_cont.context, "", cur_func);
  //
  builder.CreateBr(cond_bb);
  builder.SetInsertPoint(cond_bb);
  auto *cond_codegen = m_cond->codegen(g_cont);
  //
  builder.CreateCondBr(cond_codegen, taken, not_taken);
  //
  builder.SetInsertPoint(taken);
  m_while_scope->codegen(g_cont);
  //
  builder.CreateBr(cond_bb);
  builder.SetInsertPoint(not_taken);
  //
  return nullptr;
}

llvm::Value *FuncDeclNode::codegen(GlangContext &g_cont) {
  if (!m_func) {
    std::vector<llvm::Type *> args_ty;
    for (std::size_t i = 0; i < m_args.size(); ++i)
      args_ty.push_back(g_cont.builder.getInt32Ty());
    //
    m_func =
        g_cont.createFunction(g_cont.builder.getInt32Ty(), args_ty, m_name);
  }
  return m_func;
}

llvm::Value *FuncNode::codegen(GlangContext &g_cont) {
  auto &&builder = g_cont.builder;
  auto &&context = g_cont.context;

  //! NOTE: construct function declaration
  m_header->codegen(g_cont);
  //
  auto *func = g_cont.getFunction(m_header->get_name());
  auto &&args = m_header->get_args();
  auto &&sym_table = m_scope->symb_tab();
  //
  llvm::BasicBlock *initBB = llvm::BasicBlock::Create(context, "entry", func);
  builder.SetInsertPoint(initBB);

  for (std::size_t i = 0; i < args.size(); ++i) {
    //
    auto &&it = sym_table.find(args[i]);
    if (it != sym_table.end()) {
      auto &&decl = std::dynamic_pointer_cast<DeclVarNode>(it->second);
      decl->codegen(g_cont);
      auto &&argVal = func->getArg(i);
      decl->store(g_cont, argVal);
    }
  }

  m_scope->codegen(g_cont);
  return nullptr;
}

llvm::Value *FuncCallNode::codegen(GlangContext &g_cont) {
  auto &&builder = g_cont.builder;

  auto *func_decl =
      llvm::dyn_cast<llvm::Function>(m_func_decl->codegen(g_cont));
  auto *funcTy = func_decl->getFunctionType();

  auto &&sym_table = m_cur_scope->symb_tab();

  std::vector<llvm::Value *> args;
  for (auto &&name : m_args) {
    //
    auto &&it = sym_table.find(name);
    assert(it != sym_table.end());
    args.push_back(it->second->codegen(g_cont));
  }

  auto *ret = builder.CreateCall(funcTy, func_decl, args);
  return ret;
}

llvm::Value *DeclArrNode::codegen(GlangContext &g_cont) {
  m_array_type = llvm::ArrayType::get(g_cont.builder.getInt32Ty(), m_size);

  auto &&global_array =
      new llvm::GlobalVariable(g_cont.module, m_array_type, false,
                               llvm::GlobalValue::ExternalLinkage, 0, m_name);
  //
  llvm::ConstantAggregateZero *const_global_array =
      llvm::ConstantAggregateZero::get(m_array_type);
  global_array->setInitializer(const_global_array);
  //
  m_array = g_cont.module.getOrInsertGlobal(m_name, m_array_type);
  return m_array;
}

llvm::Value *ArrAccessNode::codegen(GlangContext &g_cont) {
  auto &&builder = g_cont.builder;
  //
  std::shared_ptr<DeclArrNode> arr_decl =
      std::dynamic_pointer_cast<DeclArrNode>(m_arr_decl);
  //
  auto *arr = arr_decl->get_arr();
  auto *arr_type = arr_decl->get_arr_ty();
  //
  auto *index = m_access->codegen(g_cont);
  m_ptr = builder.CreateGEP(arr_type, arr,
                            {
                                builder.getInt32(0),
                                index,
                            });
  return builder.CreateLoad(builder.getInt32Ty(), m_ptr);
}

llvm::Value *BreakNode::codegen(GlangContext &g_cont) {
  g_cont.builder.CreateBr(g_cont.last_not_taken);
  return nullptr;
}

} // namespace glang