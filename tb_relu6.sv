`timescale 1ns / 1ps

module tb_relu6;

    reg  [15:0] in;
    wire [15:0] out;

    relu6 uut (
        .in(in),
        .out(out)
    );

    // Helper task to test and print
    task run_test(input [15:0] value, string desc);
        begin
            in = value;
            #5;
            $display("%s => in: %h, out: %h", desc, in, out);
        end
    endtask

    initial begin
        $dumpfile("relu6.vcd");
        $dumpvars(0, tb_relu6);
        $display("\n=== ReLU6 Testbench ===\n");

        // Test cases
        run_test(16'hBC00, "Test 1: Input = -1.0");   // Expect 0
        run_test(16'h0000, "Test 2: Input =  0.0");   // Expect 0
        run_test(16'h3C00, "Test 3: Input =  1.0");   // Expect 1.0
        run_test(16'h4200, "Test 4: Input =  3.0");   // Expect 3.0
        run_test(16'h4600, "Test 5: Input =  6.0");   // Expect 6.0
        run_test(16'h4700, "Test 6: Input =  7.0");   // Expect clamped to 6.0
        run_test(16'h7C00, "Test 7: Input =  Inf");   // Edge: Inf -> 6.0

        $display("\n=== ReLU6 Tests Done ===\n");
        $finish;
    end

endmodule