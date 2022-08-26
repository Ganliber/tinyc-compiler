## About Backend Procedure
```
source code `.c`
|
| frontend : tcc
|
Intermediate code `.asm` ( Pcode )

=========> Backend <=========

|
| NASM micro : translate Pcode
|
x86 assembly instructions
|
| Nasm
|
binary target program
|
| ld
|
ELF ( 32-bit executable file in Linux )
```