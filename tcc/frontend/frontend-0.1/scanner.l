%{
#define YYSTYPE char *
#define _DUPTEXT { yylval = strdup(yytext); }
#include "y.tab.h"
int cur_line = 1;
void yyerror(const char * msg);
void unrecognized_char(char c);
%}

/* note \042 is '"' */

OPERATOR        ([-/+*()=,;])
INTEGER         ([0-9]+)
STRING          (\042[^\042\n]*\042)
IDENTIFIER      ([_a-zA-Z][_a-zA-Z0-9]*)
WHITESPACE      ([ \t]*)

%%

{OPERATOR}      { return yytext[0];                     }
"int"           { return T_Int; }
"print"         { return T_Print; }

{IDENTIFIER}    { _DUPTEXT; return T_Identifier;        }
{INTEGER}       { _DUPTEXT; return T_IntConstant;       }
{STRING}        { _DUPTEXT; return T_StringConstant;    }

{WHITESPACE}    { /* ignore every whitespace. */        }
\n              { cur_line++;                           }
.               { unrecognized_char(yytext[0]);         }
%%

int yywrap(void) {
    return 1;
}

void unrecognized_char(char c) {
    char buf[32] = "Unrecognized character: ?";
    buf[24] = c;
    yyerror(buf);
}

void yyerror(const char *msg) {
    printf("Error at line %d:\n\t%s\n", cur_line, msg);
    exit(-1);
}