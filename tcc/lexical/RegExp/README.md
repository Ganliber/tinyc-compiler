## About hide-digits
* hide-digits.l : 分词模式文件
* flex will translate the RegExp Module (in file `*.l`) into function `yylex` in C code format and output to the lex.yy.c file 
```
%%
[0-9]+  printf("?"); --> 遇见(连续)的数字替换成一个?输出
#       return 0; --> 遇见#直接退出
.       ECHO; --> 遇见别的字符原样输出, ECHO是flex提供的一个宏macro
%%
```


## About word-spliter
* 原始的分词器

