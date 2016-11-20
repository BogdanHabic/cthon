%{
#include <ctype.h>
#include <stdio.h>
int yyparse(void);
int yylex(void);
int yyerror(char *s);

%}

%token _TYPE
%token _IF
%token _ELSE
%token _ELIF
%token _SWITCH
%token _CASE
%token _DEFAULT
%token _BREAK
%token _FOR
%token _WHILE
%token _DO
%token _RETURN
%token _ID

%token _INT_NUMBER
%token _REAL_NUMBER
%token _UNSIGNED_NUMBER

%token _CHAR
%token _STRING

%token _LPAREN
%token _RPAREN
%token _COMMA
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _COLON
%token _PLUS
%token _MINUS
%token _TIMES
%token _DIV
%token _RELOP
%token _NEGATE
%token _LF

%%


program
    :   variable_list function_list
    |   function_list
    ;

variable_list
    :   variable _SEMICOLON
    |   variable _ASSIGN exp _SEMICOLON
    |   variable_list variable _SEMICOLON
    ;

variable
    :   type _ID
    ;

type
    :   _TYPE
    ;

function_list
    :   function
    |   function_list function
    ;

function
    :   type _ID _LPAREN parameters _RPAREN body
    ;

parameters
    :   /* empty */
    |   parameter_list
    ;

parameter_list
    :   variable
    |   parameter_list _COMMA variable
    ;

body
    :   _LBRACKET variable_list statement_list _RBRACKET
    |   _LBRACKET statement_list _RBRACKET
    ;

statement_list
    :   /* empty */
    |   statement_list statement
    ;

statement
    :   assignment_statement
    |   if_statement
    |   switch_statement
    |   while_statement
    |   return_statement
    |   compound_statement 
    ;

assignment_statement
    :   _ID _ASSIGN exp _SEMICOLON
    ;

number
    :   _INT_NUMBER
    |   _UNSIGNED_NUMBER
    |   _REAL_NUMBER
    ;

arithmetic_exp
    :   number
    |   arithmetic_exp _PLUS number
    |   arithmetic_exp _MINUS number
    |   arithmetic_exp _TIMES number
    |   arithmetic_exp _DIV number
    ;

exp
    :   constant
    |   _ID
    |   arithmetic_exp
    |   function_call
    |   rel_exp
    |   _LPAREN exp _RPAREN /* @TODO: check if this works */
    ;

constant
    :   _CHAR
    |   _STRING
    |   number
    ;

function_call
    :   _ID _LPAREN arguments _RPAREN
    ;

arguments
    :   exp
    |   arguments _COMMA exp
    ;

if_statement
    :   if_part
    |   if_statement elif_part
    |   if_statement elif_part else_part
    |   if_part else_part
    ;

if_part
    :   _IF _LPAREN rel_exp _RPAREN body
    |   _IF _LPAREN rel_exp _RPAREN statement
    ;

elif_part
    :   _ELIF _LPAREN rel_exp _RPAREN body
    |   _ELIF _LPAREN rel_exp _RPAREN statement
    ;

else_part
    :   _ELSE body
    |   _ELSE statement
    ;

switch_statement
    :   _SWITCH _LPAREN exp _RPAREN _LBRACKET case_list _RBRACKET
    ;

case_list
    :   /* empty */
    |   case_part
    |   default_part
    |   case_list case_part
    |   case_list case_part default_part
    ;

case_part
    :   _CASE exp _COLON statement_list
    |   _CASE exp _COLON statement_list _BREAK _SEMICOLON
    ;

default_part
    :   _DEFAULT _COLON statement_list
    |   _DEFAULT _COLON statement_list _BREAK _SEMICOLON
    ;

while_statement
    :   _WHILE _LPAREN rel_exp _RPAREN body
    |   _WHILE _LPAREN rel_exp _RPAREN statement
    ;


rel_exp
    :   exp _RELOP exp
    |   _NEGATE exp
    ;

return_statement
    :   _RETURN exp _SEMICOLON
    ;

compound_statement
    :   _LBRACKET statement_list _RBRACKET
    ;


%%

int main() {
    return yyparse();
}

int yyerror(char *s) {
    extern int yylineno;
    fprintf(stderr, "%s at line %d\n", s, yylineno);
    return 0;
}
