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
​​
### Top-down analysis 
* Demo : first set and follow set
    ```
    Grammar : 
        S -> AB
        A -> Ca | ε
        B -> cB'
        B'-> aACB' | ε
        C -> b | ε
    Calc Result:
        first(C) = {b, ε}
        first(B')= {a, ε}
        first(B) = {c}
        first(A) = first(C) - ε  + a (*because First(C) contains ε) + ε 
                 = {b, a, ε}
        first(S) = (first(A) - ε) + (first(B) - ε)(*because First(A) contains ε) 
                 = {b, a} + {c} 
                 = {a, b, c}
        follow(S) = {$}
        follow(B) = {$}
        follow(B')= {$}
        follow(A) = (first(C) - ε) + (first(B') - ε) + (first(B) - ε) + $  
                  = {b, a, c, $}
        follow(C) = follow(B') - ε + $ = {a, $}
    ```
  
* first(u) : for a string of symbols u = X1 X2 ... Xn, the calculation steps are as follows:
    1. set i = 1
    2. if i == n + 1, add ε to First(u), END
    3. if Xi is terminal, add Xi to First(u), END
    4. if Xi is non-terminal, add `First(Xi) - ε` to First(u) --> recursion
         * if First(Xi) `doesn't contain` ε, END
         * if First(Xi) `contains` ε, set i = i + 1, turn to `2.`
​
* follow(u) : all non-terminals in a grammar, contributing to `follow set`
    > the key of this algorithm lies in `top-down` sequence.
    1. add `$` to `follow(S)`, S is start symbol, and $ is EOF symbol.
    2. for every production like `A -> uBv`, add `First(v)-ε` to `Follow(B)`.
    3. **for every production like `A -> uB`, or `A -> uBv, First(v) contains ε`, add Follow(A) to Follow(B).**
    ```python
    About calculating follow(u):
    (1) $
    (2) A->uBv, Follow(B) += First(v) - ε
        (2.1) if v contains ε,  Follow(B) += Follow(v) 
    (3) A->uB, Follow(B) += Follow(A)

    A -> uB(v), 只能计算->右侧的(B):
    若B在末尾, Follow(B)+=Follow(A); 
    若B不在末尾,看紧跟其后的是否含ε:
        if so: Follow(B)+=Follow(A)+First(v)-ε;
        else : Follow(B)+=First(v)-ε; 
    ```
​
#### LL(1) Action Table and LL(1) Analysis
* M : Action Table (could be seen as a 2-dim array or a dict)
* M[A, a]: `Action` that should be taken when stack-top-elem is non-terminal `A` and read-symbol is `a`. 
* Constructing M : A -> u
    > if you encounter a conflict during the process of building the action table M, it means that the LL(1) algorithm is not applicable at this time.
    1. For all terminals in First(u) (excluding ε), set `M[A, ε] = "A -> u"`;
    2. If First(u) contains ε, for all symbols a in follow(A) (including $), set `M[A, a] = "A -> u"`

* Parsing steps:
    1. Push `$` and starting symbol `S` into stack;
    2. Read the next terminal from inputing stream, assign it to `a`, that is, execute `a = yylex()`
    3. Assuming that the stack-top-symbol is `X`, there are 3 cases:
        * X == a && a == $, parsing succeeds! END
        * X == a && a != $, Match, pop X, turn to 2.
        * X != a && X is terminal, Two cases as follows:
            * M[X,a]="X->u", Predict, pop X, push u, turn to 3.
            * M[X,a] not defined, not syntactic, parsing terminates.
        * X != a && X is terminal, not syntactic, parsing terminates.
​
### bottom-up analysis 

#### LR Algorithm
* Demo for LR methodology
    ```C
    Grammar : 
        S -> E
        E -> T
        E -> E + T
        T -> id
        T -> (E)
    Sentence to be parsed :
        (id + id)
    Parsing by hand : 
    1 (id+id) "T->id"
    2 (T +id) "E->id"
    3 (T + E) "E->E+T"
    4 (E)     "S->E"
    5 (S)     ACCEPT  
    ```
* some terms
    * viable string
    * prefix, sufix
    * viable prefix
    * reduceable

* Construct LR(0) Analyzer
    * some demo for terms : 
    * `Configuration (C)` : the degree of resolution of a production, represented by a production plus a positional black dot
        * `"A->ε·"`( **recommended** ) ≈ `"A->·ε"`
        * `start configuration of a production`
            * For example, `A->·abc`
        * `complete configuration of a production (reduceable configuration)`
            * For example, `A->abc·`
        * `successor configuration`
            * For example, `NEXT(C,Y)==C', C=[A->X·YZ], C'=[A->XY·Z], C--(Y)->C'`
        * `extended configuration`
            * For example, `A->v·Yw, Y is a non-terminal, Y->u, we call "Y->·u" is the extended configuration of "A->v·Yw"`
            * Pay attention, `extended configuration` is a **one-way extension**
        * `configurating set`
        * `closure of a configurating set` : 集合I闭包集合,记作CLOSURE(I)
            * Add all extended configurations in set `I` to set `CLOSURE(I)`.
    * `State (I)` : configuration set that has been closed.(进行过闭合操作的C)
        * If C belongs to I, then CLOSURE(C) belongs to I.
        * `start state of a CFG(Context-Free Grammar)`
            ```C
            Start symbol : S
            All productions : S -> u1|u2|...|un
                /* S is not on the right-hand side of any production */
            I0 : start state of S
                I0 = CLOSURE({[S->·u1], [S->·u2], ..., [S->·un]})
            Demo :
                S->A
                A->aBd
                B->bc
                => I0 = CLOSURE({[S->·A]}) = {[S->·A], [A->·aBd]}
            ```
        * successor state : 
            ```C
            Procedure :
                state I ---X--> state I' ; I' is NEXT(I,X), that is successor state
                NEXT(I,X)=CLOSURE({NEXT(C, X)|C∈I})
            State Transition Diagram :
                Grammar :
                    S->A
                    A->aBd
                    B->bc
                Transition :
                I0=S->.A|A->.aBd
                + NEXT(I0,A) : I1=S->A.             --> ending 1
                + NEXT(I0,a) : I2=A->a.Bd|B->.bc
                ++  NEXT(I2,B) : I3=A->aB.d
                +++     NEXT(I3,d) : I5=aBd.        --> ending 2
                ++  NEXT(I2,b) : I4=B->b.c
                +++     NEXT(I4,c) : I6=bc.         --> ending 3
            ```
        * reduceable state :
            > if a state only has one configuration, such as `I1, I5, I6` mentioned above, we call it `reduceable state`.
            * Action M : M[I,X] is the action to be taken when state is I, next symbol is X.
            ```C
            * non-terminal 
                * shift : ->
                * reduce : <-
            * terminal 
                * goto : <-
            ```



* Construct LR(1) Analyzer
    * LR(0): needs in the grammar `multiple reduceable configuration` are not allowed in the grammar.
        * `reduce/reduce` conflict : one state has `more than one` reduceable configuration
        * `shift/reduce` conflict : one state has `both` reduceable configuration and non-reduceable configuration.
        ```C
        One state has multiple reduceable configurations :
        (1) reduce/reduce conflict
            I = { "A->u." ; "B->w."}
        if Follow(A) ∩ Follow(B) == NULL :
            for an input 'a': 
            1. 'a' belongs to Follow(A), reduce "A->u"
            2. 'a' belongs to Follow(B), reduce "B->w"
        
        (2) shift/reduce conflict
            I = { "A->u." ; "B->v.w"}
        if Follow(A) ∩ First(w) == NULL :
            for an input 'a':
            1. 'a' belongs to Follow(A), reduce "A->u"
            2. 'a' belongs to First(w), shift "B->v.w"
        ```
    * LR(1) configuration:
        ```C
        A -> X1 ... Xi · Xi+1 ... Xn, a
        + Only when the input terminal is 'a' after Xn the **reduce** action is executed.
        + The number '1' in 'LR(1)' means **one** lookahead is required.
            * Current symbols on the stack : X1...Xi
            * Expected symbols : Xi+1 ... Xn
            * Lookahead : a
        ```
    * LR(1) successor configuration
        ```C
        if 
            C = [ A -> X.YZ, a]
        then 
            C`= [ A -> XY.Z, a]
        + C` is the successor configuration of C, denoted as NEXT(C,Y).
        + C ---Y--> C`.
        ```
    * LR(1) extended configuration
        ```C
        if 
            C = [A -> u.Bv, a] && B->w, b∈First(va)
        then 
            C`= [B -> .w, b]
        + C` is the extended configuration of C.
        + Add the influence of context. 
        ```
    * LR(1) closure of a configuration set :
        ```C
        for every configuration like '[A->u.Bv, a]' in I, that is, '.' + 'non-terminal':
            for every production in B like '[B->w]' and every symbol 'b' in First(va):
                Add configuration '[B -> .w, b]' to I'.
        I' = CLOSURE(I)
        ```
    * LR(1) start state of a CFG :
        ```C
        S -> u1 | u2 | ... | un
        I0 = CLOSURE({[S->.u1,$], [S->.u2,$], ... , [S->.un,$]})
        ```
    * LR(1) successor state :
        ```C
        NEXT(I, X) = CLOSURE( { NEXT(C, X) | C ∈ I} )
            + NEXT(I,X) can be ε.
        ```
    * LR(1) problems :
        * reduce/reduce conflict (`unusual`) :
            ```C
            Ii:
                [A->u., a] and [B->v., a]
            Problem:
                How to determine M[I, a] ?
                Both are `reduce` action.
            ```
        * reduce/shift conflict (can be solved by setting `priority`) :
            ```C
            Ii:
                [A->u.aw, c] and [B->v., a]
            Problem:
                How to determine M[I, a] ?
                [A->ua.w,c] --> shift
                [B->v.,a] --> reduce
            ```
    * Priority : 
        ```C
        Ii:
            [A->u.aw, c] --> shift
            [B->v., a]   --> reduce
        conditions:
            + The priority of 'a' is defined, and there is at least one symbol with a `defined priority` in the string 'v'.
            + The rightmost symbol in 'v' with a defined priority ( closest to 'a' in 'v' ) is denoted as 'b'.
        principles:
            1. Priority(a) < Priority(b) : M[I,a] = reduce B->v;
            2. Priority(a) > Priority(b) : M[I,a] = shift NEXT(I,a);
            3. P(a)==P(b) : 
                3.1 Both a and b are left-associative : M[I,a] = shift NEXT(I,a);
                3.2 Both a and b are right-associative : reduce B->v;
        ```

#### Optimized LR(1) Analysis : `LALR(1)`
* `LALR(1)` method `merges similar states` compared to `LR(1)` method.
    * save the `space` of the action table.
    * save the `time` by improving parsing speed.

### Syntax analysis tool : bison
* Bison grammar
    > Overview
    ```C
    %{
    Declarations
    %}
    Definitions
    %%
    Productions
    %%
    User subroutines
    ```
    > About `Definition`
    ```C
    You can define priority of different symbols in section 'Definition'.
    %left '+' '-'
    %left '*' '/' 
      |
    左结合,优先级下>上
    ```
    > About `Production`
    ```C
    Format :
        S -> S E \n | ε
        E -> E + E | E - E | E * E | E / E | T_NUM | (E)
    Expansion :
        ->                         --- :
        Ending of one production   --- ;
        Terminal                   --- 'terminal'
        Non-terminal               --- non-terminal
        other types of token       --- defined in section 'Definition'
    ```
* Intermediate Files
    * y.tab.c : LALR(1) Action Table
    * y.output : Virtualized Action Table and according elements of grammar. ( state transition diagram )

* Analysis :
    * `token stream` --> Grammatical 
        * --> no error during parsing
        * --> yyparse() return `0`
    * `token stream` --> Not grammatical
        * --> error during parsing
        * --> yyparse() `terminate` at the first error
        * --> call `yyerror()`, `yyerror()` return `1`

* About `yyparse()` :
    * reduce : `$1`, $2, $3, ... , --> refer to configurations in `Configuration Stack`
    * `$$` : `terminal` on the `left-hand` side of the production

## Reference
* tinyc compiler tutorial : https://pandolia.net/tinyc/index.html