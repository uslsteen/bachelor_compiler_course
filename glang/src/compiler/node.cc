#include "compiler/node.hh"

namespace glang {

std::shared_ptr<DeclNode> ScopeNode::get_decl(const std::string &name) const {
  std::shared_ptr<DeclNode> ret = nullptr;
  auto &&it = m_symb_tab.find(name);
  //
  if (it != m_symb_tab.end()) {
    return it->second;
  }
  if (m_parent) {
    return m_parent->get_decl(name);
  }
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
    //! TODO: implement operation
    assert(0);
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

    return nullptr;
  }
  //
  return nullptr;
}

llvm::Value *UnOpNode::codegen(GlangContext &g_cont) {
  auto &&module = g_cont.module;
  auto &&builder = g_cont.builder;
  //
  llvm::Value *val;
  if (m_val)
    val = m_val->codegen(g_cont);
  //
  switch (m_op) {
  case UnOp::NOT:
    return builder.CreateNot(val);
  case UnOp::OUTPUT: {
    auto *glang_print = module.getFunction("__glang_print");
    assert(glang_print && "Driver shall create decl for __glang_print");

    llvm::Value *args[] = {val};
    return builder.CreateCall(glang_print, args);
  }
  case UnOp::INPUT: {
    auto *glang_read = module.getFunction("__glang_read");
    assert(glang_read && "Driver shall create decl for __glang_read");
    //
    return builder.CreateCall(glang_read);
  }
  };

  return nullptr;
}

} // namespace glang