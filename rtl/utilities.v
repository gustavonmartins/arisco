`ifndef assertCaseEqual
    `define assertCaseEqual(signal, value, message) \
            if (signal !== value) begin \
                $display("%c[1;31m",27);\
                $display("ASSERTION FAILED assertCaseEqual in %s: %0d: signal !== value. signal is: %d (decimal), %h (hexa), should be %d (decimal), %h(hexa)",`__FILE__, `__LINE__,signal,signal,value,value); \
                $display("  Reason: %s ",message);\
                $display("%c[0m",27);\
                $fatal(); \
            end
`endif

`ifndef assertCaseNotEqual
    `define assertCaseNotEqual(signal, value, message) \
            if (signal === value) begin \
                $display("%c[1;31m",27);\
                $display("ASSERTION FAILED assertCaseNotEqual in %s: %0d: signal === value. signal is: %d (decimal), %h (hexa)",`__FILE__, `__LINE__,signal,signal); \
                $display("  Reason: %s ",message);\
                $display("%c[0m",27);\
                $fatal(); \
            end
`endif

`ifndef fullFSMInstructionCycle
    `define fullFSMInstructionCycle\
            @(negedge clk);@(negedge clk);@(negedge clk); // Just finished instruction
`endif

`ifndef resetFSMAndReadInstruction
    `define resetFSMAndReadInstruction \
            reset=0;@(posedge clk);@(negedge clk); @(negedge clk);// Resetted FSM, then Read instruction
`endif
