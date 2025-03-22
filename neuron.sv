
module neuron #(
    parameter N = 4
)(
    input  [16*N-1:0] inputs,     // Packed inputs
    input  [16*N-1:0] weights,    // Packed weights
    input  [15:0]     bias,       // Bias value
    output [15:0]     result      // Activated output
);

    wire [15:0] input_array[N-1:0];
    wire [15:0] weight_array[N-1:0];
    wire [15:0] products[N-1:0];
    wire [15:0] partial_sums[N:0];
    wire [15:0] final_sum;

    assign partial_sums[0] = 16'b0; // Initialize sum

    genvar k;
    generate
        for (k = 0; k < N; k = k+ 1) begin :unpack
            assign input_array[k]  = inputs[16*(k+1)-1 -: 16];//starting point : len
            assign weight_array[k] = weights[16*(k+1)-1 -: 16];
            hp_mul mul (
                .a(input_array[k]),
                .b(weight_array[k]),
                .p(products[k])
            );
        end
    endgenerate
//initilize adder tree
    assign partial_sums[0] = 0;

    generate
        for (genvar k = 0; k < N; k = k + 1) begin : sum_chain
            float_adder add_inst (
                .num1(partial_sums[k]),
                .num2(products[k]),
                .result(partial_sums[k+1])
            );
        end
    endgenerate
    
    assign final_sum = partial_sums[N];

    wire [15:0] biased_sum;
    float_adder bias_add (
        .num1(final_sum),
        .num2(bias),
        .result(biased_sum)
    );

    relu6 activation (
        .in(biased_sum),
        .out(result)
    );

endmodule