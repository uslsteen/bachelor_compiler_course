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
  GlangContext(const std::string &name)
      : context(), module(name, context), builder(context) {}
  //
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
public:
  IntNode(std::int32_t val) : m_val{val} {}

  //
  std::int32_t get() const { return m_val; }

  //
  llvm::Value *codegen(GlangContext &context) override;

private:
  std::int32_t m_val;
};

class UnOpNode : public INode {
public:
  //
  UnOpNode(UnOp op, std::shared_ptr<INode> val) : m_val{val}, m_op{op} {}

  //
  llvm::Value *codegen(GlangContext &context) override;

private:
  std::shared_ptr<INode> m_val;
  UnOp m_op;
};

class BinOpNode : public INode {
public:
  BinOpNode(std::shared_ptr<INode> lhs, BinOp op, std::shared_ptr<INode> rhs)
      : m_lhs{lhs}, m_rhs{rhs}, m_op{op} {}
  
  //
  llvm::Value *codegen(GlangContext &context) override;

private:
  std::shared_ptr<INode> m_lhs, m_rhs;
  BinOp m_op;
};

struct DeclNode : public INode {
  virtual llvm::Value *codegen(GlangContext &context) override = 0;
};

class DeclVarNode : public DeclNode {
public:
  llvm::Value *codegen(GlangContext &context) override;

  //
  void store(GlangContext &context, llvm::Value *val);

private:
  llvm::Value *m_alloca = nullptr;
};

// class FuncDeclN;

class ScopeNode : public INode {

public:
  using sym_tab_t = std::unordered_map<std::string, std::shared_ptr<DeclNode>>;

private:
  std::vector<std::shared_ptr<INode>> m_childs;
  std::shared_ptr<ScopeNode> m_parent = nullptr;
  // std::shared_ptr<FuncDeclNode> m_parentFunc = nullptr;
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

  /**
   * @brief
   *
   * @param[in] builder
   * @return llvm::Value*
   */
  llvm::Value *codegen(GlangContext &context) override;

  const sym_tab_t &getSymTab() const { return m_symb_tab; }
};

class IfNode : public INode {};

class LoopNode : public INode {};

class WhileNood : /* maybe public LoopNode */ public INode {};

class FuncDeclNode : public INode {};

} // namespace glang

#endif //! NODE_HH