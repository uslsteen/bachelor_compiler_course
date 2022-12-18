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
  llvm::BasicBlock *last_not_taken = nullptr;
  //
  GlangContext(const std::string &name)
      : context(), module(name, context), builder(context) {}

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
  virtual llvm::Value *codegen(GlangContext &g_cont) = 0;
  virtual ~INode() {}
};

class IntNode : public INode {
  //
  std::int32_t m_val;

public:
  IntNode(std::int32_t val) : m_val{val} {}
  //
  std::int32_t get() const { return m_val; }

  llvm::Value *codegen(GlangContext &g_cont) override;
};

class UnOpNode : public INode {
  //
  std::shared_ptr<INode> m_val;
  UnOp m_op;
  //
public:
  UnOpNode(UnOp op, std::shared_ptr<INode> val) : m_val{val}, m_op{op} {}

  llvm::Value *codegen(GlangContext &g_cont) override;
};

class BinOpNode : public INode {
  //
  std::shared_ptr<INode> m_lhs, m_rhs;
  BinOp m_op;
  //
public:
  BinOpNode(std::shared_ptr<INode> lhs, BinOp op, std::shared_ptr<INode> rhs)
      : m_lhs{lhs}, m_rhs{rhs}, m_op{op} {}

  llvm::Value *codegen(GlangContext &g_cont) override;
};

struct DeclNode : public INode {
  virtual llvm::Value *codegen(GlangContext &g_cont) override = 0;
};

class DeclVarNode : public DeclNode {
  //
  llvm::Value *m_alloca = nullptr;

public:
  llvm::Value *codegen(GlangContext &g_cont) override;

  void store(GlangContext &g_cont, llvm::Value *val);
};

class DeclArrNode : public DeclNode {
  //
  std::int32_t m_size = 0;
  llvm::Constant *m_array = nullptr;
  llvm::Type *m_array_type = nullptr;
  std::string m_name{};
  //
public:
  DeclArrNode(std::int32_t size) : m_size{size} {}
  //
  llvm::Value *codegen(GlangContext &g_cont) override;
  void set_name(const std::string &name) { m_name = name; }
  //
  llvm::Constant *get_arr() const { return m_array; }
  llvm::Type *get_arr_ty() const { return m_array_type; }
};

class ArrAccessNode : public INode {
  //
  std::shared_ptr<INode> m_access, m_arr_decl;
  llvm::Value *m_ptr = nullptr;
  //
public:
  ArrAccessNode(std::shared_ptr<INode> access, std::shared_ptr<INode> arr_decl)
      : m_access{access}, m_arr_decl{arr_decl} {}
  //
  llvm::Value *codegen(GlangContext &g_cont) override;
  void store(GlangContext &g_cont, llvm::Value *val) {
    g_cont.builder.CreateStore(val, m_ptr);
  }
};

class FuncDeclNode;

class ScopeNode : public INode {

public:
  using sym_tab_t = std::unordered_map<std::string, std::shared_ptr<DeclNode>>;

private:
  std::vector<std::shared_ptr<INode>> m_childs;
  std::shared_ptr<ScopeNode> m_parent = nullptr;
  std::shared_ptr<FuncDeclNode> m_pfunc = nullptr;
  //
  sym_tab_t m_symb_tab;
  //
public:
  ScopeNode() = default;
  ScopeNode(std::shared_ptr<ScopeNode> parent) : m_parent{parent} {}

  void insert_node(std::shared_ptr<INode> child) { m_childs.push_back(child); }
  //
  std::shared_ptr<ScopeNode> get_parent() const { return m_parent; }
  std::shared_ptr<DeclNode> get_decl(const std::string &name) const;
  std::shared_ptr<FuncDeclNode> get_pfunc() const {

    if (m_pfunc != nullptr)
      return m_pfunc;
    else {
      auto cur_p_func = m_pfunc;
      while (cur_p_func == nullptr)
        cur_p_func = m_parent->get_pfunc();

      return cur_p_func;
    }
  }
  //
  void set_pfunc(std::shared_ptr<FuncDeclNode> pfunc) { m_pfunc = pfunc; }
  //
  const sym_tab_t &symb_tab() const { return m_symb_tab; }
  //
  void insert_decl(const std::string &name, std::shared_ptr<DeclNode> decl) {
    m_symb_tab[name] = decl;
  }
  //
  llvm::Value *codegen(GlangContext &g_cont) override;
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
      : m_if_scope(if_scope), m_cond(cond), m_p_scope(p_scope) {
    m_if_scope->set_pfunc(m_p_scope->get_pfunc());
  }

  llvm::Value *codegen(GlangContext &g_cont) override;
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
      : m_while_scope(while_scope), m_cond(cond), m_p_scope(p_scope) {
    m_while_scope->set_pfunc(m_p_scope->get_pfunc());
  }

  llvm::Value *codegen(GlangContext &g_cont) override;
};

class LoopNode : public INode {};

class RetNode : public INode {
  //
  std::shared_ptr<INode> m_val;
  //
public:
  RetNode(std::shared_ptr<INode> val) : m_val(val) {}

  llvm::Value *codegen(GlangContext &g_cont) override {
    auto *val = m_val->codegen(g_cont);
    auto *ret = g_cont.builder.CreateRet(val);
    return ret;
  }
};

class FuncDeclNode : public DeclNode {
  //
  std::vector<std::string> m_args;
  std::string m_name;
  llvm::Function *m_func = nullptr;
  //
public:
  FuncDeclNode(const std::string &name,
               const std::vector<std::string> &args = {})
      : m_args{args}, m_name{name} {}
  //
  llvm::Value *codegen(GlangContext &g_cont) override;
  //
  const std::vector<std::string> &get_args() const { return m_args; }
  const std::string &get_name() const { return m_name; }
  void set_func(llvm::Function* func ) { m_func = func; }
};

class FuncNode : public INode {
  //
  std::shared_ptr<ScopeNode> m_scope;
  std::shared_ptr<FuncDeclNode> m_header;
  //
public:
  FuncNode(std::shared_ptr<ScopeNode> scope,
           std::shared_ptr<FuncDeclNode> header)
      : m_scope{scope}, m_header{header} {}
  //
  llvm::Value *codegen(GlangContext &g_cont) override;
};

struct BreakNode : public INode {
  llvm::Value *codegen(GlangContext &g_cont) override;
};

class FuncCallNode : public INode {
  //
  std::shared_ptr<ScopeNode> m_cur_scope;
  std::vector<std::string> m_args;
  std::shared_ptr<INode> m_func_decl;
  //
public:
  FuncCallNode(std::shared_ptr<INode> func_decl,
               std::shared_ptr<ScopeNode> cur_scope,
               const std::vector<std::string> &args = {})
      : m_cur_scope{cur_scope}, m_args{args}, m_func_decl{func_decl} {}
  //
  llvm::Value *codegen(GlangContext &g_cont) override;
};

} // namespace glang

#endif //! NODE_HH