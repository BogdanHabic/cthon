%{
#include <ctype.h>	
#include <stdio.h>
#include <string.h>
int yyparse(void);
int yylex(void);
int yyerror(char *s);
FILE *python;
extern int depth;

%}

%token <str> _TYPE
%token <str> _IF
%token <str> _ELSE
%token <str> _ELIF
%token <str> _SWITCH
%token <str> _CASE
%token <str> _DEFAULT
%token <str> _BREAK
%token <str> _FOR
%token <str> _WHILE
%token <str> _DO
%token <str> _RETURN
%token <str> _ID

%token <str> _INT_NUMBER
%token <str> _REAL_NUMBER
%token <str> _UNSIGNED_NUMBER

%token <str> _CHAR
%token <str> _STRING

%token <str> _LPAREN
%token <str> _RPAREN
%token <str> _COMMA
%token <str> _LBRACKET
%token <str> _RBRACKET
%token <str> _ASSIGN
%token <str> _SEMICOLON
%token <str> _COLON
%token <str> _PLUS
%token <str> _MINUS
%token <str> _TIMES
%token <str> _DIV
%token <str> _RELOP
%token <str> _NEGATE
%token <str> _INC
%token <str> _DEC
%token <str> _LSBRACKET
%token <str> _RSBRACKET
%token <str> _LF

%token <str> _PRINTF;
%token <str> _SCANF;

%union
{
	char* str;
}
%%


program
    :   variable_list function_list
        {
            fputs($<str>1, python);
            fputs($<str>2, python);
        }
    |   function_list
        {
        	puts("!!!!");
        	puts($<str>1);
            fputs($<str>1, python); 
        }
    |   variable_list
        {
            fputs($<str>1, python);
        }
    ;

variable_list
    :   /* empty */ {$<str>$ = strdup("");}
    |   variable_list variable _SEMICOLON        
        {
            $<str>$ = strdup("");
        }
    |   variable_list variable _ASSIGN exp _SEMICOLON        
        {
        	//puts($<str>2);
            
            $<str>$ = strdup($<str>1);
            int i;
            for (i = 0; i < depth; i++)
                strcat($<str>$, "\t");
            strcat($<str>$, $<str>2);
            strcat($<str>$, "=");
            strcat($<str>$, $<str>4);
            strcat($<str>$, "\n");
             
            
           // puts($<str>$);
        }
    ;

variable
    :   type _ID
        {
            $<str>$ = strdup($<str>2);
        }
    |   type _ID _LSBRACKET _RSBRACKET
        {
            $<str>$ = strdup($<str>2);
        }
    |   type _ID _LSBRACKET _INT_NUMBER _RSBRACKET
        {
            $<str>$ = strdup($<str>2);
        }
    ;

type
    :   _TYPE
    ;

function_list
    :   function
        {	
        }
    |   function_list function
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, $<str>2);
        }
    ;

function
    :   type _ID _LPAREN parameters _RPAREN body
        {
            $<str>$ = strdup("def ");
            if (strcmp($<str>2, "main") == 0)
                strcat($<str>$, "__main__");
            else strcat($<str>$, $<str>2);
            strcat($<str>$, "(");
            strcat($<str>$, $<str>4);
            strcat($<str>$, ")\n");
            strcat($<str>$, $<str>6);

        }
    ;

parameters
    :   /* empty */ {$<str>$ = strdup("");}
    |   parameter_list
    ;

parameter_list
    :   variable
    |   parameter_list _COMMA variable
    ;

body
    :   _LBRACKET variable_list statement_list _RBRACKET
        {
        	puts("hgh");
            $<str>$ = strdup("");
            //int i;
           // for (i = 0; i < depth; i++)
             //   strcat($<str>$, "\t");

            strcat($<str>$, $<str>2);
            strcat($<str>$, $<str>3);
            //puts($<str>$);
        }
    |   _LBRACKET statement_list _RBRACKET
        {
        	puts("auuuuu");
            $<str>$ = strdup("");
            //int i;
            //for (i = 0; i < depth; i++)
              //  strcat($<str>$, "\t");
            strcat($<str>$, $<str>2);

        }
    ;

statement_list
    :   /* empty */ {$<str>$ = strdup("");}
    |   statement_list statement
        {
        	puts("ovde1");
            
            $<str>$ = strdup($<str>1);
            strcat($<str>$, $<str>2);
             puts($<str>$);
        }
    ;

statement
    :   for_statement {$<str>$ = strdup($<str>1);}
    |   assignment_statement {$<str>$ = strdup($<str>1);}
    |   if_statement {$<str>$ = strdup($<str>1);}
    |   switch_statement {$<str>$ = strdup($<str>1);}
    |   while_statement {$<str>$ = strdup($<str>1);}
    |   printf_statement {$<str>$ = strdup($<str>1);}
    |   scanf_statement {$<str>$ = strdup($<str>1);}
    |   return_statement {$<str>$ = strdup($<str>1);}
    |   compound_statement  {$<str>$ = strdup($<str>1);}
    ;

assignment_statement
    :   _ID _ASSIGN exp
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "=");
            strcat($<str>$, $<str>3);
        }
    |   _ID _ASSIGN exp _SEMICOLON
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "=");
            strcat($<str>$, $<str>3);
        }
    |   _ID _LSBRACKET exp _RSBRACKET _ASSIGN exp _SEMICOLON
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "[");
            strcat($<str>$, strdup($<str>2));
            strcat($<str>$, "]");
            strcat($<str>$, "=");
            strcat($<str>$, $<str>6);
        }
    ;

number
    :   _INT_NUMBER {$<str>$ = strdup($<str>1);}
    |   _UNSIGNED_NUMBER {$<str>$ = strdup($<str>1);}
    |   _REAL_NUMBER {$<str>$ = strdup($<str>1);}
    ;

arithmetic_exp
    :   number
    |   arithmetic_exp _PLUS number
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "+");
            strcat($<str>$, $<str>3);
        }
    |   arithmetic_exp _MINUS number
         {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "-");
            strcat($<str>$, $<str>3);
        }
    |   arithmetic_exp _TIMES number
         {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "*");
            strcat($<str>$, $<str>3);
        }
    |   arithmetic_exp _DIV number
         {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "/");
            strcat($<str>$, $<str>3);
        }
    ;

exp
    :   constant {$<str>$ = strdup($<str>1); }
    |   _ID { $<str>$ = strdup($<str>1); }
    |   arithmetic_exp { $<str>$ = strdup($<str>1); }
    |   function_call { $<str>$ = strdup($<str>1); }
    |   rel_exp { $<str>$ = strdup($<str>1); }
    |   inc_dec { $<str>$ = strdup($<str>1); }
    |   array_exp { $<str>$ = strdup($<str>1); }
    |   array_ele_exp { $<str>$ = strdup($<str>1); }
    |   _LPAREN exp _RPAREN 
        {
            $<str>$ = strdup("("); 
            strcat($<str>$, $<str>2);
            strcat($<str>$, ")");
        }
    ;

constant
    :   _CHAR {$<str>$ = strdup($<str>1); }
    |   _STRING {$<str>$ = strdup($<str>1); }
    |   number {$<str>$ = strdup($<str>1); }
    ;

function_call
    :   _ID _LPAREN arguments _RPAREN
    ;

array_exp
    :   _LBRACKET exp_list _RBRACKET
        {
            $<str>$ = strdup("["); 
            strcat($<str>$, $<str>1);
            strcat($<str>$, "]");
        }
    ;

array_ele_exp
    :   _ID _LSBRACKET exp _RSBRACKET
    ;

exp_list
    : /* empty */
    |   exp
    |   exp_list _COMMA exp
    ;

arguments
    :   exp
    |   arguments _COMMA exp
    ;

if_statement
    :   if_part {$<str>$ = strdup($<str>1);}
    |   if_statement elif_part {$<str>$ = strdup($<str>1);}
    |   if_statement elif_part else_part {$<str>$ = strdup($<str>1);}
    |   if_part else_part {$<str>$ = strdup($<str>1);}
    ;

if_part
    :   _IF _LPAREN rel_exp _RPAREN body
        {
            int i;
            $<str>$ = strdup("");
            for (i = 0; i < depth - 1; i++)
                strcat($<str>$, "\t");
            strcat($<str>$, "if ");
            strcat($<str>$, $<str>3);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>5);
        }
    |   _IF _LPAREN rel_exp _RPAREN statement
        {
            int i;
            $<str>$ = strdup("");
            for (i = 0; i < depth - 1; i++)
                strcat($<str>$, "\t");
            strcat($<str>$, "if ");
            strcat($<str>$, $<str>3);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>5);
        }
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
    :   /* empty */ {$<str>$ = strdup("");}
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
    :   _FOR _LPAREN assignment_statement exp _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN assignment_statement exp _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN _SEMICOLON exp _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN _SEMICOLON exp _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN assignment_statement _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN assignment_statement _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN assignment_statement exp _SEMICOLON _RPAREN body
    |   _FOR _LPAREN assignment_statement exp _SEMICOLON _RPAREN statement
    |   _FOR _LPAREN _SEMICOLON _SEMICOLON _RPAREN body
    |   _FOR _LPAREN _SEMICOLON _SEMICOLON _RPAREN statement
    ;

printf_statement
    :   _PRINTF _LPAREN _STRING _RPAREN _SEMICOLON
        {
            $<str>$ = strdup("\"");
            strcat($<str>$, $<str>3);
            strcat($<str>$, "\"");
        }
    |   _PRINTF _LPAREN _STRING _COMMA arguments _RPAREN _SEMICOLON
        {
            $<str>$ = strdup("\"");
            strcat($<str>$, $<str>3);
            strcat($<str>$, "\"");
            strcat($<str>$, "%");
            strcat($<str>$, "(");
            strcat($<str>$, $<str>5);
            strcat($<str>$, ")");
        }
    ;

scanf_statement
    :   _SCANF _LPAREN _STRING _RPAREN _SEMICOLON
    |   _SCANF _LPAREN _STRING _COMMA arguments _RPAREN _SEMICOLON
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
    yyparse();
    fclose(python);
    return 0;
}

int yyerror(char *s) {
    extern int yylineno;
    fprintf(stderr, "%s at line %d\n", s, yylineno);
    return 0;
}

void printTab(char* str, int d)
{
    int i;
    for (i = 0; i < d; i++)
        strcat(str, "\t");
}
