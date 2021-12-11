`ifndef assertCaseEqual
    `define assertCaseEqual(signal, value, message) \
            if (signal !== value) begin \
                $display("%c[1;31m",27);\
                $display("ASSERTION FAILED assertCaseEqual in %s: %0d: signal !== value. signal is: %d (decimal), %h (hexa)",`__FILE__, `__LINE__,signal,signal); \
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
