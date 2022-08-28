* Install NASM in Linux
```bash
sudo apt-get install nasm
```
* run file like `*.nasm`
```bash
nasm -f elf32 -o hello.o hello.nasm
ld -m elf_i386 -o hello hello.o
./hello
```
