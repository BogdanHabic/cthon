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

%%

variable
    :   _TYPE _ID
    ;
%%

int main() {
    return yyparse();
}

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
