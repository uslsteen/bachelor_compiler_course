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

	#include <algorithm>
	#include <string>
	#include <vector>

    #include "llvm/IR/Module.h"

	namespace yy { class Driver; }
}

%code
{

    #include "driver/driver.hh"
    #include "builder"
    //#include <stack>
    #include <cassert>
    #include <stack>
    #include <string>
    #include <unordered_set>
    #include <memory>
    #include <set>
    #include <map>


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
  GREATER       	">"
  LPARENT		    "("
  RPARENT		    ")"
  LBRACE        	"{"
  RBRACE        	"}"
  BIT_XOR           "^"
  BIT_NOT           "~"
  IF			    "if"
  ELSE              "else"
  WHILE     		"while"
  BREAK             "break"
  RET               "return"
  DOT               "."
  UNKNOWN
  ERR
;

%token <int64_t>     INT
%token <std::string> NAME

%nterm<std::shared_ptr<glang::ScopeN>>     global_scope
%nterm<std::shared_ptr<glang::ScopeN>>     scope
%nterm<std::shared_ptr<glang::INode>>      decl
%nterm<std::shared_ptr<glang::INode>>      l_value
%nterm<std::shared_ptr<glang::INode>>      if 
%nterm<std::shared_ptr<glang::INode>>      while
%nterm<std::shared_ptr<glang::INode>>      expr
%nterm<std::shared_ptr<glang::INode>>      expr_term

%%
// %nterm<std::shared_ptr<glang::INode>>      expr_un

program:        global_scope                    { 
                                                    driver->codegen(); 
                                                };

global_scope:   global_scope stmts              {
                                                    auto&& scope = driver->get_cur_scope();
                                                    scope->insert_node($2);
                                                };
             
              | /* empty case */                {};

stmts:          stmt                            {
                                                    auto&& scope = driver->get_cur_scope();
                                                    scope->insert_node($1)
                                                }; 
            
              | stmts stmt                      {
                                                    auto&& scope = driver->get_cur_scope();
                                                    scope->insert_node($2)
                                                };

stmt:           decl                            {   $$ = $1;   };
              | if                              {   $$ = $1;   };
              | while                           {   $$ = $1;   };

decl:           l_value ASSIGN expr SCOLON      {   
                                                    $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::Assign, $3);
                                                };

l_value:        NAME                            {
                                                    auto&& scope = driver->get_cur_scope();
                                                    autu&& node = scope->get_decl($1);

                                                    if (node == nullptr) {
                                                            node = std::make_shared<glang::DeclVarN>();
                                                            scope->insert_decl($1, node);
                                                    }
                                                    //
                                                    $$ = node;
                                                };

expr:           expr OR expr                    {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::OR, $3);       };
              | expr AND expr                   {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::AND, $3);      };
              | expr IS_EQ expr                 {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::IS_EQ, $3);    };
              | expr NOT_EQ expr                {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::NOT_EQ, $3);   };
              | expr GREATER expr               {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::GREATER, $3);  };
              | expr LESS expr                  {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::LESS, $3);     };
              | expr LS_EQ expr                 {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::LESS_EQ, $3);  };
              | expr GR_EQ expr                 {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::GR_EQ, $3);    };
              | expr ADD expr                   {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::PLUS, $3);     };
              | expr MIN expr                   {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::MIN, $3);      };
              | expr MUL expr                   {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::MUL, $3);      };
              | expr DIV expr                   {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::DIV, $3);      };
              | expr MOD expr                   {   $$ = std::make_shared<glang::BinOpN>($1, glang::BinOp::MOD, $3);      };
              | expr_term                       {   $$ = $1;                                                              };
      
// expr_un:        MIN expr_un NEG              {   $$ = AST::make_un(AST::Ops::NEG, $2);   };
//               | NOT expr_un NOT              {   $$ = AST::make_un(AST::Ops::NOT, $2);   };
//               | expr_term                    {   $$ = $1;                                };
      
expr_term:         
              | NAME                            {
                                                         auto&& scope = driver->m_currentScope;
                                                         auto&& node = scope->get_decl($1);
                                                         assert(node != nullptr);
                                                         $$ = node;
                                                };
              | INT                             {   $$ = std::make_shared<glang::INT>($1);   };

if:                                             {};

while:                                          {};

expr:           

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