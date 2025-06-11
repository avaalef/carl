# Carl

"Carl" is a simple "kernel" made in the Assembly programming language.

<img src="https://c.feridinha.com/xZ9eD.png">

## How to build

The command for compiling into a .bin with NASM is: `nasm -f bin boot.asm -o boot.bin`

## How to run

Run with QEMU: `& "C:\Program Files\qemu\qemu-system-x86_64.exe" -fda boot.bin` (IF YOU DONT HAVE ADDED IT IN PATH, POWERSHELL)
<br>
or also: `qemu-system-x86_64 -fda boot.bin`
