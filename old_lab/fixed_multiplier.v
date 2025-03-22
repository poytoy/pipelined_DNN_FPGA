`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.02.2025 18:53:03
// Design Name: 
// Module Name: fixed_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fixed_multiplier #(
 parameter int WIDTH = 32
)(
    input  logic  [15:0] in_put,  
    input  logic  [15:0] weight,  
    output logic  [31:0] product 
    );
    logic  [31:0] sum, shifted_sum;
    logic  [15:0] no_signbit_input, no_signbit_weight;
    logic plusorminus;
    
    always_comb begin
        if((in_put[15] & weight[15]) || (in_put[15] | weight[15] == 0))
            plusorminus = 0;
        else
            plusorminus = 1;
        no_signbit_input = in_put & 32'h7FFF;
        no_signbit_weight = weight & 32'h7FFF;
        sum = no_signbit_input * no_signbit_weight;   
        shifted_sum = sum <<< 1;                         
        product = {plusorminus, shifted_sum[30:0]};
    end
endmodule
