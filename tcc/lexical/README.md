# Lexical Analysis

## Direct Scanning Method : 
> Refer to `scan.py`, which is a demo for directly scanning lexical analysis.

## RegExp Method : 
> Originally you had better constuct a FA based on RegExp, but it is complex and tough. So you can use the tools made by predecessors.

### flex :
>  一个快速词法分析生成器，可以将用户用RegExp写的分词匹配模式构造成一个有限状态自动机（一个C函数）
### download : 
```
sudo apt-get install flex
```
###  usage : 
```
flex *.l
```
will get the file `lex.yy.c`
