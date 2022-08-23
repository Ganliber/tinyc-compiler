%{
#include <stdio.h>
void yyerror(const char * msg) {}
%}

%token T_NUM

%left '+' '-'
%left '*' '/'

%%

S   :   S E '\n'        { printf("ans = %d\n", $2); }
    |   /* empty */     { /* empty */ }
    ;

E   :   E '+' E         { $$ = $1 + $3; }
    |   E '-' E         { $$ = $1 - $3; }
    |   E '*' E         { $$ = $1 * $3; }
    |   E '/' E         { $$ = $1 / $3; }
    |   T_NUM           { $$ = $1; /*用于将读取的int值绑定到 E上,且类型为T_NUM*/ }
    |   '(' E ')'       { $$ = $2;      }
    ;
%%

int main() {
    return yyparse();
}