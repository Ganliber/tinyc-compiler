%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char * msg);
#define YYSTYPE char *


int ii = 0, istop
%}

%token T_Int T_Void T_Return T_Print
%token T_IntConstant T_StringConstant T_Identifier

%left '+' '-'
%left '*' '/'
%right U_neg

%%

Program:
    /* empty */                     { /* empty */ }
|   Program FuncDecl                { /* empty */ }
;

FuncDecl:
    RetType FuncName '(' Args ')' '{' VarDecls Stmts '}'
                                    { printf("ENDFUNC\n\n"); }
;

RetType:
    T_Int                           { /* empty */ }
|   T_Void                          { /* empty */ }
;

FuncName:
    T_Identifier                    { printf("FUNC @%s:\n", $1); }
;

Args:
    /* empty */                     { /* empty */ }
|   _Args                           { printf("\n\n"); }
;

_Args:
    T_Int T_Identifier              { printf("arg %s", $2); }
|   _Args ',' T_Int T_Identifier    { printf(", %s", $4); }
;

VarDecls:
    /* empty */                     { /* empty */ }
|   VarDecls VarDecl ';'            { printf("\n\n"); }
;

VarDecl:
    T_Int T_Identifier              { printf("var %s",$2); }
|   VarDecl ',' T_Identifier        { printf(", %s", $3); }
;

Stmts:
    /* empty */                     { /* empty */ }
|   Stmts Stmt                      { /* empty */ }
; 

Stmt:
    AssignStmt                      { /* empty */ }
|   PrintStmt                       { /* empty */ }
|   CallStmt                        { /* empty */ }
|   ReturnStmt                      { /* empty */ }
|   IfStmt                          { /* empty */ }
|   WhileStmt                       { /* empty */ }
|   BreakStmt                       { /* empty */ }
|   ContinueStmt                    { /* empty */ }
;

AssignStmt:
    T_Identifier '=' Expr ';'       { printf("pop %s\n\n", $1);}
;

Expr:
    Expr '+' Expr                   { printf("\tadd\n"); }
|   Expr '-' Expr                   { printf("\tsub\n"); }
|   Expr '*' Expr                   { printf("\tmul\n"); }
|   Expr '/' Expr                   { printf("\tdiv\n"); }
|   '-' Expr %prec U_neg            { printf("\tneg\n"); }
|   '!' Expr                        { printf("\tnot\n"); }
|   Expr '%' Expr                   { printf("\tmod\n"); }
|   Expr '>' Expr                   { printf("\tcmpgt\n"); }
|   Expr '<' Expr                   { printf("\tcmplt\n"); }
|   Expr T_Ge Expr                  { printf("\tcmpge\n"); }
|   Expr T_Le Expr                  { printf("\tcmple\n"); }
|   Expr T_Eq Expr                  { printf("\tcmpeq\n"); }
|   Expr T_Ne Expr                  { printf("\tcmpne\n"); }
|   Expr T_Or Expr                  { printf("\tor\n"); }
|   Expr T_And Expr                  { printf("\tand\n"); }
|   T_IntConstant                   { printf("push %s\n", $1); }
|   T_Identifier                    { printf("push %s\n", $1); }
|   ReadInt                         { /* empty */ }
|   CallExpr                        { /* empty */ }
|   '(' Expr ')'                    { /* empty */ }
;

ReadInt:
    T_ReadInt '(' T_StringConstant ')'
                                    { printf("\treadint %s\n", $3); }
;

PrintStmt:
    T_Print '(' T_StringConstant PActuals ')' ';'
                                    { printf("print %s\n\n", $3); }
;

PActuals:
    /* empty */                     { /* empty */ }
|   PActuals ',' Expr               { /* empty */ }
;

CallStmt:
    CallExpr ';'                    { printf("pop\n\n"); }
;

CallExpr:
    T_Identifier '(' Actuals ')'    { printf("$%s\n", $1); }
;

Actuals:
    /* empty */                     { /* empty */ }
|   Expr PActuals                   { /* empty */ }
;

ReturnStmt:
    T_Return Expr ';'               { printf("ret ~\n\n"); }
|   T_Return ';'                    { printf("ret\n\n"); }
;

%%


int main() {
    return yyparse();
}