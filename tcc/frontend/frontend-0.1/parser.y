%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char * msg);
#define YYSTYPE char *
%}

%token T_StringConstant T_IntConstant T_Identifier T_Int T_Print

%left '+' '-'
%left '*' '/'
%right U_neg

%%

S:   
    Stmt                { /* empty */ }
|   S Stmt              { /* empty */ }
;

Stmt:
    VarDecl  ';'        { printf("\n\n"); }
|   Assign              { /* empty */ }
|   Print               { /* empty */ }    
;

/* variable, such as 'int a'(1) or 'int a,b'(2), target is identifier */
VarDecl:
    T_Int T_Identifier          { printf("var %s", $2); }
|   VarDecl ',' T_Identifier    { printf(", %s", $3); }
;

/* =, such as 'a=2;', target is identifier */
Assign:
    T_Identifier '=' E ';'      { printf("pop %s\n\n", $1); }
;

Print:
    T_Print '(' T_StringConstant Actuals ')' ';' { printf("print %s\n\n", $3); }
;

Actuals:
    /* empty */                 { /* empty */ }
|   Actuals ',' E               { /* empty */ }
;

E:
    E '+' E                     { printf("add\n");          }
|   E '-' E                     { printf("sub\n");          }
|   E '*' E                     { printf("mul\n");          }
|   E '/' E                     { printf("div\n");          }
|   '-' E %prec U_neg           { printf("neg\n");          }
|   T_Identifier                { printf("push %s\n", $1);  }
|   T_IntConstant               { printf("push %s\n", $1);  }
|   '(' E ')'                   { /* empty */ }
;

%%

int main() {
    return yyparse();
}