/* Skener za mikroC */

%{
    #include <string.h>
    #include "y.tab.h"

    int line = 1;
%}

letter                      [_a-zA-Z]
digit                       [0-9]

%%

[ \t]+                      {   /* skip */    }

"int"                       {   return _TYPE;     }
"unsigned"                  {   return _TYPE;     }
"if"                        {   return _IF;       }
"else"                      {   return _ELSE;     }
"return"                    {   return _RETURN;   }

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


"/*"                        {
                                int in_comment = 1;
                                char c;
                                while(in_comment) {
                                    c = input(); 
                                    if(c == '*') {
                                        char ch = input();
                                        if(ch == '/') in_comment = 0;
                                        else unput(ch);
                                    }
                                    else if(c == '\n') line++;
                                    else if(c == EOF) {
                                        printf("\nERROR (%d): Unterminated comment", line);
                                        in_comment = 0;
                                    }
                                }
                            }

\/\/.*                      {   /* skip */   }

"\n"                        {   line++;    }
.                           {   printf("\nLEXICAL ERROR on character %c (line %d)", yytext[0], line);   }

%%

int yywrap() {
    return 1;
}
