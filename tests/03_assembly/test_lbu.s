addi    x31,x0,0                // STARTUP: Any test should pass if and only if x31 is zero
add     x1,x0,1                // Sub-test number 1
li      x5,0xFB0E0AF0           // BEGIN:   Will test LBU implementation. First stores 0xFB0E0AF0 and extracts F0
sw      x5,0(x0)                //          Saves it into memory position 0
LBU     x10,0(x0)               //          Supposedly unsignedly read byte F0, 
li      x11,0xF0                //          Creates control value F0
sub     x31,x10,x11             // END:     Control variable: Register 31 should be zero