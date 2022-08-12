%{
#include "token.h"
int cur_line_num = 1;
void init_scanner();
void lex_error(char* msg, int line);
%}

/* Definitions, notes : \042 is '"' */
/* In RegExp, "//" means it matching the original content of string '//'. */
/* unterm_string means that this is a uncomplete string */
/* '-' in {operator} should be presented with '\' ('-'需要转义字符)  */
INTEGER             ([0-9]+)
UNTERM_STRING       (\042[^\042\n]*)
STRING              (\042[^\042\N]*\042)
IDENTIFIER          ([_a-zA-Z][_a-zA-Z0-9]*)
OPERATOR            ([+\-*/%=,;!<>(){}])
SINGLE_COMMENT1     ("//"[^\n]*) 
SINGLE_COMMENT2     ("#"[^\n]*)

/* Rules */
%%

[\n]                { cur_line_num++; }
[ \t\r\a]+          { /* ignore all spaces */ } /* \a 响铃 \t 水平制表符 \r 回车 */
{SINGLE_COMMENT1}   { /* skip for single line comment */ }
{SINGLE_COMMENT2}   { /* skip for single line comment */ }

{OPERATOR}          { return yytext[0];         }

"<="                { return T_Le;              }
">="                { return T_Ge;              }
"=="                { return T_Eq;              }
"!="                { return T_Ne;              }
"&&"                { return T_And;             }
"||"                { return T_Or;              }
"void"              { return T_Void;            }
"int"               { return T_Int;             }
"while"             { return T_While;           }
"if"                { return T_If;              }
"else"              { return T_Else;            }
"return"            { return T_Return;          }
"break"             { return T_Break;           }
"continue"          { return T_Continue;        }
"print"             { return T_Print;           }
"readint"           { return T_ReadInt;         }

{INTEGER}           { return T_IntConstant;     }
{STRING}            { return T_StringConstant;  }
{IDENTIFIER}        { return T_Identifier;      }

<<EOF>>             { return 0; }

{UNTERM_STRING}     { lex_error("Unterminated string constant", cur_line_num); }
.                   { lex_error("Unrecognized character", cur_line_num);       }

%%

/* User subroutine */
int main(int argc, char* argv[]) {
    int token;
    init_scanner();
    while (token = yylex()) {
        print_token(token);
        puts(yytext);
    }
}

int yywrap(void) {
    return 1;
}

void init_scanner() {
    printf("%-20s%s\n", "TOKEN-TYPE", "TOKEN-VALUE");
    printf("-------------------------------------------------\n");
}

void lex_error(char* msg, int line) {
    printf("\nError at line %-3d: %s\n\n", line, msg);
}