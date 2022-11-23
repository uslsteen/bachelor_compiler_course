%option c++

%option noyywrap
%option yylineno

%option warn nodefault debug noinput 
%option yyclass="Lexer"

%{

#include "parser/parser.hh"
#define YY_USER_ACTION update_loc();

%}

/* Defines parser lexems */

WS                [ \r\t\v]+
ENDL              [\n]+
DOT               [\.]
      
DIG               [0-9]
NON_ZERO_DIG      [1-9]
LETTER            [a-zA-Z]
LETTER_OR_DIG     [A-Za-z0-9_]

INT               {NON_ZERO_DIG}{DIG}*
DOUBLE            {DIG}+{DOT}?{DIG}*
NAME              {LETTER}{LETTER_OR_DIG}*

%%

{WS}              {}
{ENDL}            {}

"+"               return yy::parser::token_type::PLUS;
"-"               return yy::parser::token_type::MIN;
"*"               return yy::parser::token_type::MUL;
"/"               return yy::parser::token_type::DIV;
"%"               return yy::parser::token_type::MOD;
"="               return yy::parser::token_type::ASSIGN;

">"               return yy::parser::token_type::GREATER;
"<"               return yy::parser::token_type::LESS;
">="              return yy::parser::token_type::GR_EQ;
"<="              return yy::parser::token_type::LS_EQ;
"=="              return yy::parser::token_type::IS_EQ;
"!="              return yy::parser::token_type::NOT_EQ;

"||"              return yy::parser::token_type::OR;
"&&"              return yy::parser::token_type::AND;
"!"               return yy::parser::token_type::NOT;

","               return yy::parser::token_type::COMMA;
":"               return yy::parser::token_type::COLON;
";"               return yy::parser::token_type::SCOLON;

"("               return yy::parser::token_type::LPARENT;
")"               return yy::parser::token_type::RPARENT;
"{"               return yy::parser::token_type::LBRACE;
"}"               return yy::parser::token_type::RBRACE;

{INT}             return yy::parser::token_type::INT;
{NAME}            return yy::parser::token_type::NAME;
{DOT}             return yy::parser::token_type::DOT;

"if"              return yy::parser::token_type::IF;
"else"            return yy::parser::token_type::ELSE;
"while"           return yy::parser::token_type::WHILE;
"break"           return yy::parser::token_type::BREAK;
"return"          return yy::parser::token_type::RET;

"print"           return yy::parser::token_type::OUTPUT;
"read"            return yy::parser::token_type::INPUT;

.                 return yy::parser::token_type::ERR;

%%