%{
#include <ctype.h>	
#include <stdio.h>
#include <string.h>
int yyparse(void);
int yylex(void);
int yyerror(char *s);
FILE *python;
extern int depth;
int current_switch = 0;

void printTab(char* str, int d);
void strreplace(char *string[],char find[],char replaceWith[]);

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
            $<str>$ = strdup($<str>1);
            int i;
            for (i = 0; i < depth; i++)
                strcat($<str>$, "\t");
            strcat($<str>$, $<str>2);
            strcat($<str>$, "=");
            strcat($<str>$, $<str>4);
            strcat($<str>$, "\n");
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
        {
            $<str>$ = strdup($<str>1);
        }
    |   parameter_list _COMMA variable
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, ",");
            strcat($<str>$, $<str>3);
        }
    |   parameter_list variable
        {
            extern int yylineno;
            printf("Missing comma in argument list at: %d", yylineno);

            $<str>$ = strdup($<str>1);
            strcat($<str>$, ",");
            strcat($<str>$, $<str>2);
        }
    ;

body
    :   _LBRACKET variable_list statement_list _RBRACKET
        {
            $<str>$ = strdup("");
            strcat($<str>$, $<str>2);
            strcat($<str>$, $<str>3);
        }
    |   _LBRACKET statement_list _RBRACKET
        {
            $<str>$ = strdup("");
            strcat($<str>$, $<str>2);

        }
    ;

statement_list
    :   /* empty */ {$<str>$ = strdup("");}
    |   statement_list statement
        {   
            $<str>$ = strdup($<str>1);
            printTab($<str>$, depth - 1);
            strcat($<str>$, $<str>2);
            strcat($<str>$, "\n");
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

            $<str>$ = strdup("");
            //printTab($<str>$, depth - 1);            
            strcat($<str>$, "if ");
            strcat($<str>$, $<str>3);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>5);
        }
    |   _IF _LPAREN rel_exp _RPAREN statement
        {
            $<str>$ = strdup("");
            //printTab($<str>$, depth - 1);
            strcat($<str>$, "if ");
            strcat($<str>$, $<str>3);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>5);
        }
    ;

elif_part
    :   _ELIF _LPAREN rel_exp _RPAREN body
        {
            $<str>$ = strdup("");
            //printTab($<str>$, depth - 1);
            strcat($<str>$, "elif ");
            strcat($<str>$, $<str>3);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>5);
        }
    |   _ELIF _LPAREN rel_exp _RPAREN statement
        {
            $<str>$ = strdup("");
            //printTab($<str>$, depth - 1);
            strcat($<str>$, "elif ");
            strcat($<str>$, $<str>3);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>5);
        }
    ;

else_part
    :   _ELSE body
        {
            $<str>$ = strdup("");
            //printTab($<str>$, depth - 1);
            strcat($<str>$, "else: \n ");
            strcat($<str>$, $<str>2);
        }
    |   _ELSE statement
        {
            $<str>$ = strdup("");
            //printTab($<str>$, depth - 1);
            strcat($<str>$, "else: \n ");
            strcat($<str>$, $<str>2);
        }
    ;

switch_statement
    :   _SWITCH _LPAREN exp _RPAREN _LBRACKET case_list _RBRACKET
        {
          $<str>$ = strdup($<str>6);
          strreplace($<str>$, "###", $<str>3);
          current_switch = 0;
        }
    ;

case_list
    :   /* empty */ {$<str>$ = strdup("");}
    |   case_part
        {
          $<str>$ = strdup($<str>1);
        }
    |   default_part
        {
          $<str>$ = strdup($<str>1);
        }
    |   case_list case_part
        {
          $<str>$ = strdup($<str>1);
          strcat($<str>$, $<str>2);
        }
    |   case_list case_part default_part
        {
          $<str>$ = strdup($<str>1);
          strcat($<str>$, $<str>2);
          strcat($<str>$, $<str>3);
        }
    ;

case_part
    :   _CASE exp _COLON statement_list
        {
         if(current_switch == 0) {
             $<str>$ = strdup("if ");
           strcat($<str>$, "###");
           strcat($<str>$, "==");
           strcat($<str>$, $<str>1);
           strcat($<str>$, ":\n");
           strcat($<str>$, $<str>4);
           current_switch = 1;
         } else {
              $<str>$ = strdup("elif ");
              strcat($<str>$, "###");
              strcat($<str>$, "==");
              strcat($<str>$, $<str>1);
              strcat($<str>$, ":\n");
              strcat($<str>$, $<str>4);
          }
        }
    |   _CASE exp _COLON statement_list _BREAK _SEMICOLON
        {
          if(current_switch == 0) {
              $<str>$ = strdup("if ");
              strcat($<str>$, "###");
              strcat($<str>$, "==");
              strcat($<str>$, $<str>1);
              strcat($<str>$, ":\n");
              strcat($<str>$, $<str>4);
              current_switch = 1;
          } else {
              $<str>$ = strdup("elif ");
              strcat($<str>$, "###");
              strcat($<str>$, "==");
              strcat($<str>$, $<str>1);
              strcat($<str>$, ":\n");
              strcat($<str>$, $<str>4);
          }
        }
    ;

default_part
    :   _DEFAULT _COLON statement_list
        {
          if(current_switch == 0) {
              $<str>$ = strdup("if True:\n");
              strcat($<str>$, $<str>3);
          } else {
              $<str>$ = strdup("else:\n");
              strcat($<str>$, $<str>3);
          }
        }
    |   _DEFAULT _COLON statement_list _BREAK _SEMICOLON
        {
          if(current_switch == 0) {
              $<str>$ = strdup("if True:\n");
              strcat($<str>$, $<str>3);
          } else {
              $<str>$ = strdup("else:\n");
              strcat($<str>$, $<str>3);
          }
        }
    ;

while_statement
    :   _WHILE _LPAREN rel_exp _RPAREN body
    |   _WHILE _LPAREN rel_exp _RPAREN statement
    |   _DO body _WHILE _LPAREN rel_exp _RPAREN _SEMICOLON
    ;

for_statement
    :   _FOR _LPAREN assignment_statement exp _SEMICOLON exp _RPAREN body
        {
            puts("!");
            $<str>$ = strdup($<str>3);
            strcat($<str>$, "\nwhile ");
            strcat($<str>$, $<str>5);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>7);
        }
    |   _FOR _LPAREN assignment_statement exp _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN _SEMICOLON exp _SEMICOLON exp _RPAREN body
    |   _FOR _LPAREN _SEMICOLON exp _SEMICOLON exp _RPAREN statement
    |   _FOR _LPAREN assignment_statement _SEMICOLON exp _RPAREN body
        {
            puts("!");
            $<str>$ = strdup($<str>3);
            strcat($<str>$, "\nwhile ");
            strcat($<str>$, $<str>5);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>7);
        }
    |   _FOR _LPAREN assignment_statement _SEMICOLON exp _RPAREN statement
        {
            $<str>$ = strdup($<str>3);
            strcat($<str>$, "\nwhile ");
            strcat($<str>$, $<str>5);
            strcat($<str>$, ":\n");
            strcat($<str>$, $<str>7);
        }
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
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "++");
        }
    |   _ID _DEC
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, "--");
        }
    |   _INC _ID
        {
            $<str>$ = strdup("++");
            strcat($<str>$, $<str>2);
        }
    |   _DEC _ID
        {
            $<str>$ = strdup("--");
            strcat($<str>$, $<str>2);
        }
    ;

rel_exp
    :   exp _RELOP exp  
        {
            $<str>$ = strdup($<str>1);
            strcat($<str>$, $<str>2);
            strcat($<str>$, $<str>3);
        }
    |   _NEGATE exp
        {
            $<str>$ = strdup("!");
            strcat($<str>$, $<str>2);
        }
    |   exp 
    ;

return_statement
    :   _RETURN exp _SEMICOLON
        {
            $<str>$ = strdup("return ");
            strcat($<str>$, $<str>2);
        }
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

void strreplace(char *string[],char find[],char replaceWith[])
{
    if(strstr(*string,replaceWith) != NULL){
        char *temporaryString;
        sprintf(temporaryString,"%s",strstr(*string,find) + strlen(find));    //Create a string with what's after the replaced part
        *strstr(*string,replaceWith) = '\0';    //Take away the part to replace and the part after it in the initial string
        strcat(*string,replaceWith);    //Concat the first part of the string with the part to replace with
        strcat(*string,temporaryString);    //Concat the first part of the string with the part after the replaced part
    }
}
