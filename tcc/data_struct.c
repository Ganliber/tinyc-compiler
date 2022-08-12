typedef enum {
    // if, else, while, +, -, *, /, %, 
    T_IF, T_ELSE, T_WHILE, T_ADD, T_SUB, T_MUL, T_DIV, T_MOD,
    // =, ==, !=, 
    T_ASSIGN, T_EQUAL, T_NOTEQUAL, 
    // >, >=, <, <=,
    T_GREATTHAN, T_GREATEQUAL, T_LESSTHAN, T_LESSEQUAL,
    // &&, ||, !, -(~)
    T_AND, T_OR, T_NOT, T_NEG,
    // identifier, const int, const string, 
    T_IDENTIFIER, T_INTEGERCONSTANT, T_STRINGCONSTANT
} TokenType;

typedef struct _Token
{
    TokenType type;
    union 
    {
        char *stringval;
        int *intval;
        double *doubleval;
    }value;
}TokenRecord;

