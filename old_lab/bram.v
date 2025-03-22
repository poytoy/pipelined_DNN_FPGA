`timescale 1ns / 1ps

module bram #(
    parameter int ADDR_WIDTH = 10,   //2^addr places to store...
    parameter int DATA_WIDTH = 16   //...16 bits per place
) (
    input  logic clk,               
    input  logic rst,              
    input  logic we,                //write-enable
    input  logic [ADDR_WIDTH-1:0] addr,   
    input  logic [DATA_WIDTH-1:0] din,    
    output logic [DATA_WIDTH-1:0] dout    
);

    // memory
    (* ram_style = "block" *) logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH:0]; // 2^addr width -> 2048 farkl? mem address...

    always_ff @(posedge clk) begin
        if (rst) begin
            dout <= {DATA_WIDTH{1'b0}};
        end else if (we == 1) begin
            mem[addr] <= din;  
        end else if (we == 0) begin
            dout <= mem[addr];  // FSM state spawner
        end
    end

endmodule