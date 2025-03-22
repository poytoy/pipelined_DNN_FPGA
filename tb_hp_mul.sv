`timescale 1ns / 1ps

module tb_hp_mul;

    reg  [15:0] a, b;
    wire [15:0] p;

    // Instantiate the DUT
    hp_mul uut (
        .a(a),
        .b(b),
        .p(p)
    );

    // Helper task to apply inputs and display outputs
    task run_test(input [15:0] val_a, input [15:0] val_b, string desc);
        begin
            a = val_a;
            b = val_b;
            #10;
            $display("%s => a = %h, b = %h, p = %h", desc, a, b, p);
        end
    endtask

    initial begin
        $display("\n=== Half-Precision Multiplier Testbench ===\n");
        $dumpfile("hp_mul.vcd");
        $dumpvars(0, tb_hp_mul);

        // Test cases
        run_test(16'h3C00, 16'h4000, "Test 1: 1.0 × 2.0");     // Expect 3.0 (4200)
        run_test(16'hBC00, 16'h4000, "Test 2: -1.0 × 2.0");    // Expect -2.0 (C000)
        run_test(16'h0000, 16'h3C00, "Test 3: 0 × 1.0");       // Expect 0
        run_test(16'h7C00, 16'h3C00, "Test 4: Inf × 1.0");     // Expect Inf
        run_test(16'h7E00, 16'h3C00, "Test 5: NaN × 1.0");     // Expect NaN
        run_test(16'h3555, 16'h3555, "Test 6: Random subnormal × subnormal");

        $display("\n=== Tests Complete ===\n");
        $finish;
    end

endmodule
