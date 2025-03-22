module relu6 (
    input  [15:0] in,
    output [15:0] out
);
    parameter FP6 = 16'b0100011000000000; // 6.0 in half-precision
    parameter FP0 = 16'b0000000000000000; // 0.0 in half-precision

    assign out = (in[14:0] == 15'b0 || in[15] == 1'b1) ? FP0 : // negative or zero -> 0
                 (in > FP6) ? FP6 : in;                        // >6 -> 6, else -> in
endmodule