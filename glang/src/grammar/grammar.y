%language "c++"

%skeleton "lalr1.cc"
%defines
%define api.value.type variant
%define parse.error custom

%param {Driver* driver}

%locations
%debug


%code requires
{
	#include <string>
	#include <vector>
    #include <memory>

	namespace yy { class Driver; }
    namespace glang { class INode; class ScopeNode; class FuncDeclNode; }
}

%code
{

    #include "driver/driver.hh"
    #include "compiler/node.hh"

	namespace yy {
		parser::token_type yylex (parser::semantic_type* yylval, parser::location_type* l, Driver* driver);
	}
}

%token
  PLUS 			    "+"
  MIN			    "-"
  MUL			    "*"
  DIV			    "/"
  MOD               "%"
  ASSIGN            "="
  GREATER       	">"
  LESS          	"<"
  LS_EQ			    "<="
  GR_EQ		        ">="
  IS_EQ         	"=="
  NOT_EQ         	"!="
  OR                "||"
  AND               "&&"
  NOT               "!"
  COMMA             ","
  SCOLON  		    ";"
  COLON             ":"
  LPARENT		    "("
  RPARENT		    ")"
  LBRACE        	"{"
  RBRACE        	"}"
  LSBR              "["
  RSBR              "]"
  BIT_XOR           "^"
  BIT_NOT           "~"
  IF			    "if"
  ELSE              "else"
  WHILE     		"while"
  BREAK             "break"
  OUTPUT            "print"
  INPUT             "read"
  FUNC              "function"
  RET               "return"
  DOT               "."
  UNKNOWN
  ERR
;

%token <int32_t>     INT
%token <std::string> NAME

%nterm<std::shared_ptr<glang::ScopeNode>>                  global_scope
%nterm<std::shared_ptr<glang::ScopeNode>>                  scope
%nterm<std::shared_ptr<glang::ScopeNode>>                  open_scope
%nterm<std::shared_ptr<glang::ScopeNode>>                  close_scope
%nterm<std::shared_ptr<glang::INode>>                      decl
%nterm<std::shared_ptr<glang::INode>>                      cond
%nterm<std::shared_ptr<glang::INode>>                      l_value
%nterm<std::shared_ptr<glang::INode>>                      if 
%nterm<std::shared_ptr<glang::INode>>                      while
%nterm<std::shared_ptr<glang::INode>>                      stmts
%nterm<std::shared_ptr<glang::INode>>                      stmt
%nterm<std::shared_ptr<glang::INode>>                      expr
%nterm<std::shared_ptr<glang::INode>>                      expr_term
%nterm<std::shared_ptr<glang::INode>>                      args       
%nterm<std::shared_ptr<glang::FuncDeclNode>>               signature
%nterm<std::shared_ptr<glang::INode>>                      func
%nterm<std::shared_ptr<glang::INode>>                      func_call
%nterm<std::shared_ptr<glang::INode>>                      return
%nterm<std::shared_ptr<glang::INode>>                      input
%nterm<std::shared_ptr<glang::INode>>                      output
%nterm<std::shared_ptr<glang::INode>>                      global_var
%nterm<std::shared_ptr<glang::INode>>                      arr_access

%%
// %nterm<std::shared_ptr<glang::INode>>      expr_un

program:        global_scope                    { 
                                                    driver->codegen(); 
                                                };
//
global_scope:   global_scope func               {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    cur_scope->insert_node($2);
                                                };
              | global_scope global_var         {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    cur_scope->insert_node($2);
                                                };
              |                                 {}; 
//
global_var:     NAME LSBR INT RSBR              {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    auto&& cur_node = std::make_shared<glang::DeclArrNode>($3);
                                                    cur_node->set_name($1);
                                                    $$ = cur_node;
                                                    cur_scope->insert_decl($1, cur_node);
                                                };

arr_access:     NAME LSBR expr_term RSBR        {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    auto&& cur_node = cur_scope->get_decl($1);
                                                    //
                                                    $$ = std::make_shared<glang::ArrAccessNode>($3, cur_node);
                                                };
//
func:          FUNC signature stmts close_scope {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    auto&& name = $2->get_name();
                                                    cur_scope->insert_decl(name, $2);
                                                    $$ = std::make_shared<glang::FuncNode>($4, $2);
                                                };
//
signature:     NAME LPARENT args RPARENT LBRACE {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    cur_scope = std::make_shared<glang::ScopeNode>(cur_scope);
                                                    auto&& cur_args = driver->get_cur_args();
                                                    //
                                                    for (auto&& arg : cur_args) {
                                                        auto&& node = std::make_shared<glang::DeclVarNode>();
                                                        cur_scope->insert_decl(arg, node);
                                                    }
                                                    //
                                                    $$ = std::make_shared<glang::FuncDeclNode>($1, cur_args);
                                                    cur_scope->set_pfunc($$);
                                                    //
                                                    auto&& pcur_scope = cur_scope->get_parent();
                                                    pcur_scope->insert_decl($1, $$);
                                                    //
                                                    cur_args.clear();
                                                };
//
args:           args COMMA NAME                 {
                                                    auto&& cur_args = driver->get_cur_args();
                                                    cur_args.push_back($3); 
                                                };
              | NAME                            {
                                                    auto&& cur_args = driver->get_cur_args();
                                                    cur_args.push_back($1);
                                                };
              |                                 {};
//
scope:          open_scope stmts close_scope    {   $$ = $3;   };
//
open_scope:     LBRACE                          {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    cur_scope = std::make_shared<glang::ScopeNode>(cur_scope);
                                                };
//
close_scope:    RBRACE                          {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    $$ = cur_scope;
                                                    cur_scope = cur_scope->get_parent();
                                                };
//
stmts:          stmt                            {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    cur_scope->insert_node($1);
                                                }; 
              | stmts stmt                      {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    cur_scope->insert_node($2);
                                                };
//
stmt:           decl                            {   $$ = $1;   };
              | input                           {   $$ = $1;   };
              | output                          {   $$ = $1;   };
              | if                              {   $$ = $1;   };
              | while                           {   $$ = $1;   };
              | return                          {   $$ = $1;   };
              | BREAK                           {   $$ = std::make_shared<glang::BreakNode>();   };
              | func_call                       {   $$ = $1;   };
              |                                 {};
//
decl:           l_value ASSIGN expr             {   
                                                    $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::ASSIGN, $3);
                                                };
//
l_value:        NAME                            {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    auto&& decl = cur_scope->get_decl($1);
                                                    //
                                                    if (decl == nullptr) {
                                                        decl = std::make_shared<glang::DeclVarNode>();
                                                        cur_scope->insert_decl($1, decl);
                                                    }
                                                    //
                                                    $$ = decl;
                                                };
              | arr_access                      {   $$ = $1;   };
//
expr:           expr OR expr                    {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::OR, $3);       };
              | expr AND expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::AND, $3);      };
              | expr IS_EQ expr                 {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::IS_EQ, $3);    };
              | expr NOT_EQ expr                {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::NOT_EQ, $3);   };
              | expr GREATER expr               {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::GREATER, $3);  };
              | expr LESS expr                  {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::LESS, $3);     };
              | expr LS_EQ expr                 {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::LS_EQ, $3);    };
              | expr GR_EQ expr                 {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::GR_EQ, $3);    };
              | expr PLUS expr                  {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::PLUS, $3);     };
              | expr MIN expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::MIN, $3);      };
              | expr MUL expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::MUL, $3);      };
              | expr DIV expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::DIV, $3);      };
              | expr MOD expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::MOD, $3);      };
              | expr_term                       {   $$ = $1;                                                                 };
//
expr_term:      NAME                            {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    auto&& node = cur_scope->get_decl($1);
                                                    assert(node != nullptr);
                                                    $$ = node;
                                                };
              | INT                             {   $$ = std::make_shared<glang::IntNode>($1);   };
              | func_call                       {   $$ = $1;   };
              | arr_access                      {   $$ = $1;   };

//
output:         OUTPUT expr                     {   $$ = std::make_shared<glang::UnOpNode>(glang::UnOp::OUTPUT, $2);   };
input:          INPUT expr                      {   $$ = std::make_shared<glang::UnOpNode>(glang::UnOp::OUTPUT, $2);   }
//
cond:           NOT expr                        {   $$ = std::make_shared<glang::UnOpNode>(glang::UnOp::NOT, $2);            };
              | expr                            {   $$ = $1;                                                                 };
//
if:             IF LPARENT cond RPARENT scope   {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    $$ = std::make_shared<glang::IfNode>($5, $3, cur_scope);
                                                };
                                        
              | IF cond scope                   {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    $$ = std::make_shared<glang::IfNode>($3, $2, cur_scope);
                                                };
//
while:          WHILE LPARENT cond RPARENT scope  {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    $$ = std::make_shared<glang::WhileNode>($5, $3, cur_scope);
                                                };
              | WHILE cond scope                {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    $$ = std::make_shared<glang::WhileNode>($3, $2, cur_scope);
                                                };
//
func_call:      NAME LPARENT args RPARENT       {
                                                    auto&& cur_scope = driver->get_cur_scope();
                                                    auto&& cur_args = driver->get_cur_args();
                                                    auto&& cur_node = cur_scope->get_decl($1);
                                                    //
                                                    assert(cur_node != nullptr);                                                   
                                                    $$ = std::make_shared<glang::FuncCallNode>(cur_node, cur_scope, cur_args);
                                                    cur_args.clear();
                                                
                                                };

return:         RET expr                        {
                                                    $$ = std::make_shared<glang::RetNode>($2);
                                                };


%%

namespace yy {

    void parser::error (const parser::location_type& location, const std::string& string)
    {
        std::cerr << string << " in (line.column): "<< location << std::endl;
    }

    parser::token_type yylex(parser::semantic_type* yylval, parser::location_type* yylloc, Driver* driver)
    {
        return driver->yylex(yylval, yylloc);
    }

    void parser::report_syntax_error(parser::context const& ctx) const
    {
        driver->report_syntax_error(ctx);
    }
}