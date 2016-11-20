%{
	#include "y.tab.h"
	int depth = 0;
%}

%option yylineno

letter                      [_a-zA-Z]
char                        [\x00-\x21\x23-\x7F]
digit                       [0-9]
type                        int|double|float
char_type                   char
lf                          \r?\n

%%

[ \t]+                      {   /* skip */    }

{type}                      {   return _TYPE;     }
{char_type}                 {   return _TYPE;     }
{char_type}\s*\*            {   return _TYPE;     }
"if"                        {   return _IF;       }
"else"                      {   return _ELSE;     }
"else if"                   {   return _ELIF;     }
"return"                    {   return _RETURN;   }
"switch"                    {   return _SWITCH;   }
"case"                      {   return _CASE;     }
"default"                   {   return _DEFAULT;  }
"break"                     {   return _BREAK;    }
"for"                       {   return _FOR;      }
"while"                     {   return _WHILE;    }
"do"                        {   return _DO;       }

"printf"                    {   return _PRINTF;      }
{letter}({letter}|{digit})* {  yylval.str = strdup(yytext); return _ID;       }

{digit}{1,5}[uU]            {  yylval.str = strdup(yytext); return _UNSIGNED_NUMBER;   }
[+-]?{digit}+               {  yylval.str = strdup(yytext); return _INT_NUMBER;        }
[+-]?{digit}+\.{digit}+     {  yylval.str = strdup(yytext); return _REAL_NUMBER;       }

'{char}'                    {  yylval.str = strdup(yytext); return _CHAR;       }
\"{char}*\"                 {  yylval.str = strdup(yytext); return _STRING;       }

"("                         {   return _LPAREN;     }
")"                         {   return _RPAREN;     }
","                         {   return _COMMA;      }
"{"                         {   depth++; return _LBRACKET;   }
"}"                         {   return _RBRACKET;   }
"="                         {   return _ASSIGN;     }
";"                         {   return _SEMICOLON;  }
"+"                         {   return _PLUS;       }
"++"                        {   return _INC;        }
"--"                        {   return _DEC;        }
"-"                         {   return _MINUS;      }
"*"                         {   return _TIMES;      }
"/"                         {   return _DIV;        }
"<"                         {  yylval.str = strdup(yytext); return _RELOP;      }
">"                         {  yylval.str = strdup(yytext); return _RELOP;      }
"<="                        {  yylval.str = strdup(yytext); return _RELOP;      }
">="                        {  yylval.str = strdup(yytext); return _RELOP;      }
"=="                        {  yylval.str = strdup(yytext); return _RELOP;      }
"!="                        {  yylval.str = strdup(yytext); return _RELOP;      }
"!"                         {   return _NEGATE;     }
":"                         {   return _COLON;      }
"["                         {   return _LSBRACKET;      }
"]"                         {   return _RSBRACKET;      }
"scanf"                     {   return _SCANF;      }
{lf}                        {                       }

%%

int yywrap() {
    return 1;
}
