%{
#include "y.tab.h"
%}

%%
[0-9]+          { yylval = atoi(yytext); return T_NUM; }
[+\-+*()\n]     { return yytext[0]; }
.               { return 0; /* End when everything else */ }
%%

int yywrap(void) {
    return 1;
}