addi    x31,x0,0                // STARTUP: Any test should pass if and only if x31 is zero
add     x1,x0,1                // Sub-test number 1
li      x5,0xFB0E0AF0           // BEGIN:   Will test LBU implementation. First stores 0xFB0E0AF0 and extracts F0
sw      x5,0(x0)                //          Saves it into memory position 0
LBU     x10,0(x0)               //          Supposedly unsignedly read byte F0, 
li      x11,0xF0                //          Creates control value F0
sub     x31,x10,x11             // END:     Control variable: Register 31 should be zero



//Tests offset of LBU. As immediate are 12 bits long and sign extend, its important to test boundaries for posive and negative.
//Negative is -2048
add     x1,x1,1                // Sub-test id
//Stores base number at memory pos 3000
li x5, 0xFB0E0AF0
li x10, 3000 // 3000
sw x5,0(x10)   //Will store it at memory position 10
// Value that LBU is supposed to read
li x6, 0xF0
//Sets where to load from
li x15, 5048
LBU x21,-2048(x15) // Gets byte from 5048-2048=3000
// Checks results
sub x31,x6,x21


//Tests offset of LBU. As immediate are 12 bits long and sign extend, its important to test boundaries for posive and negative.
//Negative is -2048
add     x1,x1,1                // Sub-test id
//Stores base number at memory pos 3000
li x5, 0xFB0E0AB9
li x10, 4000 // 3000
sw x5,0(x10)   //Will store it at memory position 10
// Value that LBU is supposed to read
li x6, 0xB9
//Sets where to load from
li x15, 1953
LBU x21,2047(x15) // Gets byte from 1953+2047=4000

// Checks results
sub x31,x6,x21

