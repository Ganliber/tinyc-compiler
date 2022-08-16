# TinyC Compiler
## About the whole Procedure 
```
tinyC source code
|
| frontend
|
intermediate code: Pcode ---(Pcode emulator)---> running
|
| NASM macro
|
x86 assembly program
|
| NASM assembler
|
binary object file
|
| ld
|
executable program (32bit)
|
| Linux
|
running

```
## About tinyC Grammar
* Look at tinyC_demo.c, the keywords supported by C but not supported by TinyC are defined as empty names so as to ensure that the effect of gcc and TinyC compilers is similar.
* The keywords supported by TinyC are as follows:
    ```C
    void, int, while, if, else, return, break, continue, print, readint
    ```



## About intermediate code : Pcode
### PVM : Pcode Virtual Machine
* including: 
    * code : code area
    * eip : instruction pointer
    * stack : stack area
    * var_table : variables table
    * func_table : functions table
    * label_table : label tables
* implementation:
    * Based on python
    * Any instructions in PVM is executed on stack.

### Pcode
* code comments: begin with ';'
* tag: identifier and ':'
* simulation run :
    * Refer to the script "pysim.py"
* instructions :
    * var : declare a variable, allocate space for it and add its address and name to the var_table.
    * push/pop 
    * data manipulation : 
        * The op in '()' is the operation defined in TinyC, and the outside one is the instruction of Pcode.
        * add(+)/sub(-)/mul(*)/div(/)/mod(%)/cmpeq(==)/cmpgt(>)/cmplt(<)/cmpge(>=)/cmple(<=)/and(&&)/or(||)/not(!)/neg(-)
        * In all binary operations(二元操作), the top element of the original stack is the second operator. For example:
        ```C
        ------------+------------              ------------+------------
            stack   |  bind var                    stack   |  bind var  
        ------------+------------              ------------+------------
            ...     |                 sub          ...     |  
        ------------+------------   ------->   ------------+------------
             5      |                               -7     | <-
        ------------+------------              ------------+------------
             12     | <- 
        ------------+------------              
        ```
        * About neg
        ```C
        ------------+------------              ------------+------------
            stack   |  bind var                    stack   |  bind var  
        ------------+------------              ------------+------------
            ...     |                 neg          ...     |  
        ------------+------------   ------->   ------------+------------
             5      | <-                            -5     | <-
        ------------+------------              ------------+------------
        ```
    * input/output
    * exit
        * exit running the PVM, and set `exit code`
        ```assmebly
        exit 0 ; exit code is 0
        exit a ; exit code is a
        exit ~ ; exit code is the val of the top element of stack
        ```
    * jmp/jz : 
        * PVM will record all the lines beginning with 'xxx:' in its label table
        * For `jmp` : after jmp command is run, stack remains unchanged.
        * For `jz` : the element at the top of the stack will be popped regardless of whether a jump occurs or not.
    * custom function command :
        * FUNC/ENDFUNC/arg/ret/$func_name
        * ret :
            * ret ; return null
            * ret 1 ; return constant
            * ret a ; return variable
            * ret ~ ; pop elem at stack top and return it
        * Acout RetInfo :
            * including : 
                1. return address.
                2. (current) var_table : function has its own var_table, which is temporary.
                3. num of parameters of function.
        * When function returns, empty stack first, push the return value to the top of the stack, and then restore the previous var_table.
    * Difference between Pcode_function_call and stdcall_of_C_language
        * In stdcall, parameters to be pushed into stack is **From Right to Left**
        * In stdcall, return value is saved in EAX, not stack_top.
    
## Compile TinyC by hand
Examples :
> C
```C
[1] 
    a = 1 + 2 * b / sum(5,8);
[2]
    if (a>0) {
        print("a is a positive number");
    }
    else {
        print("a is a negative number");
    }
[3] 
    while (a>0) {
        a = a - 1;
    }
```
> Pcode (assembly)
```Assembly
--- [1] ---
push 1
push 2
push b
mul
push 5
push 8
$sum
div
add
pop a

--- [2] ---
_beg_if:
    ; test expression
    push a
    push 0
    cmpgt
jz _else
    ; statements when test is true
    print "a is a positive number"
jmp _end_if
_else:
    ; statements when test is false
    print "a is a negative number"
_end_if:

--- [3] ---
_beg_while :
    ; test a
    push a
    push 0
    cmpgt
jz _end_while

    ; true, continue
    push a
    push 1
    sub
    pop a
    jmp _beg_while
_end_while:
```     

## Compiler basics
* Basic Process
    * front-end
    ```
    -> front-end begin
    source program
    | lexical analysis
    token stream
    | syntax analysis
    syntax tree
    | semantic analysis
    optimized syntax tree
    | intermediate code generation
    intermediate code
    -> front-end end
    ```
    * back-end
    ```
    -> back-end begin
    intermediate code
    | intermediate code optimization
    optimized intermediate code
    | object code generation
    object code
    | object code optimization
    target program
    -> back-end end
    ```
* Two vital steps when compiling :
    1. Error checking
    2. Code optimization


## Lexical Analysis
* token includes : 
    * constant(int, float, char, string)
    * operation(arithmetic, comparison, logical)
    * separators(commas[,],semicolons[;], parentheses[()],etc.)
    * reserved words
    * identifiers(variable names, function names, class names, etc.)

* token type and value(**字面值**)
```
TOKEN-TYPE              TOKEN-VALUE
-----------------------------------------------
T_IF                    if
T_WHILE                 while
T_ASSIGN                =
T_GREATTHAN             >
T_GREATEQUAL            >=
T_IDENTIFIER            name / numTickets / ...
T_INTEGERCONSTANT       100 / 1 / 12 / ....
T_STRINGCONSTANT        "This is a string" / "hello" / ...
```

### Token Scanning
> word separation scanning
1. Direct Scanning
    * Classification
        * **A type signle char op** : 
        +,-,*,/,%
        * **B type single char op and double char op** :
            * single char : <,>,=,!
            * double char : <=,>=,==,!=
            * notes : if the first char matches B type single char, then check the second char whether they together matches the double char type.
        * **keywords and identifiers** :
            * start with : a `letter` or `underscore(_)`
            * consist of : only `letters`, `underscores` or `numbers`
        * **integer constant** :
            * start with : `number`
            * consist of : `numbers`
        * **string constant** :
            * start and end with : `""`
        * **space (Tab)** :
            * if the first character in this scan is a space, skip it.
        * **comments** :


2. Regular Expression Matching Scanning
    * tokens represented in regular expression
        * integer : [0-9]+
        * float/double : [0-9]+\.[0-9]*
        * string : \"[^\"]*\"
        * identifier : [_a-zA-Z][_a-zA-Z0-9]* 
        * keyword if : if
    * regexp implementation principle : FA
        * FA : Finite Automaton (有限状态自动机)
        * regexp matching : implemented by constructing `FA`

### Lexical Analysis by `flex` : Based on RegExp
> Link : http://flex.sourceforge.net/
* About flex
    
    * %%...%% : rules
        1. overview : Each line is a rule, and each rule consists of matching pattern (`pattern`) and an event (`action`)
        2. pattern : RegExp
        3. action : C code
        4. mechanism : Whenever a pattern is matched, the following C code is executed.
        5. `rules` will be translated into a C function `yylex`
        6. flex requires function `yywrap`, which can pack multiple input files into one input.

    * complete format
    ```
    %{
        Declarations --> 原样复制(C代码)
    %}
    Definitions --> 给一些正则表达式起别名
    %%
    Rules
    %%
    User subroutines --> 原样复制(C代码)
    ```
    * Addition
        * flex provide 2 global variables : `yytext` and `yyleng`
        * `yytext` : string that was just matched 
        * `yyleng` : length of string mentioned in `yytext`

## Syntax Analysis
### context-free grammar
* About basic terms
    * production
        * nonterminal : can appear on either side (both is ok)
        * terminal : can only appear on the right-hand side of a `production`
    * start symbol
* About context-free grammar
    * G : A context-free grammar
        * consists of : T(terminal), N(nonterminal), P(production), S(∈N) (start symbol)
        * G language : the set of all sentences derived from grammar G
    
    * Term Definition : 
        * terminal set **T** : its elem is called `terminal`
        * non-terminal set **N** : its elem is called `non-terminal`
        * symbol : terminal or non-terminal
        * alphabet **V** : T∪N , its elem is called `symbol`
        * a string of symbols : 
            * sentence : a string of symbols with `only` terminal.
            * empty string : ε
        * production : A -> u, A is non-terminal and u is a string of symbols.
        * production set **P** : a set with limited productions.
        * expand : (A->u) vAw --> vuw
        * reduce : (A->u) vuw --> vAw
        * start symbol : a specific elem in **N**
        * derivate : 推导, u => v
        * context-free grammar **CFG** : (T, N, P, S)
        * parse : Given sentence **s** and grammar **G**, determine whether s belongs to G. If so, find out the whole process of deriving s from the **start symbol**.Any string of symbols in the derivation process (including start symbols and final sentences) is called a **working string**(中间句子)

    * Ambiguity : introducing priority can solve this problem.
    
    * Concept comparison : the main difference lies in `production`.
        * context-sensitive grammar : vAw -> vuw
        * context-free grammar : A -> u 

    * Analysis Methodology
        * TOP-DOWN
            * LL(1) : 
                1. push $(EOF) and start symbol S into stack
                2. read next token from `token steam` and assign it to **a**, that is, execute instruction `a = yylex()` for one time.
                3. the top-elem of stack is **X**, so:
                    * Situation A : X==a && a==$, parsing succeeds, END;
                    * Situation B : X==a && a!=$, Match, pop **X**, turn to `2.`
                    * Situation C : X!=a && X belongs to **N** : X -> u1|u2|...|un
                        * Situation C1 : Only ui matches a, Predict X->ui, pop X, push ui
                        * Situation C2 : No such ui, END
                        * Situation C3 : More than one ui exist: not fit for LL(1), need to modify grammar.
            * **First Set** and **Follow Set**
                * `first set` : u => v, v is the **first** sentence, then **the first terminal** belongs to `First(u)`; if v is a null, then ε belongs to First(u) as well.
                    * S -> u1|u2|...|un, First(ui)之间相交, 即First(ui)∩First(uj)=NULL(i≠j)
                    * S -> aS|bS|c, First(aS) = {a}, First(bS) = {b}, First(c) =  {c}
                    * 含左递归(left recursive)的语法无法使用LL(1)解析
                * `follow set` : Follow(A) : terminal behind A(including $ but not ε), if S => uAaw, then a belongs to `Follow(A)`
                    * When top-elem of stack is X, reading elem is a, a doesn't belong to any First(ui) and X => ε, then a must belong to Follow(A) when it is a legal sentence.

        * BOTTOM-UP

    




## Reference
* tinyc compiler tutorial : https://pandolia.net/tinyc/index.html