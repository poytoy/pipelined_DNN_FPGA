    module top_module_tb;
    
        // Parameters
        parameter LAYER_0_NEURON_COUNT = 36;
        parameter LAYER_1_NEURON_COUNT = 20;
        parameter LAYER_2_NEURON_COUNT = 20;
        parameter LAYER_3_NEURON_COUNT = 10;
        parameter ACCEL_IN_DIM = 20;
        parameter ACCEL_OUT_DIM = 20;
        
        // Signals
        reg clk;
        reg rst;
        reg btns_debounced;
        wire [9:0] prediction;
    
        // Instantiate the top module
        top_module #(
            .LAYER_0_NEURON_COUNT(LAYER_0_NEURON_COUNT),
            .LAYER_1_NEURON_COUNT(LAYER_1_NEURON_COUNT),
            .LAYER_2_NEURON_COUNT(LAYER_2_NEURON_COUNT),
            .LAYER_3_NEURON_COUNT(LAYER_3_NEURON_COUNT),
            .ACCEL_IN_DIM(ACCEL_IN_DIM),
            .ACCEL_OUT_DIM(ACCEL_OUT_DIM)
        ) uut (
            .clk(clk),
            .rst(rst),
            .btns_debounced(btns_debounced),
            .prediction(prediction)
        );
    
        // Clock generation
        initial begin
            clk = 0;
            forever #5 clk = ~clk; // 100 MHz clock
        end
    
        // Test sequence
        initial begin
            // Initialize signals
            rst = 1;
            btns_debounced = 0;
            
            // Apply reset
            #10;
            rst = 0;
            
            // Start the inference
            #10;
            btns_debounced = 1;
            
            // Wait for some time to observe the outputs
            #100000;
            
            // Finish simulation
            $finish;
        end
    
    endmodule
