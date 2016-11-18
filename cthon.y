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
%token _UNSIGNED_NUMBER
%token _LPAREN
%token _RPAREN
%token _COMMA
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _PLUS
%token _MINUS
%token _TIMES
%token _DIV
%token _RELOP
%token _LF
%token _CHAR

%%


program
    :   variable_list function_list
    |   function_list
    ;

variable_list
    :   variable _SEMICOLON
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
    |   return_statement
    |   compound_statement 
    ;

assignment_statement
    :   _ID _ASSIGN num_exp _SEMICOLON
    |   _ID _ASSIGN _CHAR _SEMICOLON
    |   _TYPE assignment_statement
    ;

num_exp
    :   mul_exp
    |   num_exp _PLUS mul_exp
    |   num_exp _MINUS mul_exp
    ;

mul_exp
    :   exp
    |   mul_exp _TIMES exp
    |   mul_exp _DIV exp
    ;

exp
    :   constant
    |   _ID
    |   function_call
    |   _LPAREN exp _RPAREN /* @TODO: check if this works */
    ;

constant
    :   _INT_NUMBER
    |   _UNSIGNED_NUMBER
    ;

function_call
    :   _ID _LPAREN arguments _RPAREN
    ;

arguments
    :   /* empty */
    |   argument_list
    ;

argument_list
    :   num_exp
    |   argument_list _COMMA num_exp
    ;

if_statement
    :   if_part
    |   if_part _ELSE statement
    ;

if_part
    :   _IF _LPAREN rel_exp _RPAREN statement
    ;

rel_exp
    :   num_exp _RELOP num_exp
    ;

return_statement
    :   _RETURN num_exp _SEMICOLON
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
