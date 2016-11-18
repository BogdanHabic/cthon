%{
	#include "y.tab.h"
	extern YYSTYPE yylval;
%}

letter                      [_a-zA-Z]
digit                       [0-9]
type                        int|double|char|float

%%

[ \t]+                      {   /* skip */    }

{type}                      {   return _TYPE;     }
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

{letter}({letter}|{digit})* {   return _ID;       }

{digit}{1,5}[uU]            {   return _UNSIGNED_NUMBER;   }
[+-]?{digit}{1,5}           {   return _INT_NUMBER;        }

"("                         {   return _LPAREN;     }
")"                         {   return _RPAREN;     }
","                         {   return _COMMA;      }
"{"                         {   return _LBRACKET;   }
"}"                         {   return _RBRACKET;   }
"="                         {   return _ASSIGN;     }
";"                         {   return _SEMICOLON;  }
"+"                         {   return _PLUS;       }
"-"                         {   return _MINUS;      }
"*"                         {   return _TIMES;      }
"/"                         {   return _DIV;        }
"<"                         {   return _RELOP;      }
">"                         {   return _RELOP;      }
"<="                        {   return _RELOP;      }
">="                        {   return _RELOP;      }
"=="                        {   return _RELOP;      }
"!="                        {   return _RELOP;      }
\n                          {   return _LF;         }

%%

int yywrap() {
    return 1;
}
