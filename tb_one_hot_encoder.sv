`timescale 1ns / 1ps

module tb_my_module;

  parameter N = 4;

  reg  [15:0] inputs [0:N-1];
  wire [N-1:0] outputs;

  // Instantiate DUT
  one_hot_encoder #(.N(N)) dut (
    .inputs(inputs),
    .outputs(outputs)
  );

  integer i, t;
  reg [N-1:0] expected;
  integer error_count = 0;

  reg [15:0] test_in_0 [0:9];
  reg [15:0] test_in_1 [0:9];
  reg [15:0] test_in_2 [0:9];
  reg [15:0] test_in_3 [0:9];
  reg [1:0]  expected_idx [0:9];

  initial begin
    // Define test values manually
    test_in_0[0] = 16'h3C00; test_in_1[0] = 16'h4000; test_in_2[0] = 16'hBC00; test_in_3[0] = 16'h3800; expected_idx[0] = 1;
    test_in_0[1] = 16'h3C00; test_in_1[1] = 16'h3C00; test_in_2[1] = 16'h3C00; test_in_3[1] = 16'h3C00; expected_idx[1] = 0;
    test_in_0[2] = 16'h3800; test_in_1[2] = 16'h3C00; test_in_2[2] = 16'h4000; test_in_3[2] = 16'h4200; expected_idx[2] = 3;
    test_in_0[3] = 16'h4200; test_in_1[3] = 16'h4000; test_in_2[3] = 16'h3C00; test_in_3[3] = 16'h3800; expected_idx[3] = 0;
    test_in_0[4] = 16'h3800; test_in_1[4] = 16'h4000; test_in_2[4] = 16'h4000; test_in_3[4] = 16'h3800; expected_idx[4] = 1;
    test_in_0[5] = 16'hBC00; test_in_1[5] = 16'hBC00; test_in_2[5] = 16'hBC00; test_in_3[5] = 16'hBC00; expected_idx[5] = 0;
    test_in_0[6] = 16'h0000; test_in_1[6] = 16'h8000; test_in_2[6] = 16'h0000; test_in_3[6] = 16'h8000; expected_idx[6] = 0;
    test_in_0[7] = 16'hC000; test_in_1[7] = 16'h4000; test_in_2[7] = 16'h3C00; test_in_3[7] = 16'h3800; expected_idx[7] = 1;
    test_in_0[8] = 16'h3C00; test_in_1[8] = 16'h3C01; test_in_2[8] = 16'h3C02; test_in_3[8] = 16'h3C03; expected_idx[8] = 3;
    test_in_0[9] = 16'h3C03; test_in_1[9] = 16'h3C02; test_in_2[9] = 16'h3C01; test_in_3[9] = 16'h3C00; expected_idx[9] = 0;

    for (t = 0; t < 10; t = t + 1) begin
      inputs[0] = test_in_0[t];
      inputs[1] = test_in_1[t];
      inputs[2] = test_in_2[t];
      inputs[3] = test_in_3[t];

      expected = {N{1'b0}};
      expected[expected_idx[t]] = 1'b1;

      #1;

      $display("Test %0d:", t);
      for (i = 0; i < N; i = i + 1) begin
        $display("  inputs[%0d] = 0x%h", i, inputs[i]);
      end
      $display("  Expected one-hot = %b", expected);
      $display("  Actual   one-hot = %b", outputs);

      if (outputs !== expected) begin
        $display("  ❌ MISMATCH!\n");
        error_count = error_count + 1;
      end else begin
        $display("  ✅ PASS\n");
      end
    end

    $display("Test completed. Total errors: %0d", error_count);
    $finish;
  end

endmodule

