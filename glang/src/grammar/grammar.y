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
    namespace glang { class INode; class ScopeNode; }
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
  BIT_XOR           "^"
  BIT_NOT           "~"
  IF			    "if"
  ELSE              "else"
  WHILE     		"while"
  BREAK             "break"
  OUTPUT            "print"
  INPUT             "read"
  RET               "return"
  DOT               "."
  UNKNOWN
  ERR
;

%token <int32_t>     INT
%token <std::string> NAME

%nterm<std::shared_ptr<glang::ScopeNode>>     global_scope
%nterm<std::shared_ptr<glang::ScopeNode>>     scope
%nterm<std::shared_ptr<glang::ScopeNode>>     open_scope
%nterm<std::shared_ptr<glang::ScopeNode>>     close_scope
%nterm<std::shared_ptr<glang::INode>>      decl
%nterm<std::shared_ptr<glang::INode>>      l_value
%nterm<std::shared_ptr<glang::INode>>      if 
%nterm<std::shared_ptr<glang::INode>>      while
%nterm<std::shared_ptr<glang::INode>>      stmts
%nterm<std::shared_ptr<glang::INode>>      stmt
%nterm<std::shared_ptr<glang::INode>>      expr
%nterm<std::shared_ptr<glang::INode>>      expr_term
%nterm<std::shared_ptr<glang::INode>>      input
%nterm<std::shared_ptr<glang::INode>>      output

%%
// %nterm<std::shared_ptr<glang::INode>>      expr_un

program:        scope                           { 
                                                    driver->codegen(); 
                                                };

scope:          open_scope stmts close_scope     {   $$ = $3;   };

open_scope:     LBRACE                          {
                                                    auto&& scope = driver->get_cur_scope();
                                                    scope = std::make_shared<glang::ScopeNode>(scope);
                                                };

close_scope:    RBRACE                          {
                                                    auto&& scope = driver->get_cur_scope();
                                                    $$ = scope;
                                                    scope = scope->get_parent();
                                                };



stmts:          stmt                            {
                                                    auto&& scope = driver->get_cur_scope();
                                                    scope->insert_node($1);
                                                }; 
              | stmts stmt                      {
                                                    auto&& scope = driver->get_cur_scope();
                                                    scope->insert_node($2);
                                                };

stmt:           decl                            {   $$ = $1;   };
              //| if                              {   $$ = $1;   };
              //| while                           {   $$ = $1;   };

decl:           l_value ASSIGN expr SCOLON      {   
                                                    $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::ASSIGN, $3);
                                                };

l_value:        NAME                            {
                                                    auto&& scope = driver->get_cur_scope();
                                                    auto&& decl = scope->get_decl($1);

                                                    if (decl == nullptr) {
                                                        decl = std::make_shared<glang::DeclVarNode>();
                                                        scope->insert_decl($1, decl);
                                                    }
                                                    //
                                                    $$ = decl;
                                                };

expr:           expr OR expr                    {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::OR, $3);       };
              | expr AND expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::AND, $3);      };
              | expr IS_EQ expr                 {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::IS_EQ, $3);    };
              | expr NOT_EQ expr                {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::NOT_EQ, $3);   };
              | expr GREATER expr               {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::GREATER, $3);  };
              | expr LESS expr                  {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::LESS, $3);     };
              | expr LS_EQ expr                 {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::LS_EQ, $3);  };
              | expr GR_EQ expr                 {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::GR_EQ, $3);    };
              | expr PLUS expr                  {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::PLUS, $3);     };
              | expr MIN expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::MIN, $3);      };
              | expr MUL expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::MUL, $3);      };
              | expr DIV expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::DIV, $3);      };
              | expr MOD expr                   {   $$ = std::make_shared<glang::BinOpNode>($1, glang::BinOp::MOD, $3);      };
              | expr_term                       {   $$ = $1;                                                              };
      
expr_term:      NAME                            {
                                                         auto&& scope = driver->get_cur_scope();
                                                         auto&& node = scope->get_decl($1);
                                                         assert(node != nullptr);
                                                         $$ = node;
                                                };
              | INT                             {   $$ = std::make_shared<glang::IntNode>($1);   };


output:      OUTPUT expr SCOLON                 { $$ = std::make_shared<glang::UnOpNode>(glang::UnOp::OUTPUT, $2); };

// if:                                          {};
//while:                                        {};

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