This is an educational project implementing a subset of RISC V 32 I in Verilog.

Supported instructions until now:

- Type I:
  - ADDI, ANDI, LW
- Type R:
  - ADD, SUB
- Type U:
  - LUI
- Type J:
  - JAL
- Type B:
  - TODO
- Type S:
  - SW

For testing:

pipenv run fusesoc run --target=sim namosca:arisco:core (outdated for now)

run tests.sh (for now the current)

Test will suceed on assembly code if register x31 is zero. So, if you want to test a function, store the expected value
in some register, then store the difference into x31. If its zero, it passes. Otherwise, you have to fix the implementation :)

Useful resources:
http://tice.sea.eseo.fr/riscv/
https://godbolt.org/z/cv9Yq6nW9