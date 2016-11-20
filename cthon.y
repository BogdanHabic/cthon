%{
#include <ctype.h>
#include <stdio.h>
int yyparse(void);
int yylex(void);
int yyerror(char *s);
FILE *python;
extern int depth;
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
%token _INC
%token _DEC
%token _LF

%%


program
    :   variable_list function_list
        {
            fputs($1, python);
            fputs($2, python);
        }
    |   function_list
        {
            fputs($1, python); 
        }
    |   variable_list
        {
            fputs($1, python);
        }
    ;

variable_list
    :   /* empty */ {$$ = strdup("");}
    |   variable_list variable _SEMICOLON        
        {
            $$ = strdup("");
        }
    |   variable_list variable _ASSIGN exp _SEMICOLON        
        {
            $$ = strdup($1);
            strcat($$, $2);
            strcat($$, "=");
            strcat($$, $4);
            strcat($$, "\n");
        }
    ;

variable
    :   type _ID
        {
            $$ = strdup($2);
        }
    ;

type
    :   _TYPE
    ;

function_list
    :   function
        {
            $$ = strdup($1);
        }
    |   function_list function
        {
            $$ = strdup($1);
            strcat($$, $2);
        }
    ;

function
    :   type _ID _LPAREN parameters _RPAREN body
        {
            $$ = strdup("def ");
            if (strcmp($2, "main") == 0)
                strcat($$, "__main__");
            else strcat($$, $2);
            strcat($$, "(");
            strcat($$, $4);
            strcat($$, ")\n");
            strcat($$, $6);

        }
    ;

parameters
    :   /* empty */ {$$ = strdup("");}
    |   parameter_list
    ;

parameter_list
    :   variable
    |   parameter_list _COMMA variable
    ;

body
    :   _LBRACKET variable_list statement_list _RBRACKET
        {
            $$ = strdup("");
            int i;
            for (i = 0; i < depth; i++)
                strcat($$, "\t");

            strcat($$, $2);
            strcat($$, $3);
        }
    |   _LBRACKET statement_list _RBRACKET
        {
            $$ = strdup("");
            int i;
            for (i = 0; i < depth; i++)
                strcat($$, "\t");
            strcat($$, $2);
        }
    ;

statement_list
    :   /* empty */ {$$ = strdup("");}
    |   statement_list statement
        {
            $$ = strdup($1);
            strcat($$, $2);
        }
    ;

statement
    :   assignment_statement {$$ = strdup($1);}
    |   if_statement {$$ = strdup($1);}
    |   switch_statement {$$ = strdup($1);}
    |   while_statement {$$ = strdup($1);}
    |   for_statement {$$ = strdup($1);}
    |   return_statement {$$ = strdup($1);}
    |   compound_statement  {$$ = strdup($1);}
    ;

assignment_statement
    :   _ID _ASSIGN exp
        {
            $$ = strdup($1);
            strcat($$, "=");
            strcat($$, $3);
        }
    |   _ID _ASSIGN exp _SEMICOLON
        {
            $$ = strdup($1);
            strcat($$, "=");
            strcat($$, $3);
        }
    ;

number
    :   _INT_NUMBER {$$ = strdup($1);}
    |   _UNSIGNED_NUMBER {$$ = strdup($1);}
    |   _REAL_NUMBER {$$ = strdup($1);}
    ;

arithmetic_exp
    :   number
    |   arithmetic_exp _PLUS number
        {
            $$ = strdup($1);
            strcat($$, "+");
            strcat($$, $3);
        }
    |   arithmetic_exp _MINUS number
         {
            $$ = strdup($1);
            strcat($$, "-");
            strcat($$, $3);
        }
    |   arithmetic_exp _TIMES number
         {
            $$ = strdup($1);
            strcat($$, "*");
            strcat($$, $3);
        }
    |   arithmetic_exp _DIV number
         {
            $$ = strdup($1);
            strcat($$, "/");
            strcat($$, $3);
        }
    ;

exp
    :   constant {$$ = strdup($1); }
    |   _ID { $$ = strdup($1); }
    |   arithmetic_exp { $$ = strdup($1); }
    |   function_call { $$ = strdup($1); }
    |   rel_exp { $$ = strdup($1); }
    |   inc_dec { $$ = strdup($1); }
    |   _LPAREN exp _RPAREN 
        {
            $$ = strdup("("); 
            strcat($$, $2);
            strcat($$, ")");
        }
    ;

constant
    :   _CHAR {$$ = strdup($1); }
    |   _STRING {$$ = strdup($1); }
    |   number {$$ = strdup($1); }
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
        {
            $$ = strdup("if ");
            strcat($$, $3);
            strcat($$, ":\n");
            strcat($$, $5);
        }
    |   _IF _LPAREN rel_exp _RPAREN statement
        {
            $$ = strdup("if ");
            strcat($$, $3);
            strcat($$, ":\n");
            strcat($$, $5);
        }
    ;

elif_part
    :   _ELIF _LPAREN rel_exp _RPAREN body
    |   _ELIF _LPAREN rel_exp _RPAREN statement
    ;

else_part
    :   _ELSE body
    |   _ELSE statement
    :   if_part {$$ = strdup($1);}
    |   if_part _ELSE statement
    ;

switch_statement
    :   _SWITCH _LPAREN exp _RPAREN _LBRACKET case_list _RBRACKET
    ;

case_list
    :   /* empty */ {$$ = strdup("");}
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
    |   _DO body _WHILE _LPAREN rel_exp _RPAREN _SEMICOLON
    ;

for_statement
    :   _FOR _LPAREN assignment_statement _SEMICOLON rel_exp _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN assignment_statement _SEMICOLON rel_exp _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN _SEMICOLON rel_exp _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN _SEMICOLON rel_exp _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN assignment_statement _SEMICOLON _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN assignment_statement _SEMICOLON _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN assignment_statement _SEMICOLON rel_exp _SEMICOLON _RPAREN body
    |   _FOR _LPAREN assignment_statement _SEMICOLON rel_exp _SEMICOLON _RPAREN statement
    |   _FOR _LPAREN _SEMICOLON _SEMICOLON _RPAREN body
    |   _FOR _LPAREN _SEMICOLON _SEMICOLON _RPAREN statement
    ;

inc_dec
    :   _ID _INC
    |   _ID _DEC
    |   _INC _ID
    |   _DEC _ID
    ;

rel_exp
    :   exp _RELOP exp
    |   _NEGATE exp
    |   exp
    ;

return_statement
    :   _RETURN exp _SEMICOLON
    ;

compound_statement
    :   _LBRACKET statement_list _RBRACKET
    ;


%%

int main() {
    python = fopen("python.py", "w+");
    return yyparse();
}

int yyerror(char *s) {
    extern int yylineno;
    fprintf(stderr, "%s at line %d\n", s, yylineno);
    return 0;
}
