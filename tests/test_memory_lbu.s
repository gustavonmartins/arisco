addi x31,x0,0               // STARTUP: Any test should pass if and only if x31 is zero
li      x1,-82964480        // BEGIN:   Will test LBU implementation. First stores 0xFB0E0AF0 and extracts F0
addi    x1,x1,-1296         //          Creates value 0xFB0E0AF0
sw      x1,0(x0)            //          Saves it into memory position 0
lbu     x10,0(x0)           //          Supposedly unsignedly read byte F0, 
li      x11,240             //          Creates control value F0
sub x31,x10,x11             // END:     Control variable: Register 31 should be zero
nop
nop
nop