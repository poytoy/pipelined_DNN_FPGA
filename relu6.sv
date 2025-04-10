module relu6 (
    input  [15:0] in,
    output [15:0] out
);
    parameter FP6 = 16'b0100011000000000; // 6.0 in half-precision
    parameter FP0 = 16'b0000000000000000; // 0.0 in half-precision
    function is_greater;
        input [15:0] a, b;

        reg sign_a, sign_b;
        reg [4:0] exp_a, exp_b;
        reg [9:0] frac_a, frac_b;

        begin
        sign_a = a[15];
        sign_b = b[15];
        exp_a  = a[14:10];
        exp_b  = b[14:10];
        frac_a = a[9:0];
        frac_b = b[9:0];

        // Handle special case: a == b
        if (a == b) begin
            is_greater = 0;
        end
        // a is positive, b is negative → a > b
        else if (sign_a == 0 && sign_b == 1) begin
            is_greater = 1;
        end
        // a is negative, b is positive → a < b
        else if (sign_a == 1 && sign_b == 0) begin
            is_greater = 0;
        end
        // both positive
        else if (sign_a == 0 && sign_b == 0) begin
            if (exp_a > exp_b) is_greater = 1;
            else if (exp_a < exp_b) is_greater = 0;
            else is_greater = (frac_a > frac_b);
        end
        // both negative → reverse comparison
        else begin
            if (exp_a < exp_b) is_greater = 1;
            else if (exp_a > exp_b) is_greater = 0;
            else is_greater = (frac_a < frac_b);
        end
        end
    endfunction
    assign out = (in[14:0] == 15'b0 || in[15] == 1'b1) ? FP0 : // negative or zero -> 0
                (is_greater(in, FP6))? FP6 : in;     // >6 -> 6, else -> in
endmodule
