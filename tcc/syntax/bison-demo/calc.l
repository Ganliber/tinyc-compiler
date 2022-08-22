%{
#include "y.tab.h"
%}

%%
[0-9]+          { yylval = atoi(yytext); return T_NUM; }
[+\-+*()\n]     { return yytext[0]; } //注意减号前要加上转义字符
.               { return 0; /* End when everything else */ }
%%

int yywrap(void) {
    return 1;
}