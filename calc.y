%{
#include <ctype.h>
#include <stdio.h>
int yyparse(void);
int yylex(void);
int yyerror(char *s);

%}

%token NUMBER
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE   
%token NEWLINE

%left PLUS MINUS
%left MULTIPLY DIVIDE
%right UMINUS

%%

lines
    :    /* empty */
    |    lines NEWLINE
    |    lines expression NEWLINE           { printf("%d\n\n", $2); }
    ;

expression
    :    expression PLUS expression             { $$ = $1 + $3; }
    |    expression MINUS expression            { $$ = $1 - $3; }
    |    expression MULTIPLY expression         { $$ = $1 * $3; }
    |    expression DIVIDE expression           { $$ = $1 / $3; }
    |    MINUS expression %prec UMINUS          { $$ = -$2; }
    |    NUMBER                    		        { $$ = $1; }
    ;

%%

int main() {
    return yyparse();
}

int yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
