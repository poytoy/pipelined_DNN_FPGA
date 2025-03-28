// Testbench for accelerator_piped module

module tb_accelerator_piped;

parameter INPUT_NEURON_COUNT = 40;
parameter OUTPUT_NEURON_COUNT = 40;
parameter MAX_PARALLEL = 20;

logic clk;
logic rst;
logic start;
logic done;

logic [15:0] inputs  [0:INPUT_NEURON_COUNT-1];
logic [15:0] weights [0:OUTPUT_NEURON_COUNT*INPUT_NEURON_COUNT-1];
logic [15:0] biases  [0:OUTPUT_NEURON_COUNT-1];
logic [15:0] out     [0:OUTPUT_NEURON_COUNT-1];

// Instantiate DUT
accelerator_piped #(
  .INPUT_NEURON_COUNT(INPUT_NEURON_COUNT),
  .OUTPUT_NEURON_COUNT(OUTPUT_NEURON_COUNT),
  .MAX_PARALLEL(MAX_PARALLEL)
) dut (
  .clk(clk),
  .rst(rst),
  .start(start),
  .inputs(inputs),
  .weights(weights),
  .biases(biases),
  .out(out),
  .done(done)
);

// Clock generation
always #5 clk = ~clk;

// Test sequence
initial begin
  integer i;
  clk = 0;
  rst = 1;
  start = 0;
  #20;
  rst = 0;
  #10;

  // Initialize inputs: 1, 2, ..., INPUT_NEURON_COUNT
  for (i = 0; i < INPUT_NEURON_COUNT; i++) begin
    inputs[i] = i + 1;
  end

  // Initialize weights: all 1s
  for (i = 0; i < OUTPUT_NEURON_COUNT * INPUT_NEURON_COUNT; i++) begin
    weights[i] = 16'd1;
  end

  // Initialize biases: all 5s
  for (i = 0; i < OUTPUT_NEURON_COUNT; i++) begin
    biases[i] = 16'd5;
  end

  // Start the operation
  start = 1;
  #10;
  start = 0;

  // Wait for completion
  wait(done);
  #10;

  // Display results
  $display("\n--- Output Results ---");
  for (i = 0; i < OUTPUT_NEURON_COUNT; i++) begin
    $display("out[%0d] = %0d", i, out[i]);
  end

  $display("\n--- Test Completed ---");
  $finish;
end

endmodule
