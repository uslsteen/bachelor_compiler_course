#ifndef NODE_HH
#define NODE_HH
//
#include <map>
#include <memory>
#include <unordered_map>
#include <vector>
//
#include "llvm/IR/Constants.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
//
namespace glang {

enum class BinOp : uint8_t {
  PLUS,
  MIN,
  MUL,
  DIV,
  MOD,
  AND,
  OR,
  IS_EQ,
  NOT_EQ,
  GREATER,
  LESS,
  GR_EQ,
  LS_EQ,
  ASSIGN,
};

enum class UnOp : uint8_t {
  NOT,
  //! NOTE: I/O operators
  OUTPUT,
  INPUT,
};

/**
 * @brief
 *
 */
struct GlangContext {
  //
  llvm::LLVMContext context{};
  llvm::Module module;
  llvm::IRBuilder<> builder;
  //
  llvm::Function *global_func = nullptr;

  //
  GlangContext(const std::string &name)
      : context(), module(name, context), builder(context) {
    //
    global_func = createFunction(builder.getInt32Ty(), "global_func");
    auto *bb = llvm::BasicBlock::Create(context, "", global_func);
    //
    builder.SetInsertPoint(bb);
  }

  llvm::Function *createFunction(llvm::Type *ret_type,
                                 const std::string &func_name) {
    llvm::FunctionType *func_type = llvm::FunctionType::get(ret_type, false);
    //
    llvm::Function *func = llvm::Function::Create(
        func_type, llvm::Function::ExternalLinkage, func_name, module);
    //
    return func;
  }

  llvm::Function *createFunction(llvm::Type *ret_type,
                                 std::vector<llvm::Type *> arg_types,
                                 const std::string &func_name) {
    llvm::ArrayRef<llvm::Type *> args{arg_types};
    //
    llvm::FunctionType *func_type =
        llvm::FunctionType::get(ret_type, args, false);
    //
    llvm::Function *func = llvm::Function::Create(
        func_type, llvm::Function::ExternalLinkage, func_name, module);
    //
    return func;
  }
  //

  llvm::Function *getFunction(const std::string &func_name) {
    auto *func = module.getFunction(func_name);

    if (func == nullptr)
      return nullptr;
    //! TODO: throw expection
    // std::cerr << "nullptr func : " << func_name << std::endl;

    return func;
  }
};

/**
 * @brief
 *
 */
struct INode {
  virtual llvm::Value *codegen(GlangContext &context) = 0;
  virtual ~INode() {}
};

class IntNode : public INode {
  //
  std::int32_t m_val;

public:
  IntNode(std::int32_t val) : m_val{val} {}
  //
  std::int32_t get() const { return m_val; }

  llvm::Value *codegen(GlangContext &context) override;
};

class UnOpNode : public INode {
  //
  std::shared_ptr<INode> m_val;
  UnOp m_op;
  //
public:
  UnOpNode(UnOp op, std::shared_ptr<INode> val) : m_val{val}, m_op{op} {}

  llvm::Value *codegen(GlangContext &context) override;
};

class BinOpNode : public INode {
  //
  std::shared_ptr<INode> m_lhs, m_rhs;
  BinOp m_op;
  //
public:
  BinOpNode(std::shared_ptr<INode> lhs, BinOp op, std::shared_ptr<INode> rhs)
      : m_lhs{lhs}, m_rhs{rhs}, m_op{op} {}

  llvm::Value *codegen(GlangContext &context) override;
};

struct DeclNode : public INode {
  virtual llvm::Value *codegen(GlangContext &context) override = 0;
};

class DeclVarNode : public DeclNode {
  //
  llvm::Value *m_alloca = nullptr;

public:
  llvm::Value *codegen(GlangContext &context) override;

  void store(GlangContext &context, llvm::Value *val);
};

class ScopeNode : public INode {

public:
  using sym_tab_t = std::unordered_map<std::string, std::shared_ptr<DeclNode>>;

private:
  std::vector<std::shared_ptr<INode>> m_childs;
  std::shared_ptr<ScopeNode> m_parent = nullptr;

  sym_tab_t m_symb_tab;

public:
  ScopeNode() = default;
  ScopeNode(std::shared_ptr<ScopeNode> parent) : m_parent{parent} {}

  /**
   * @brief
   *
   * @param[in] child
   */
  void insert_node(std::shared_ptr<INode> child) { m_childs.push_back(child); }

  /**
   * @brief Get the Parent object
   *
   * @return std::shared_ptr<ScopeNode>
   */
  std::shared_ptr<ScopeNode> get_parent() const { return m_parent; }

  /**
   * @brief Get the Decl If Visible object
   *
   * @param[in] name
   * @return std::shared_ptr<DeclNode>
   */
  std::shared_ptr<DeclNode> get_decl(const std::string &name) const;

  /**
   * @brief
   *
   * @param[in] name
   * @param[in] decl
   */
  void insert_decl(const std::string &name, std::shared_ptr<DeclNode> decl) {
    m_symb_tab[name] = decl;
  }

  const sym_tab_t &symb_tab() const { return m_symb_tab; }

  llvm::Value *codegen(GlangContext &context) override;
};

class IfNode : public INode {
  //
  std::shared_ptr<ScopeNode> m_if_scope;
  std::shared_ptr<INode> m_cond;
  std::shared_ptr<ScopeNode> m_p_scope;
  //
public:
  IfNode(std::shared_ptr<ScopeNode> if_scope, std::shared_ptr<INode> cond,
         std::shared_ptr<ScopeNode> p_scope)
      : m_if_scope(if_scope), m_cond(cond), m_p_scope(p_scope) {}

  llvm::Value *codegen(GlangContext &context) override;
};

class WhileNode : /* maybe public LoopNode */ public INode {
  //
  std::shared_ptr<ScopeNode> m_while_scope;
  std::shared_ptr<INode> m_cond;
  std::shared_ptr<ScopeNode> m_p_scope;
  //
public:
  WhileNode(std::shared_ptr<ScopeNode> while_scope, std::shared_ptr<INode> cond,
            std::shared_ptr<ScopeNode> p_scope)
      : m_while_scope(while_scope), m_cond(cond), m_p_scope(p_scope) {}

  llvm::Value *codegen(GlangContext &context) override;
};

class LoopNode : public INode {};

class RetNode : public INode {
  //
  std::shared_ptr<INode> m_val;
  //
public:
  RetNode(std::shared_ptr<INode> val) : m_val(val) {}

  llvm::Value *codegen(GlangContext &context) override;
};

class FuncDeclNode : public INode {};

} // namespace glang

#endif //! NODE_HH