%{
	#include "y.tab.h"
	int depth = 0;
%}

%option yylineno

letter                      [_a-zA-Z]
char                        [\x00-\x21\x23-\x7F]
digit                       [0-9]
type                        int|double|float|void
char_type                   char
lf                          \r?\n

%%

[ \t]+                      {   /* skip */    }

{type}                      {   yylval.str = strdup(yytext); return _TYPE;     }
{char_type}                 {   yylval.str = strdup(yytext); return _TYPE;     }
{char_type}\s*\*            {   yylval.str = strdup(yytext); return _TYPE;     }
"if"                        {   yylval.str = strdup(yytext); return _IF;       }
"else"                      {   yylval.str = strdup(yytext); return _ELSE;     }
"else if"                   {   yylval.str = strdup(yytext); return _ELIF;     }
"return"                    {   yylval.str = strdup(yytext); return _RETURN;   }
"switch"                    {   yylval.str = strdup(yytext); return _SWITCH;   }
"case"                      {   yylval.str = strdup(yytext); return _CASE;     }
"default"                   {   yylval.str = strdup(yytext); return _DEFAULT;  }
"break"                     {   yylval.str = strdup(yytext); return _BREAK;    }
"for"                       {   yylval.str = strdup(yytext); return _FOR;      }
"while"                     {   yylval.str = strdup(yytext); return _WHILE;    }
"do"                        {   yylval.str = strdup(yytext); return _DO;       }

"printf"                    {   yylval.str = strdup(yytext); return _PRINTF;   }
"scanf"                     {   yylval.str = strdup(yytext); return _SCANF;    }

{letter}({letter}|{digit})* {  yylval.str = strdup(yytext); return _ID;       }

{digit}{1,5}[uU]            {  yylval.str = strdup(yytext); return _UNSIGNED_NUMBER;   }
[+-]?{digit}+               {  yylval.str = strdup(yytext); return _INT_NUMBER;        }
[+-]?{digit}+\.{digit}+     {  yylval.str = strdup(yytext); return _REAL_NUMBER;       }

'{char}'                    {  yylval.str = strdup(yytext); return _CHAR;       }
\"{char}*\"                 {  yylval.str = strdup(yytext); return _STRING;       }

"("                         {   yylval.str = strdup(yytext); return _LPAREN;     }
")"                         {   yylval.str = strdup(yytext); return _RPAREN;     }
","                         {   yylval.str = strdup(yytext); return _COMMA;      }
"{"                         {   yylval.str = strdup(yytext); return _LBRACKET;   }
"}"                         {   yylval.str = strdup(yytext); return _RBRACKET;   }
"="                         {   yylval.str = strdup(yytext); return _ASSIGN;     }
";"                         {   yylval.str = strdup(yytext); return _SEMICOLON;  }
"+"                         {   yylval.str = strdup(yytext); return _PLUS;       }
"++"                        {   yylval.str = strdup(yytext); return _INC;        }
"--"                        {   yylval.str = strdup(yytext); return _DEC;        }
"-"                         {   yylval.str = strdup(yytext); return _MINUS;      }
"*"                         {   yylval.str = strdup(yytext); return _TIMES;      }
"/"                         {   yylval.str = strdup(yytext); return _DIV;        }
"<"                         {  yylval.str = strdup(yytext); return _RELOP;      }
">"                         {  yylval.str = strdup(yytext); return _RELOP;      }
"<="                        {  yylval.str = strdup(yytext); return _RELOP;      }
">="                        {  yylval.str = strdup(yytext); return _RELOP;      }
"=="                        {  yylval.str = strdup(yytext); return _RELOP;      }
"!="                        {  yylval.str = strdup(yytext); return _RELOP;      }
"!"                         {   yylval.str = strdup(yytext); return _NEGATE;     }
":"                         {   yylval.str = strdup(yytext); return _COLON;      }
"["                         {   yylval.str = strdup(yytext); return _LSBRACKET;      }
"]"                         {   yylval.str = strdup(yytext); return _RSBRACKET;      }
{lf}                        {                       }

%%

int yywrap() {
    return 1;
}
