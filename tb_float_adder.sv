`timescale 1ns/1ps

module tb_float_adder;

    reg [15:0] num1, num2;
    wire [15:0] result;

    // Instantiate the DUT (Device Under Test)
    float_adder uut (
        .num1(num1),
        .num2(num2),
        .result(result)
    );

    // Helper task to print the result in a readable format
    task run_test(input [15:0] a, input [15:0] b, string desc);
        begin
            num1 = a;
            num2 = b;
            #10; // wait for result to propagate
            $display("%s => num1 = %h, num2 = %h, result = %h", desc, num1, num2, result);
        end
    endtask

    initial begin
        $display("\n=== Starting float_adder Tests ===\n");

        // Dump waveform (optional)
        $dumpfile("float_adder.vcd");
        $dumpvars(0, tb_float_adder);


        // Test 2: -1.0 + 1.0 = 0.0
        run_test(16'hBC00, 16'hbC00, "Test 1: -1.0 + -1.0");

        //// Test 2: -2.0 + -2.0 = -4.0
        run_test(16'hC000, 16'hC000, "Test 2: -2.0 + -2.0");


        run_test(16'h3C00, 16'h3C00, "Test 3: 1.0 + 1.0");


        run_test(16'h4000, 16'h4000, "Test 4: 2.0 + 2.0");

        run_test(16'h3E00, 16'h3E00, "Test 5: 1.5 + 1.5");

        run_test(16'h4E00, 16'h4E00, "Test 6: 15.0 + 15.0");


   
        $display("\n=== Tests Complete ===\n");
        $finish;
    end

endmodule
