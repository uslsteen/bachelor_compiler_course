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
  CLASS             "class"
  METHOD            "method"
  THIS              "this"
  DOT               "."
  UNKNOWN
  ERR
;

%token <int64_t>     INT
%token <std::string> NAME

%%

arguments
: /* empty */  { }
| ne_arguments { }
;


ne_arguments
:  { }
;


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