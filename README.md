This is an educational project implementing a subset of RISC V 32 I in Verilog.

Supported instructions until now:
Type I:
    ADDI, ANDI
Type R:
    ADD


For testing:

pipenv run fusesoc run --target=sim namosca:arisco:core   