`define assertCaseEqual(signal, value, message) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED assertCaseEqual in %s: %0d: signal !== value. signal is: %d (decimal), %h (hexa)",`__FILE__, `__LINE__,signal,signal); \
            $display("  Reason: %s ",message);\
            $finish; \
        end

`define assertCaseNotEqual(signal, value, message) \
        if (signal === value) begin \
            $display("ASSERTION FAILED assertCaseNotEqual in %s: %0d: signal === value. signal is: %d (decimal), %h (hexa)",`__FILE__, `__LINE__,signal,signal); \
            $display("  Reason: %s ",message);\
            $finish; \
        end