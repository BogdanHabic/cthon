%{
	#include "y.tab.h"
	extern YYSTYPE yylval;
%}

%%

[ \t\r]+                

[0-9]+        { yylval = atoi(yytext); return NUMBER; }
"+"           { return PLUS; }
"-"           { return MINUS; }
"*"           { return MULTIPLY; }
"/"           { return DIVIDE; }
\n            { return NEWLINE; }
.             { return yytext[0]; } /* da ne bi bilo 1+#2 = 3 */

%%

int yywrap() {
    return 1;
}
