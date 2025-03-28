// `timescale 1ns / 1ps

// module tb_neuron;
     
//     parameter N = 4;

//     // Test inputs
//     reg  [16*N-1:0] inputs;
//     reg  [16*N-1:0] weights;
//     reg  [15:0]     bias;
//     wire [15:0]     result;

//     // Instantiate the neuron
//     neuron #(N) uut (
//         .inputs(inputs),
//         .weights(weights),
//         .bias(bias),
//         .result(result)
//     );

//     initial begin
//         $dumpfile("neuron.vcd");       // name of the VCD output file
//         $dumpvars(0, tb_neuron);   
//         $display("Starting neuron test...");
        
//         // === Example: inputs and weights in IEEE 754 half-precision ===
//         // Inputs:     [ 1.0, 2.0, 0.0, -1.0 ]
//         // Weights:    [ 0.5, -1.0, 2.0,  1.0 ]
//         // Bias:       0.5
//         // Expected:   (1.0*0.5 + 2.0*-1.0 + 0.0*2.0 + -1.0*1.0) + 0.5 = -2.0 → ReLU6 → 0.0

//         // Load inputs (MSB = input[N-1])
//         inputs  = {
//             16'h0000, // -1.0
//             16'h4000, //  0.0
//             16'h4000, //  2.0
//             16'h0000  //  1.0
//         };

//         weights = {
//             16'h0000, //  -1.0
//             16'h4000, //  2.0
//             16'h4000, // -1.0
//             16'h0000  //  0.5
//         };

//         bias = 16'h0000; // 0.5

//         #50;
//         $display("Result (ReLU6 applied): %h", result); // Expect: 0.0 → 0x0000
//         $monitor("res = %h" , result);

//         $finish;
//     end

// endmodule
// Testbench for modified neuron module (MAC only)

// Icarus Verilog-friendly testbench for modified neuron (MAC only)

module tb_neuron_mac;

parameter N = 4;

reg  [16*N-1:0] inputs;
reg  [16*N-1:0] weights;
wire [15:0]     result;

// Instantiate the neuron module
neuron #(.N(N)) dut (
  .inputs(inputs),
  .weights(weights),
  .result(result)
);

initial begin
  integer i;
  reg [15:0] temp_inputs [0:N-1];
  reg [15:0] temp_weights[0:N-1];

  // --- Test Case 1 ---
  for (i = 0; i < N; i = i + 1) begin
    temp_inputs[i]  = i + 1;      // 1, 2, 3, 4
    temp_weights[i] = 16'd1;      // 1, 1, 1, 1
  end

  for (i = 0; i < N; i = i + 1) begin
    inputs [16*(i+1)-1 -: 16] = temp_inputs[i];
    weights[16*(i+1)-1 -: 16] = temp_weights[i];
  end

  #10;
  $display("Test 1: result = %0d (Expected: 10)", result);

  // --- Test Case 2 ---
  temp_inputs[0] = 5;
  temp_inputs[1] = 6;
  temp_inputs[2] = 7;
  temp_inputs[3] = 8;

  temp_weights[0] = 2;
  temp_weights[1] = 2;
  temp_weights[2] = 2;
  temp_weights[3] = 2;

  for (i = 0; i < N; i = i + 1) begin
    inputs [16*(i+1)-1 -: 16] = temp_inputs[i];
    weights[16*(i+1)-1 -: 16] = temp_weights[i];
  end

  #10;
  $display("Test 2: result = %0d (Expected: 52)", result);

  $finish;
end

endmodule