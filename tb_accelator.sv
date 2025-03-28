// Testbench for the standalone accelerator module

module tb_accelerator;

parameter int INPUT_NEURON_COUNT = 15;
parameter int OUTPUT_NEURON_COUNT = 15;

logic [15:0] inputs  [0:INPUT_NEURON_COUNT-1];
logic [15:0] weights [0:OUTPUT_NEURON_COUNT * INPUT_NEURON_COUNT - 1];
logic [15:0] biases  [0:OUTPUT_NEURON_COUNT-1];
logic [15:0] out     [0:OUTPUT_NEURON_COUNT-1];

// Instantiate the accelerator
accelerator #(
  .INPUT_NEURON_COUNT(INPUT_NEURON_COUNT),
  .OUTPUT_NEURON_COUNT(OUTPUT_NEURON_COUNT)
) dut (
  .inputs(inputs),
  .weights(weights),
  .biases(biases),
  .out(out)
);

initial begin
  integer i;

  // Initialize inputs: 1 to INPUT_NEURON_COUNT
  for (i = 0; i < INPUT_NEURON_COUNT; i++) begin
    inputs[i] = i + 1; // 1, 2, ..., 15
  end

  // Initialize weights: all 1s
  for (i = 0; i < OUTPUT_NEURON_COUNT * INPUT_NEURON_COUNT; i++) begin
    weights[i] = 16'd1;
  end

  // Initialize biases: all 5s
  for (i = 0; i < OUTPUT_NEURON_COUNT; i++) begin
    biases[i] = 16'd5;
  end

  #10;

  $display("\n--- Accelerator Output Results ---");
  for (i = 0; i < OUTPUT_NEURON_COUNT; i++) begin
    $display("out[%0d] = %0d", i, out[i]);
  end

  $display("\n--- Test Completed ---");
  $finish;
end

endmodule