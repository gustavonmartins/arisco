This is an educational project implementing a subset of RISC V 32 I in Verilog.


For testing:

pipenv run fusesoc run --target=sim namosca:arisco:core (outdated for now)

run tests.sh (for now the current)

Test will suceed on assembly code if register x31 is zero. So, if you want to test a function, store the expected value
in some register, then store the difference into x31. If its zero, it passes. Otherwise, you have to fix the implementation :)

Useful resources:
http://tice.sea.eseo.fr/riscv/
https://godbolt.org/z/cv9Yq6nW9


For making ICE40 run at 48Mhz:

 https://github.com/smunaut/ice40-playground/blob/master/projects/riscv_doom/rtl/sysmgr.v
 https://github.com/smunaut/ice40-playground/blob/master/projects/riscv_doom/rtl/top.v#L460-L466