`timescale 1ns/1ps

//voltage clamper diode - ama analog degil
module relu_param #(
    parameter int WIDTH = 32,
    parameter int THRESHOLD = 6,
    parameter int fxp_frac = 15,
    parameter int fxp_finalint = 8,
    parameter int relu_out = 16
)(
    input  logic signed [WIDTH-1:0] in,   
    output logic signed [relu_out-1:0] out   
    );
    
    logic signed [WIDTH-1:0] relu6_result;
    localparam logic signed [WIDTH-1:0] fxp_threshold = THRESHOLD << fxp_frac;
    
    always_comb begin
        if (in < 0)
            relu6_result = 0;
        else if (in > fxp_threshold)
            relu6_result = fxp_threshold;
        else
            relu6_result = in;
    
        out = relu6_result >>> fxp_finalint;
        
    end
    
endmodule
