`timescale 1ns / 1ps

module tb_neuron;
     
    parameter N = 4;

    // Test inputs
    reg  [16*N-1:0] inputs;
    reg  [16*N-1:0] weights;
    reg  [15:0]     bias;
    wire [15:0]     result;

    // Instantiate the neuron
    neuron #(N) uut (
        .inputs(inputs),
        .weights(weights),
        .bias(bias),
        .result(result)
    );

    initial begin
        $dumpfile("neuron.vcd");       // name of the VCD output file
        $dumpvars(0, tb_neuron);   
        $display("Starting neuron test...");
        
        // === Example: inputs and weights in IEEE 754 half-precision ===
        // Inputs:     [ 1.0, 2.0, 0.0, -1.0 ]
        // Weights:    [ 0.5, -1.0, 2.0,  1.0 ]
        // Bias:       0.5
        // Expected:   (1.0*0.5 + 2.0*-1.0 + 0.0*2.0 + -1.0*1.0) + 0.5 = -2.0 → ReLU6 → 0.0

        // Load inputs (MSB = input[N-1])
        inputs  = {
            16'h0000, // -1.0
            16'h4000, //  0.0
            16'h4000, //  2.0
            16'h0000  //  1.0
        };

        weights = {
            16'h0000, //  -1.0
            16'h4000, //  2.0
            16'h4000, // -1.0
            16'h0000  //  0.5
        };

        bias = 16'h0000; // 0.5

        #50;
        $display("Result (ReLU6 applied): %h", result); // Expect: 0.0 → 0x0000
        $monitor("res = %h" , result);

        $finish;
    end

endmodule
