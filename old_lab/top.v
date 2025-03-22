`timescale 1ns / 1ps
//verilog koduma yazd?ktan sonra bakar?m
//ve neden bu kadar uzun u?ra?t?m, baya kolay g�z�k�yor diye d�?�n�r�m
//ee417 quizinde python syntax? unutturan cinsten bir �devdi
module fsm_main#(
    parameter int FCL1_INPUT_NEURON_COUNT = 5,
    parameter int FCL2_OUTPUT_NEURON_COUNT = 5,
    parameter int FCL1_OUTPUT_NEURON_COUNT = 15,
    parameter int FCL2_INPUT_NEURON_COUNT = 15

)(
    input  logic clk,
    input  logic rst,
    input  logic south_button,
    input  logic east_button,
    output logic [10:0] output_synth [4:0],
    output logic [5:0]  showoff, //rgb ???k show
    output logic [3:0]  AN,      
    output logic [6:0]  SEG,     
    output logic       DP,
    output reg [10:0] led
);


logic [15:0] weights_fcl1 [FCL2_INPUT_NEURON_COUNT-1:0][FCL2_INPUT_NEURON_COUNT-1:0];
logic [15:0] weights_fcl2 [FCL2_INPUT_NEURON_COUNT-1:0][FCL2_INPUT_NEURON_COUNT-1:0];
logic [15:0] biases_fcl1 [FCL2_INPUT_NEURON_COUNT-1:0];                            
logic [15:0] biases_fcl2 [FCL2_INPUT_NEURON_COUNT-1:0];                
logic [15:0] fcl_inputs [FCL1_OUTPUT_NEURON_COUNT-1:0];

initial begin
    
    fcl_inputs[0] = 16'h0000;   // 0.0
    fcl_inputs[1] = 16'h0080;   // 1.0
    fcl_inputs[2] = 16'h0080;   // 1.0
    fcl_inputs[3] = 16'h0080;   // 1.0
    fcl_inputs[4] = 16'h0080;   // 1.0
    fcl_inputs[5] = 16'h0000;
    fcl_inputs[6] = 16'h0000;
    fcl_inputs[7] = 16'h0000;
    fcl_inputs[8] = 16'h0000;
    fcl_inputs[9] = 16'h0000;
    fcl_inputs[10] = 16'h0000;
    fcl_inputs[11] = 16'h0000;
    fcl_inputs[12] = 16'h0000;
    fcl_inputs[13] = 16'h0000;
    fcl_inputs[14] = 16'h0000;
    
    //weights 0.0, 0.125, 0.125, 0.125.
    weights_fcl1[0][0] = 16'h0000; // 0.0
    weights_fcl1[0][1] = 16'h0010;   // 0.125 
    weights_fcl1[0][2] = 16'h0010;   // 0.125
    weights_fcl1[0][3] = 16'h0010;   // 0.125
    weights_fcl1[0][4] = 16'h0010;   // 0.125
    weights_fcl1[1][0] = 16'h0000;   // 0.0
    weights_fcl1[1][1] = 16'h0010;   // 0.125 
    weights_fcl1[1][2] = 16'h0010;   // 0.125
    weights_fcl1[1][3] = 16'h0010;   // 0.125
    weights_fcl1[1][4] = 16'h0010;   // 0.125
    weights_fcl1[2][0] = 16'h0000;   // 0.0
    weights_fcl1[2][1] = 16'h0010;   // 0.125 
    weights_fcl1[2][2] = 16'h0010;   // 0.125
    weights_fcl1[2][3] = 16'h0010;   // 0.125
    weights_fcl1[2][4] = 16'h0010;   // 0.125
    weights_fcl1[3][0] = 16'h0000;   // 0.0
    weights_fcl1[3][1] = 16'h0010;   // 0.125 
    weights_fcl1[3][2] = 16'h0010;   // 0.125
    weights_fcl1[3][3] = 16'h0010;   // 0.125
    weights_fcl1[3][4] = 16'h0010;   // 0.125
    weights_fcl1[4][0] = 16'h0000;   // 0.0
    weights_fcl1[4][1] = 16'h0010;   // 0.125 
    weights_fcl1[4][2] = 16'h0010;   // 0.125
    weights_fcl1[4][3] = 16'h0010;   // 0.125
    weights_fcl1[4][4] = 16'h0010;   // 0.125
    weights_fcl1[5][0] = 16'h0000;   // 0.0
    weights_fcl1[5][1] = 16'h0010;   // 0.125 
    weights_fcl1[5][2] = 16'h0010;   // 0.125
    weights_fcl1[5][3] = 16'h0010;   // 0.125
    weights_fcl1[5][4] = 16'h0010;   // 0.125
    weights_fcl1[6][0] = 16'h0000;   // 0.0
    weights_fcl1[6][1] = 16'h0010;   // 0.125 
    weights_fcl1[6][2] = 16'h0010;   // 0.125
    weights_fcl1[6][3] = 16'h0010;   // 0.125
    weights_fcl1[6][4] = 16'h0010;   // 0.125
    weights_fcl1[7][0] = 16'h0000;   // 0.0
    weights_fcl1[7][1] = 16'h0010;   // 0.125 
    weights_fcl1[7][2] = 16'h0010;   // 0.125
    weights_fcl1[7][3] = 16'h0010;   // 0.125
    weights_fcl1[7][4] = 16'h0010;   // 0.125
    weights_fcl1[8][0] = 16'h0000;   // 0.0
    weights_fcl1[8][1] = 16'h0010;   // 0.125 
    weights_fcl1[8][2] = 16'h0010;   // 0.125
    weights_fcl1[8][3] = 16'h0010;   // 0.125
    weights_fcl1[8][4] = 16'h0010;   // 0.125
    weights_fcl1[9][0] = 16'h0000;   // 0.0
    weights_fcl1[9][1] = 16'h0010;   // 0.125 
    weights_fcl1[9][2] = 16'h0010;   // 0.125
    weights_fcl1[9][3] = 16'h0010;   // 0.125
    weights_fcl1[9][4] = 16'h0010;   // 0.125
    weights_fcl1[10][0] = 16'h0000;   // 0.0
    weights_fcl1[10][1] = 16'h0010;   // 0.125
    weights_fcl1[10][2] = 16'h0010;   // 0.125
    weights_fcl1[10][3] = 16'h0010;   // 0.125
    weights_fcl1[10][4] = 16'h0010;   // 0.125
    weights_fcl1[11][0] = 16'h0000;   // 0.0
    weights_fcl1[11][1] = 16'h0010;   // 0.125
    weights_fcl1[11][2] = 16'h0010;   // 0.125
    weights_fcl1[11][3] = 16'h0010;   // 0.125
    weights_fcl1[11][4] = 16'h0010;   // 0.125
    weights_fcl1[12][0] = 16'h0000;   // 0.0
    weights_fcl1[12][1] = 16'h0010;   // 0.125
    weights_fcl1[12][2] = 16'h0010;   // 0.125
    weights_fcl1[12][3] = 16'h0010;   // 0.125
    weights_fcl1[12][4] = 16'h0010;   // 0.125
    weights_fcl1[13][0] = 16'h0000;   // 0.0
    weights_fcl1[13][1] = 16'h0010;   // 0.125
    weights_fcl1[13][2] = 16'h0010;   // 0.125
    weights_fcl1[13][3] = 16'h0010;   // 0.125
    weights_fcl1[13][4] = 16'h0010;   // 0.125
    weights_fcl1[14][0] = 16'h0000;   // 0.0
    weights_fcl1[14][1] = 16'h0010;   // 0.125
    weights_fcl1[14][2] = 16'h0010;   // 0.125
    weights_fcl1[14][3] = 16'h0010;   // 0.125
    weights_fcl1[14][4] = 16'h0010;   // 0.125
        

    weights_fcl1[0][5] = 16'h0000; weights_fcl1[0][6] = 16'h0000; weights_fcl1[0][7] = 16'h0000; weights_fcl1[0][8] = 16'h0000; weights_fcl1[0][9] = 16'h0000; weights_fcl1[0][10] = 16'h0000; weights_fcl1[0][11] = 16'h0000; weights_fcl1[0][12] = 16'h0000; weights_fcl1[0][13] = 16'h0000; weights_fcl1[0][14] = 16'h0000;
    weights_fcl1[1][5] = 16'h0000; weights_fcl1[1][6] = 16'h0000; weights_fcl1[1][7] = 16'h0000; weights_fcl1[1][8] = 16'h0000; weights_fcl1[1][9] = 16'h0000; weights_fcl1[1][10] = 16'h0000; weights_fcl1[1][11] = 16'h0000; weights_fcl1[1][12] = 16'h0000; weights_fcl1[1][13] = 16'h0000; weights_fcl1[1][14] = 16'h0000;
    weights_fcl1[2][5] = 16'h0000; weights_fcl1[2][6] = 16'h0000; weights_fcl1[2][7] = 16'h0000; weights_fcl1[2][8] = 16'h0000; weights_fcl1[2][9] = 16'h0000; weights_fcl1[2][10] = 16'h0000; weights_fcl1[2][11] = 16'h0000; weights_fcl1[2][12] = 16'h0000; weights_fcl1[2][13] = 16'h0000; weights_fcl1[2][14] = 16'h0000;
    weights_fcl1[3][5] = 16'h0000; weights_fcl1[3][6] = 16'h0000; weights_fcl1[3][7] = 16'h0000; weights_fcl1[3][8] = 16'h0000; weights_fcl1[3][9] = 16'h0000; weights_fcl1[3][10] = 16'h0000; weights_fcl1[3][11] = 16'h0000; weights_fcl1[3][12] = 16'h0000; weights_fcl1[3][13] = 16'h0000; weights_fcl1[3][14] = 16'h0000;
    weights_fcl1[4][5] = 16'h0000; weights_fcl1[4][6] = 16'h0000; weights_fcl1[4][7] = 16'h0000; weights_fcl1[4][8] = 16'h0000; weights_fcl1[4][9] = 16'h0000; weights_fcl1[4][10] = 16'h0000; weights_fcl1[4][11] = 16'h0000; weights_fcl1[4][12] = 16'h0000; weights_fcl1[4][13] = 16'h0000; weights_fcl1[4][14] = 16'h0000;
    weights_fcl1[5][5] = 16'h0000; weights_fcl1[5][6] = 16'h0000; weights_fcl1[5][7] = 16'h0000; weights_fcl1[5][8] = 16'h0000; weights_fcl1[5][9] = 16'h0000; weights_fcl1[5][10] = 16'h0000; weights_fcl1[5][11] = 16'h0000; weights_fcl1[5][12] = 16'h0000; weights_fcl1[5][13] = 16'h0000; weights_fcl1[5][14] = 16'h0000;
    weights_fcl1[6][5] = 16'h0000; weights_fcl1[6][6] = 16'h0000; weights_fcl1[6][7] = 16'h0000; weights_fcl1[6][8] = 16'h0000; weights_fcl1[6][9] = 16'h0000; weights_fcl1[6][10] = 16'h0000; weights_fcl1[6][11] = 16'h0000; weights_fcl1[6][12] = 16'h0000; weights_fcl1[6][13] = 16'h0000; weights_fcl1[6][14] = 16'h0000;
    weights_fcl1[7][5] = 16'h0000; weights_fcl1[7][6] = 16'h0000; weights_fcl1[7][7] = 16'h0000; weights_fcl1[7][8] = 16'h0000; weights_fcl1[7][9] = 16'h0000; weights_fcl1[7][10] = 16'h0000; weights_fcl1[7][11] = 16'h0000; weights_fcl1[7][12] = 16'h0000; weights_fcl1[7][13] = 16'h0000; weights_fcl1[7][14] = 16'h0000;
    weights_fcl1[8][5] = 16'h0000; weights_fcl1[8][6] = 16'h0000; weights_fcl1[8][7] = 16'h0000; weights_fcl1[8][8] = 16'h0000; weights_fcl1[8][9] = 16'h0000; weights_fcl1[8][10] = 16'h0000; weights_fcl1[8][11] = 16'h0000; weights_fcl1[8][12] = 16'h0000; weights_fcl1[8][13] = 16'h0000; weights_fcl1[8][14] = 16'h0000;
    weights_fcl1[9][5] = 16'h0000; weights_fcl1[9][6] = 16'h0000; weights_fcl1[9][7] = 16'h0000; weights_fcl1[9][8] = 16'h0000; weights_fcl1[9][9] = 16'h0000; weights_fcl1[9][10] = 16'h0000; weights_fcl1[9][11] = 16'h0000; weights_fcl1[9][12] = 16'h0000; weights_fcl1[9][13] = 16'h0000; weights_fcl1[9][14] = 16'h0000;
    weights_fcl1[10][5] = 16'h0000; weights_fcl1[10][6] = 16'h0000; weights_fcl1[10][7] = 16'h0000; weights_fcl1[10][8] = 16'h0000; weights_fcl1[10][9] = 16'h0000; weights_fcl1[10][10] = 16'h0000; weights_fcl1[10][11] = 16'h0000; weights_fcl1[10][12] = 16'h0000; weights_fcl1[10][13] = 16'h0000; weights_fcl1[10][14] = 16'h0000;
    weights_fcl1[11][5] = 16'h0000; weights_fcl1[11][6] = 16'h0000; weights_fcl1[11][7] = 16'h0000; weights_fcl1[11][8] = 16'h0000; weights_fcl1[11][9] = 16'h0000; weights_fcl1[11][10] = 16'h0000; weights_fcl1[11][11] = 16'h0000; weights_fcl1[11][12] = 16'h0000; weights_fcl1[11][13] = 16'h0000; weights_fcl1[11][14] = 16'h0000;
    weights_fcl1[12][5] = 16'h0000; weights_fcl1[12][6] = 16'h0000; weights_fcl1[12][7] = 16'h0000; weights_fcl1[12][8] = 16'h0000; weights_fcl1[12][9] = 16'h0000; weights_fcl1[12][10] = 16'h0000; weights_fcl1[12][11] = 16'h0000; weights_fcl1[12][12] = 16'h0000; weights_fcl1[12][13] = 16'h0000; weights_fcl1[12][14] = 16'h0000;
    weights_fcl1[13][5] = 16'h0000; weights_fcl1[13][6] = 16'h0000; weights_fcl1[13][7] = 16'h0000; weights_fcl1[13][8] = 16'h0000; weights_fcl1[13][9] = 16'h0000; weights_fcl1[13][10] = 16'h0000; weights_fcl1[13][11] = 16'h0000; weights_fcl1[13][12] = 16'h0000; weights_fcl1[13][13] = 16'h0000; weights_fcl1[13][14] = 16'h0000;
    weights_fcl1[14][5] = 16'h0000; weights_fcl1[14][6] = 16'h0000; weights_fcl1[14][7] = 16'h0000; weights_fcl1[14][8] = 16'h0000; weights_fcl1[14][9] = 16'h0000; weights_fcl1[14][10] = 16'h0000; weights_fcl1[14][11] = 16'h0000; weights_fcl1[14][12] = 16'h0000; weights_fcl1[14][13] = 16'h0000; weights_fcl1[14][14] = 16'h0000;
    //output n0 bias
    biases_fcl1[0] = 16'h0040;       
    biases_fcl1[1] = 16'h0040; 
    biases_fcl1[2] = 16'h0040; 
    biases_fcl1[3] = 16'h0040; 
    biases_fcl1[4] = 16'h0040; 
    biases_fcl1[5] = 16'h0040; 
    biases_fcl1[6] = 16'h0040; 
    biases_fcl1[7] = 16'h0040; 
    biases_fcl1[8] = 16'h0040; 
    biases_fcl1[9] = 16'h0040; 
    biases_fcl1[10] = 16'h0040; 
    biases_fcl1[11] = 16'h0040; 
    biases_fcl1[12] = 16'h0040; 
    biases_fcl1[13] = 16'h0040; 
    biases_fcl1[14] = 16'h0040; 
    
    




    //all weights 2
    weights_fcl2[0][0] = 16'h0080; weights_fcl2[0][1] = 16'h0080; weights_fcl2[0][2] = 16'h0080; weights_fcl2[0][3] = 16'h0080; weights_fcl2[0][4] = 16'h0080; weights_fcl2[0][5] = 16'h0080; weights_fcl2[0][6] = 16'h0080; weights_fcl2[0][7] = 16'h0080; weights_fcl2[0][8] = 16'h0080; weights_fcl2[0][9] = 16'h0080; weights_fcl2[0][10] = 16'h0080; weights_fcl2[0][11] = 16'h0080; weights_fcl2[0][12] = 16'h0080; weights_fcl2[0][13] = 16'h0080; weights_fcl2[0][14] = 16'h0080;
    weights_fcl2[1][0] = 16'h0080; weights_fcl2[1][1] = 16'h0080; weights_fcl2[1][2] = 16'h0080; weights_fcl2[1][3] = 16'h0080; weights_fcl2[1][4] = 16'h0080; weights_fcl2[1][5] = 16'h0080; weights_fcl2[1][6] = 16'h0080; weights_fcl2[1][7] = 16'h0080; weights_fcl2[1][8] = 16'h0080; weights_fcl2[1][9] = 16'h0080; weights_fcl2[1][10] = 16'h0080; weights_fcl2[1][11] = 16'h0080; weights_fcl2[1][12] = 16'h0080; weights_fcl2[1][13] = 16'h0080; weights_fcl2[1][14] = 16'h0080;
    weights_fcl2[2][0] = 16'h0080; weights_fcl2[2][1] = 16'h0080; weights_fcl2[2][2] = 16'h0080; weights_fcl2[2][3] = 16'h0080; weights_fcl2[2][4] = 16'h0080; weights_fcl2[2][5] = 16'h0080; weights_fcl2[2][6] = 16'h0080; weights_fcl2[2][7] = 16'h0080; weights_fcl2[2][8] = 16'h0080; weights_fcl2[2][9] = 16'h0080; weights_fcl2[2][10] = 16'h0080; weights_fcl2[2][11] = 16'h0080; weights_fcl2[2][12] = 16'h0080; weights_fcl2[2][13] = 16'h0080; weights_fcl2[2][14] = 16'h0080;
    weights_fcl2[3][0] = 16'h0080; weights_fcl2[3][1] = 16'h0080; weights_fcl2[3][2] = 16'h0080; weights_fcl2[3][3] = 16'h0080; weights_fcl2[3][4] = 16'h0080; weights_fcl2[3][5] = 16'h0080; weights_fcl2[3][6] = 16'h0080; weights_fcl2[3][7] = 16'h0080; weights_fcl2[3][8] = 16'h0080; weights_fcl2[3][9] = 16'h0080; weights_fcl2[3][10] = 16'h0080; weights_fcl2[3][11] = 16'h0080; weights_fcl2[3][12] = 16'h0080; weights_fcl2[3][13] = 16'h0080; weights_fcl2[3][14] = 16'h0080;
    weights_fcl2[4][0] = 16'h0080; weights_fcl2[4][1] = 16'h0080; weights_fcl2[4][2] = 16'h0080; weights_fcl2[4][3] = 16'h0080; weights_fcl2[4][4] = 16'h0080; weights_fcl2[4][5] = 16'h0080; weights_fcl2[4][6] = 16'h0080; weights_fcl2[4][7] = 16'h0080; weights_fcl2[4][8] = 16'h0080; weights_fcl2[4][9] = 16'h0080; weights_fcl2[4][10] = 16'h0080; weights_fcl2[4][11] = 16'h0080; weights_fcl2[4][12] = 16'h0080; weights_fcl2[4][13] = 16'h0080; weights_fcl2[4][14] = 16'h0080;
    weights_fcl2[5][0] = 16'h0000; weights_fcl2[5][1] = 16'h0000; weights_fcl2[5][2] = 16'h0000; weights_fcl2[5][3] = 16'h0000; weights_fcl2[5][4] = 16'h0000; weights_fcl2[5][5] = 16'h0000; weights_fcl2[5][6] = 16'h0000; weights_fcl2[5][7] = 16'h0000; weights_fcl2[5][8] = 16'h0000; weights_fcl2[5][9] = 16'h0000; weights_fcl2[5][10] = 16'h0000; weights_fcl2[5][11] = 16'h0000; weights_fcl2[5][12] = 16'h0000; weights_fcl2[5][13] = 16'h0000; weights_fcl2[5][14] = 16'h0000;
    weights_fcl2[6][0] = 16'h0000; weights_fcl2[6][1] = 16'h0000; weights_fcl2[6][2] = 16'h0000; weights_fcl2[6][3] = 16'h0000; weights_fcl2[6][4] = 16'h0000; weights_fcl2[6][5] = 16'h0000; weights_fcl2[6][6] = 16'h0000; weights_fcl2[6][7] = 16'h0000; weights_fcl2[6][8] = 16'h0000; weights_fcl2[6][9] = 16'h0000; weights_fcl2[6][10] = 16'h0000; weights_fcl2[6][11] = 16'h0000; weights_fcl2[6][12] = 16'h0000; weights_fcl2[6][13] = 16'h0000; weights_fcl2[6][14] = 16'h0000;
    weights_fcl2[7][0] = 16'h0000; weights_fcl2[7][1] = 16'h0000; weights_fcl2[7][2] = 16'h0000; weights_fcl2[7][3] = 16'h0000; weights_fcl2[7][4] = 16'h0000; weights_fcl2[7][5] = 16'h0000; weights_fcl2[7][6] = 16'h0000; weights_fcl2[7][7] = 16'h0000; weights_fcl2[7][8] = 16'h0000; weights_fcl2[7][9] = 16'h0000; weights_fcl2[7][10] = 16'h0000; weights_fcl2[7][11] = 16'h0000; weights_fcl2[7][12] = 16'h0000; weights_fcl2[7][13] = 16'h0000; weights_fcl2[7][14] = 16'h0000;
    weights_fcl2[8][0] = 16'h0000; weights_fcl2[8][1] = 16'h0000; weights_fcl2[8][2] = 16'h0000; weights_fcl2[8][3] = 16'h0000; weights_fcl2[8][4] = 16'h0000; weights_fcl2[8][5] = 16'h0000; weights_fcl2[8][6] = 16'h0000; weights_fcl2[8][7] = 16'h0000; weights_fcl2[8][8] = 16'h0000; weights_fcl2[8][9] = 16'h0000; weights_fcl2[8][10] = 16'h0000; weights_fcl2[8][11] = 16'h0000; weights_fcl2[8][12] = 16'h0000; weights_fcl2[8][13] = 16'h0000; weights_fcl2[8][14] = 16'h0000;
    weights_fcl2[9][0] = 16'h0000; weights_fcl2[9][1] = 16'h0000; weights_fcl2[9][2] = 16'h0000; weights_fcl2[9][3] = 16'h0000; weights_fcl2[9][4] = 16'h0000; weights_fcl2[9][5] = 16'h0000; weights_fcl2[9][6] = 16'h0000; weights_fcl2[9][7] = 16'h0000; weights_fcl2[9][8] = 16'h0000; weights_fcl2[9][9] = 16'h0000; weights_fcl2[9][10] = 16'h0000; weights_fcl2[9][11] = 16'h0000; weights_fcl2[9][12] = 16'h0000; weights_fcl2[9][13] = 16'h0000; weights_fcl2[9][14] = 16'h0000;
    weights_fcl2[10][0] = 16'h0000; weights_fcl2[10][1] = 16'h0000; weights_fcl2[10][2] = 16'h0000; weights_fcl2[10][3] = 16'h0000; weights_fcl2[10][4] = 16'h0000; weights_fcl2[10][5] = 16'h0000; weights_fcl2[10][6] = 16'h0000; weights_fcl2[10][7] = 16'h0000; weights_fcl2[10][8] = 16'h0000; weights_fcl2[10][9] = 16'h0000; weights_fcl2[10][10] = 16'h0000; weights_fcl2[10][11] = 16'h0000; weights_fcl2[10][12] = 16'h0000; weights_fcl2[10][13] = 16'h0000; weights_fcl2[10][14] = 16'h0000;
    weights_fcl2[11][0] = 16'h0000; weights_fcl2[11][1] = 16'h0000; weights_fcl2[11][2] = 16'h0000; weights_fcl2[11][3] = 16'h0000; weights_fcl2[11][4] = 16'h0000; weights_fcl2[11][5] = 16'h0000; weights_fcl2[11][6] = 16'h0000; weights_fcl2[11][7] = 16'h0000; weights_fcl2[11][8] = 16'h0000; weights_fcl2[11][9] = 16'h0000; weights_fcl2[11][10] = 16'h0000; weights_fcl2[11][11] = 16'h0000; weights_fcl2[11][12] = 16'h0000; weights_fcl2[11][13] = 16'h0000; weights_fcl2[11][14] = 16'h0000;
    weights_fcl2[12][0] = 16'h0000; weights_fcl2[12][1] = 16'h0000; weights_fcl2[12][2] = 16'h0000; weights_fcl2[12][3] = 16'h0000; weights_fcl2[12][4] = 16'h0000; weights_fcl2[12][5] = 16'h0000; weights_fcl2[12][6] = 16'h0000; weights_fcl2[12][7] = 16'h0000; weights_fcl2[12][8] = 16'h0000; weights_fcl2[12][9] = 16'h0000; weights_fcl2[12][10] = 16'h0000; weights_fcl2[12][11] = 16'h0000; weights_fcl2[12][12] = 16'h0000; weights_fcl2[12][13] = 16'h0000; weights_fcl2[12][14] = 16'h0000;
    weights_fcl2[13][0] = 16'h0000; weights_fcl2[13][1] = 16'h0000; weights_fcl2[13][2] = 16'h0000; weights_fcl2[13][3] = 16'h0000; weights_fcl2[13][4] = 16'h0000; weights_fcl2[13][5] = 16'h0000; weights_fcl2[13][6] = 16'h0000; weights_fcl2[13][7] = 16'h0000; weights_fcl2[13][8] = 16'h0000; weights_fcl2[13][9] = 16'h0000; weights_fcl2[13][10] = 16'h0000; weights_fcl2[13][11] = 16'h0000; weights_fcl2[13][12] = 16'h0000; weights_fcl2[13][13] = 16'h0000; weights_fcl2[13][14] = 16'h0000;
    weights_fcl2[14][0] = 16'h0000; weights_fcl2[14][1] = 16'h0000; weights_fcl2[14][2] = 16'h0000; weights_fcl2[14][3] = 16'h0000; weights_fcl2[14][4] = 16'h0000; weights_fcl2[14][5] = 16'h0000; weights_fcl2[14][6] = 16'h0000; weights_fcl2[14][7] = 16'h0000; weights_fcl2[14][8] = 16'h0000; weights_fcl2[14][9] = 16'h0000; weights_fcl2[14][10] = 16'h0000; weights_fcl2[14][11] = 16'h0000; weights_fcl2[14][12] = 16'h0000; weights_fcl2[14][13] = 16'h0000; weights_fcl2[14][14] = 16'h0000;
    

    //bias for output n1 is 1
    biases_fcl2[0] = 16'h0080;
    biases_fcl2[1] = 16'h0080;
    biases_fcl2[2] = 16'h0080;
    biases_fcl2[3] = 16'h0080;
    biases_fcl2[4] = 16'h0080;
    biases_fcl2[5] = 16'h0000;
    biases_fcl2[6] = 16'h0000;
    biases_fcl2[7] = 16'h0000;
    biases_fcl2[8] = 16'h0000;
    biases_fcl2[9] = 16'h0000;
    biases_fcl2[10] = 16'h0000;
    biases_fcl2[11] = 16'h0000;
    biases_fcl2[12] = 16'h0000;
    biases_fcl2[13] = 16'h0000;
    biases_fcl2[14] = 16'h0000;
    
    

end



localparam int ADDR_WIDTH = 10;  
localparam int DATA_WIDTH = 16;  
localparam int FCL_WIDTH = 32;
localparam int FCL_IO = 15;
localparam int RELU_THRESHOLD = 6;
localparam int fxp_frac = 15;
localparam int fxp_finalint = 8;
localparam int relu_out = 16;

localparam int ADDR_INPUTS_START = 0;
localparam int ADDR_INPUTS_END = ADDR_INPUTS_START + FCL_IO - 1;

localparam int ADDR_WEIGHTS1_START = ADDR_INPUTS_END + 1;
localparam int ADDR_WEIGHTS1_END = ADDR_WEIGHTS1_START + (FCL_IO * FCL_IO) - 1;

localparam int ADDR_BIASES1_START = ADDR_WEIGHTS1_END + 1;
localparam int ADDR_BIASES1_END = ADDR_BIASES1_START + FCL_IO - 1;

localparam int ADDR_WEIGHTS2_START = ADDR_BIASES1_END + 1;
localparam int ADDR_WEIGHTS2_END = ADDR_WEIGHTS2_START + (FCL_IO * FCL_IO) - 1;

localparam int ADDR_BIASES2_START = ADDR_WEIGHTS2_END + 1;
localparam int ADDR_BIASES2_END = ADDR_BIASES2_START + FCL_IO - 1;

localparam int ADDR_INTERMEDIATERESULT_START = ADDR_BIASES2_END + 1;
localparam int ADDR_INTERMEDIATERESULT_END = ADDR_INTERMEDIATERESULT_START + FCL_IO - 1;

localparam int ADDR_FINALRESULT_START = ADDR_INTERMEDIATERESULT_END + 1;
localparam int ADDR_FINALRESULT_END = ADDR_FINALRESULT_START + FCL_IO - 1;


logic computeflag, started, finalflag;


//TEMP REG
logic [15:0] fcl1_inputs_reg [FCL_IO-1:0];
logic [15:0] fcl1_weights_reg [FCL_IO-1:0][FCL_IO-1:0];
logic [15:0] fcl1_biases_reg [FCL_IO-1:0];
logic [15:0] intermediate_results [FCL_IO-1:0];
logic [15:0] fcl1_output_reg [FCL_IO-1:0];
logic data_finished;
logic write_finished;
logic firstwrite_finished;
logic read_finished;
logic cyclewait;
logic south_out, east_out;
logic [1:0] wait_dout;
logic [3:0] output_cnt;





logic bram_we;
logic [ADDR_WIDTH-1:0] bram_addr;
logic [DATA_WIDTH-1:0] bram_din;
logic [DATA_WIDTH-1:0] bram_dout;

logic computeflag_internal, write_finished_internal, firstwrite_finished_internal, read_finished_internal;
logic bram_we_internal;
logic [ADDR_WIDTH-1:0] bram_addr_internal;
logic [DATA_WIDTH-1:0] bram_din_internal;




//bram and fcl instances

//display controller cs401 lab4'den �al?nt?. harf falan ekledim
display_controller display(.clk(clk), .in3(ssd3), .in2(ssd2), .in1(ssd1), .in0(ssd0), .seg(SEG), .dp(DP), .an(AN));

bram #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) 
    MEM (
    .clk(clk),
    .rst(rst),
    .we(bram_we),
    .addr(bram_addr),
    .din(bram_din),
    .dout(bram_dout)
);

fcl #(.WIDTH(FCL_WIDTH), .INPUT_NEURON_COUNT(FCL_IO), .OUTPUT_NEURON_COUNT(FCL_IO), .RELU_THRESHOLD(RELU_THRESHOLD), .fxp_frac(fxp_frac), .fxp_finalint(fxp_finalint), .relu_out(relu_out)) 
    FCL1 (
    .inputs(fcl1_inputs_reg),
    .weights(fcl1_weights_reg),
    .biases(fcl1_biases_reg),
    .out(intermediate_results)
);

debouncer db_btns (.clk(clk), .rst(rst), .btn_in(east_button), .btn_out(east_out));
debouncer db_btns2 (.clk(clk), .rst(rst), .btn_in(south_button), .btn_out(south_out));
rgb_fade fade(.clk(clk), .rst(rst), .global_state(state[1:0]),.showoff(showoff));


typedef enum logic [2:0]
{
    START = 3'd0,
    WRITE_TO_BRAM = 3'd1,
    READ_TO_REGS = 3'd2,
    COMPUTE = 3'd3,
    READ_TO_LEDS = 3'd5,
    IDLE = 3'd6

}type_state;

type_state state, next_state;



//RESET LOGIC
always_ff @(posedge clk) begin
    if (rst)
        finalflag <= 1'b0;
    else if (state == WRITE_TO_BRAM && computeflag == 1 && write_finished == 1)
        finalflag <= 1'b1;
end

always_ff @(posedge clk) begin
    if (rst) begin
        state <= START;
        computeflag <= 1'b0;
        bram_we <= 1'b0;
        bram_addr <= 'd0;
        bram_din <= 'd0;
        write_finished <= 1'b0;
        read_finished <= 1'b0;
        write_finished_internal <= 1'b0;
        read_finished_internal <= 1'b0;
        computeflag_internal <= 1'b0;
        bram_we_internal <= 1'b0;
        bram_addr_internal <= 'd0;
        bram_din_internal <= 'd0;
        

        
    end else begin
        state <= next_state;
        computeflag <= computeflag_internal;
        write_finished <= write_finished_internal;
        firstwrite_finished <= firstwrite_finished_internal;
        read_finished <= read_finished_internal;
        bram_we <= bram_we_internal;
        bram_addr <= bram_addr_internal;
        bram_din <= bram_din_internal;
    end
end    


    
logic east_out_previous; 

always_ff @(posedge clk) begin
    if (rst) begin
        started <= 1'b1;
        output_cnt <= 'd0;
        east_out_previous <= 1'b0;
    end
    else begin
        east_out_previous <= east_out;
        
        if(state == IDLE)
            started <= 1'b0;
            
        if (east_out && !east_out_previous && state == READ_TO_LEDS)  begin
            if (output_cnt < 5) begin
                output_cnt <= output_cnt + 1;
            end
        end
    end
end

always_ff @(posedge clk) begin
    if (rst)
        led <= 11'd300;  
    else if (state == READ_TO_LEDS && started == 1 && data_finished == 1 && output_cnt < 5)
        led <= output_synth[output_cnt];
    else
        led <= 11'b0;  
end

//NEXT STATE LOGIC
always_ff @(posedge clk) begin
    case(state)
    START: begin
        if( started == 1/*west_button*/) begin
            next_state = WRITE_TO_BRAM;
            computeflag_internal <= 1'b0;
        end    
    end
    WRITE_TO_BRAM: begin
        if(/*&& west_button*/ firstwrite_finished == 1 ) begin
            next_state = READ_TO_REGS;
            bram_we_internal <= 0;
        end
        else if(computeflag != 1 /*&& west_button*/&& write_finished == 1) begin
            next_state = READ_TO_REGS;
            bram_we_internal <= 0;
        end
        else if(computeflag == 1 /*&& west_button*/&& write_finished == 1) begin
            next_state = READ_TO_LEDS;
            bram_we_internal <= 0;

        end
    end
    READ_TO_REGS: begin
        if(started == 1/*west_button*/ && read_finished == 1) begin
            next_state = COMPUTE;
        end
    end
    COMPUTE: begin
        if(started == 1/*west_button*/) begin
            next_state = WRITE_TO_BRAM;
            write_finished_internal <= 0;
            read_finished_internal <= 0;
            bram_we_internal <= 1;
         end    
            
    end
    READ_TO_LEDS: begin
        if (east_out == 1) begin
        // If button pressed, stay in this state unless we've shown all outputs
            if (output_cnt >= 4) // Changed from 5 to 4 since we're checking after increment
                next_state = IDLE;
            else
                next_state = READ_TO_LEDS;
        end    
    end
    IDLE: begin
        if(started == 1/*west_button*/) begin
            next_state = IDLE;
        end    
    end
    endcase
end
    
//BRAM STUFF...
typedef enum logic [5:0] {
    BRAMIDLE, INPUT_LOAD, WEIGHTS1_LOAD, WEIGHTS2_LOAD, BIASES1_LOAD, BIASES2_LOAD, INTERMEDIATE_LOAD, FINAL_LOAD, DONE,
    BRAMIDLE2, INPUT_WAIT, WEIGHTS1_WAIT, WEIGHTS2_WAIT, BIASES1_WAIT, BIASES2_WAIT, INTERMEDIATE_WAIT, FINAL_WAIT,
    INPUT_WRITE, WEIGHTS1_WRITE, WEIGHTS2_WRITE, BIASES1_WRITE, BIASES2_WRITE, INTERMEDIATE_WRITE, FINAL_WRITE, INTERMEDIATE_WAIT2, FINAL_WAIT2
} state_bram;

always_ff @(posedge clk) begin
    if (rst || state == COMPUTE)
        firstwrite_finished_internal <= 1'b0;
    else if (bramstate == BIASES2_LOAD && index1 >= FCL2_OUTPUT_NEURON_COUNT)
        firstwrite_finished_internal <= 1'b1;
end

state_bram bramstate, bramstate2;

int index1, index2, index3, index4, index5;


always_ff @(posedge clk) begin
    if (rst) begin
        bramstate <= BRAMIDLE;
        bramstate2 <= BRAMIDLE2;
        index1 <= 0;
        index2 <= 0;
        index3 <= 0;
        index4 <= 0;
        wait_dout <= 0;
        cyclewait <= 0;
        
    end 
    else if (state == WRITE_TO_BRAM) begin
        case (bramstate)
            BRAMIDLE: begin
                index1 <= 0;
                index2 <= 0;
                
                bramstate <= INPUT_LOAD;
                bram_we_internal <= 1;
            end
            

            INPUT_LOAD: begin
                if (index1 < FCL_IO) begin
                    bram_addr_internal <= ADDR_INPUTS_START + index1;
                    bram_din_internal <= fcl_inputs[index1];
                    index1 <= index1 + 1;
                end else begin
                    index1 <= 0;
                    bramstate <= WEIGHTS1_LOAD;
                end
            end
            

            WEIGHTS1_LOAD: begin
                if (index1 < FCL_IO) begin
                    if (index2 < FCL_IO) begin
                        bram_addr_internal <= ADDR_WEIGHTS1_START + index2 + (index1 * FCL_IO);
                        bram_din_internal <= weights_fcl1[index1][index2];
                        index2 <= index2 + 1;
                    end else begin
                        index2 <= 0;
                        index1 <= index1 + 1;
                    end
                end else begin
                    index1 <= 0;
                    bramstate <= WEIGHTS2_LOAD;
                end
            end
            

            WEIGHTS2_LOAD: begin
                if (index1 < FCL_IO) begin
                    if (index2 < FCL_IO) begin
                        bram_addr_internal <= ADDR_WEIGHTS2_START + index2 + (index1 * FCL_IO);
                        bram_din_internal <= weights_fcl2[index1][index2];
                        index2 <= index2 + 1;
                    end else begin
                        index2 <= 0;
                        index1 <= index1 + 1;
                    end
                end else begin
                    index1 <= 0;
                    bramstate <= BIASES1_LOAD;
                end
            end
            

            BIASES1_LOAD: begin
                if (index1 < FCL_IO) begin
                    bram_addr_internal <= ADDR_BIASES1_START + index1;
                    bram_din_internal <= biases_fcl1[index1];
                    index1 <= index1 + 1;
                end else begin
                    index1 <= 0;
                    bramstate <= BIASES2_LOAD;
                end
            end
            

            BIASES2_LOAD: begin
                if (index1 < FCL_IO) begin
                    bram_addr_internal <= ADDR_BIASES2_START + index1;
                    bram_din_internal <= biases_fcl2[index1];
                    index1 <= index1 + 1;
                end else begin
                    index1 <= 0;
                    bramstate <= INTERMEDIATE_LOAD;
                end
            end
            
            
            INTERMEDIATE_LOAD: begin
                if ((index1 < FCL_IO )&& (firstwrite_finished == 0) && cyclewait == 1) begin
                    bram_addr_internal <= ADDR_INTERMEDIATERESULT_START + index1;
                    bram_din_internal <= intermediate_results[index1];
                    fcl1_output_reg[index1] <= intermediate_results[index1];
                    index1 <= index1 + 1;
                end 
                else if(cyclewait == 0) begin
                    bramstate <= INTERMEDIATE_WAIT2;
                end
                else if (firstwrite_finished == 0) begin
                    index1 <= 0;
                    bramstate <= FINAL_WAIT2;
                    write_finished_internal <= 1;
                    cyclewait <= 0;
                end
                
            end
            
            INTERMEDIATE_WAIT2: begin
                cyclewait <= 1;
                bramstate <= INTERMEDIATE_LOAD;
            end
            

            FINAL_LOAD: begin
                if ((index1 < FCL_IO) && (write_finished == 0)) begin
                    bram_addr_internal <= ADDR_FINALRESULT_START + index1;
                    bram_din_internal <= intermediate_results[index1];
                    index1 <= index1 + 1;
                end 
                else if (write_finished == 0) begin
                    bramstate <= DONE;
                    write_finished_internal <= 1;
                end
            end
            
            FINAL_WAIT2: begin
                bramstate <= FINAL_LOAD;
            end
            DONE: begin

            end

        endcase
    end
    else if (state == READ_TO_REGS || state == READ_TO_LEDS) begin
        case (bramstate2)
                BRAMIDLE2: begin
                    index3 <= 0; 
                    index4 <= 0;
                    index5 <= 0;
                    bram_we_internal <= 0;  
                    bram_addr_internal <= 0; 
                    bramstate2 <= INPUT_WAIT;
                end
                
                
                INPUT_WAIT: begin
                    if (index3 < FCL_IO) begin
                        bram_addr_internal <= ADDR_INPUTS_START + index3;
                        bramstate2 <= INPUT_WRITE;
                    end else begin
                        index3 <= 0;
                        bramstate2 <= WEIGHTS1_WAIT;
                    end
                end
                
                INPUT_WRITE: begin
                    if(wait_dout == 2) begin        
                        fcl1_inputs_reg[index3] <= bram_dout;
                        index3 <= index3 + 1;
                        wait_dout <= 0;
                        bramstate2 <= INPUT_WAIT;
                    end
                    else if (wait_dout < 2)begin
                        wait_dout <= wait_dout + 1;
                    end
                end
                
                WEIGHTS1_WAIT: begin
                    if (index3 < FCL_IO) begin
                        if (index4 < FCL_IO) begin      
                            bram_addr_internal <= ADDR_WEIGHTS1_START + index4 + (index3 * FCL_IO);
                            bramstate2 <= WEIGHTS1_WRITE;                            
                        end else begin
                            index4 <= 0;
                            index3 <= index3 + 1;
                        end
                    end else begin
                        index3 <= 0;
                        bramstate2 <= BIASES1_WAIT;
                    end
                end
                
                WEIGHTS1_WRITE: begin
                    if(wait_dout == 2) begin        
                        fcl1_weights_reg[index3][index4] <= bram_dout;
                        index4 <= index4 + 1;  
                        wait_dout <= 0;
                        bramstate2 <= WEIGHTS1_WAIT;
                    end
                    else if (wait_dout < 2)begin
                        wait_dout <= wait_dout + 1;
                    end
                end
                
                
                
                BIASES1_WAIT: begin
                    if (index3 < FCL_IO) begin
                        bram_addr_internal <= ADDR_BIASES1_START + index3;
                        bramstate2 <= BIASES1_WRITE;
                    end 
                    else begin
                        index3 <= 0;
                        bramstate2 <= INTERMEDIATE_WAIT;
                        read_finished_internal <= 1;
                        index5 <= 1;
                    end
                end
                
                BIASES1_WRITE: begin
                    if(wait_dout == 2) begin        
                        fcl1_biases_reg[index3] <= bram_dout;
                        index3 <= index3 + 1;
                        wait_dout <= 0;
                        bramstate2 <= BIASES1_WAIT;
                    end
                    else if (wait_dout < 2)begin
                        wait_dout <= wait_dout + 1;
                    end
                end
                

                
                

                INTERMEDIATE_WAIT: begin
                    if ((index3 < FCL_IO) && (read_finished == 0) && index5 != 1) begin
                        bram_addr_internal <= ADDR_INTERMEDIATERESULT_START + index3 - FCL_IO;
                        bramstate2 <= INTERMEDIATE_WRITE;
                        
                    end
                     else if (read_finished == 0 && index5 != 1) begin
                        index3 <= 0;
                        bramstate2 <= WEIGHTS2_WAIT;
                        
                    end
                    index5 <= 2;
                end
                
                INTERMEDIATE_WRITE: begin
                    if(wait_dout == 2) begin        
                        fcl1_inputs_reg[index3] <= bram_dout;                    
                        index3 <= index3 + 1;
                        wait_dout <= 0;
                        bramstate2 <= INTERMEDIATE_WAIT;
                    end
                    else if (wait_dout < 2)begin
                        wait_dout <= wait_dout + 1;
                    end
                end


    
                WEIGHTS2_WAIT: begin
                    if (index3 < FCL_IO) begin
                        if (index4 < FCL_IO) begin
                            bram_addr_internal <= ADDR_WEIGHTS2_START + index4 + (index3 * FCL_IO);
                            bramstate2 <= WEIGHTS2_WRITE;
                        end else begin
                            index4 <= 0;
                            index3 <= index3 + 1;
                        end
                    end else begin
                        index3 <= 0;
                        bramstate2 <= BIASES2_WAIT;
                    end
                end
                
                WEIGHTS2_WRITE: begin
                    if(wait_dout == 2) begin        
                        fcl1_weights_reg[index3][index4] <= bram_dout;
                        index4 <= index4 + 1;
                        wait_dout <= 0;
                        bramstate2 <= WEIGHTS2_WAIT;
                    end
                    else if (wait_dout < 2)begin
                        wait_dout <= wait_dout + 1;
                    end
                end
                
                BIASES2_WAIT: begin
                    if (index3 < FCL_IO) begin
                        bram_addr_internal <= ADDR_BIASES2_START + index3;
                        bramstate2 <= BIASES2_WRITE;
                    end else begin
                        index3 <= 0;
                        bramstate2 <= FINAL_WAIT;
                        read_finished_internal <= 1;
                        computeflag_internal <= 1'b1;
                    end
                end
                
                BIASES2_WRITE: begin
                    if(wait_dout == 2) begin        
                        fcl1_biases_reg[index3] <= bram_dout;
                        index3 <= index3 + 1;
                        wait_dout <= 0;
                        bramstate2 <= BIASES2_WAIT;
                    end
                    else if (wait_dout < 2)begin
                        wait_dout <= wait_dout + 1;
                    end
                end
                
                FINAL_WAIT: begin
                    if ((index3 < FCL2_OUTPUT_NEURON_COUNT) && (finalflag == 1)) begin
                        bram_addr_internal <= ADDR_FINALRESULT_START + index3;
                        bramstate2 <= FINAL_WRITE;
                    end 
                    else if (read_finished == 0 && (finalflag == 1)) begin
                        bramstate2 <= DONE;
                        read_finished_internal <= 1;
                        data_finished <= 1;
                    end
                end
                
                FINAL_WRITE: begin
                    if(wait_dout == 3) begin        
                        output_synth[index3] <= bram_dout;
                        index3 <= index3 + 1;
                        wait_dout <= 0;
                        bramstate2 <= FINAL_WAIT;
                    end
                    else if (wait_dout < 3)begin
                        wait_dout <= wait_dout + 1;
                    end
                end
                
                DONE: begin
                    
                end
            endcase
            end
end
                    
                    





//SSD LOGIC
logic [4:0] ssd3, ssd2, ssd1, ssd0;

always_comb begin
    case(state)
        START: begin
            ssd3 = 5'd5; //s
            ssd2 = 5'd17; //t
            ssd1 = 5'd18; //r
            ssd0 = 5'd17; //t
        end
        WRITE_TO_BRAM: begin
            ssd2 = 5'd11; //b
            ssd1 = 5'd18; //r
            ssd0 = 5'd10; //a
        end
        READ_TO_REGS: begin
            ssd3 = 5'd18; //r
            ssd2 = 5'd14; //e
            ssd1 = 5'd20; //g
            ssd0 = 5'd5; //s
        end
        COMPUTE: begin
            ssd2 = 5'd12; //c
            ssd1 = 5'd17; //p
            ssd0 = 5'd21; //t
        end
        READ_TO_LEDS: begin
            ssd3 = 5'd19; //l
            ssd2 = 4'd14; //e
            ssd1 = 5'd18; //d
            ssd0 = 5'd5; //s
        end
        IDLE: begin
            ssd3 = 5'd22; //i
            ssd2 = 5'd13; //d
            ssd1 = 5'd19; //l
            ssd0 = 5'd14; //e
        end
        default: begin
            ssd3 = 5'd13; //d
            ssd2 = 5'd15; //f
            ssd1 = 5'd19; //l
            ssd0 = 5'd21; //t
        end
    endcase
  end


endmodule



module display_controller(

input clk,
input [3:0] in3, in2, in1, in0,
output [6:0]seg, logic dp,
output [3:0] an
);

localparam N = 18;

logic [N-1:0] count = {N{1'b0}};
always@ (posedge clk)
count <= count + 1;

logic [4:0]digit_val;

logic [3:0]digit_en;
always@ (*)

begin
digit_en = 4'b1111;
digit_val = in0;

case(count[N-1:N-2])

2'b00 :	//select first 7Seg.

begin
digit_val = {in0};
digit_en = 4'b1110;
end

2'b01:	//select second 7Seg.

begin
digit_val = {in1};
digit_en = 4'b1101;
end

2'b10:	//select third 7Seg.

begin
digit_val = {in2};
digit_en = 4'b1011;
end

2'b11:	//select forth 7Seg.

begin
digit_val = {in3};
digit_en = 4'b0111;
end
endcase
end

//Convert digit number to LED vector. LEDs are active low. cs401'den ald?m

logic [6:0] sseg_LEDs;
always @(*)
begin
sseg_LEDs = 7'b1111111; //default
case( digit_val)
5'd0 : sseg_LEDs = 7'b1000000; //to display 0
5'd1 : sseg_LEDs = 7'b1111001; //to display 1
5'd2 : sseg_LEDs = 7'b0100100; //to display 2
5'd3 : sseg_LEDs = 7'b0110000; //to display 3
5'd4 : sseg_LEDs = 7'b0011001; //to display 4
5'd5 : sseg_LEDs = 7'b0010010; //to display 5
5'd6 : sseg_LEDs = 7'b0000010; //to display 6
5'd7 : sseg_LEDs = 7'b1111000; //to display 7
5'd8 : sseg_LEDs = 7'b0000000; //to display 8
5'd9 : sseg_LEDs = 7'b0010000; //to display 9
5'd10: sseg_LEDs = 7'b0001000; //to display a
5'd11: sseg_LEDs = 7'b0000011; //to display b
5'd12: sseg_LEDs = 7'b1000110; //to display c
5'd13: sseg_LEDs = 7'b0100001; //to display d
5'd14: sseg_LEDs = 7'b0000110; //to display e
5'd15: sseg_LEDs = 7'b0001110; //to display f
5'd16: sseg_LEDs = 7'b0110111; //to display "="
5'd17: sseg_LEDs = 7'b0000111; // t
5'd18: sseg_LEDs = 7'b0110111; // r
5'd19: sseg_LEDs = 7'b1110001; // l
5'd20: sseg_LEDs = 7'b1000010; // g
5'd21: sseg_LEDs = 7'b0001100; // p
5'd22: sseg_LEDs = 7'b1001111; // I
default : sseg_LEDs = 7'b0111111; //dash 
endcase
end

assign an = digit_en;

assign seg = sseg_LEDs;
assign dp = 1'b1; //turn dp off

endmodule

//just disregard this... i'm trying to make it work until thursday
module rgb_fade(
    input  logic        clk,
    input  logic        rst,
    input  logic [1:0]  global_state,
    output logic [5:0]  showoff
);

    typedef enum logic [1:0] {
        WAIT_FOR_START,
        LED1_FADE,
        LED2_FADE
    } fade_state_t;
    fade_state_t fade_state;

    localparam IDLE         = 2'b00;
    localparam READ_TO_LEDS = 2'b01;
    localparam logic [7:0] SPEED_FACTOR = 8'd36;

    logic [23:0] color_step1, color_step2;
    logic [7:0] red1, green1, blue1;
    logic [7:0] red2, green2, blue2;

    always_ff @(posedge clk) begin
        if (rst) begin
            fade_state   <= WAIT_FOR_START;
            color_step1  <= 24'd0;
            color_step2  <= 24'd0;
        end else begin
            case (fade_state)
                WAIT_FOR_START: begin
                    color_step1 <= 24'd0;
                    color_step2 <= 24'd0;
                    if (global_state == READ_TO_LEDS)
                        fade_state <= LED1_FADE;
                end
                LED1_FADE: begin
                    if (global_state == READ_TO_LEDS) begin
                        if (color_step1 < 24'd16777215) begin
                            color_step1 <= color_step1 + SPEED_FACTOR;
                        end else begin
                            color_step1 <= 24'd0;
                            fade_state  <= LED2_FADE;
                        end
                    end else begin
                        fade_state <= WAIT_FOR_START;
                    end
                end
                LED2_FADE: begin
                    if (global_state == READ_TO_LEDS) begin
                        if (color_step2 < 24'd16777215) begin
                            color_step2 <= color_step2 + SPEED_FACTOR;
                        end else begin
                            color_step2 <= 24'd0;
                            fade_state  <= LED1_FADE;
                        end
                    end else begin
                        fade_state <= WAIT_FOR_START;
                    end
                end
                default: fade_state <= WAIT_FOR_START;
            endcase
        end
    end

    always_comb begin
        red1   = 8'd0;
        green1 = 8'd0;
        blue1  = 8'd0;
        case (color_step1[23:22])
            2'b00: begin
                red1   = 8'd255 - color_step1[21:14];
                green1 = color_step1[21:14];
                blue1  = 8'd0;
            end
            2'b01: begin
                red1   = 8'd0;
                green1 = 8'd255 - color_step1[21:14];
                blue1  = color_step1[21:14];
            end
            2'b10: begin
                red1   = color_step1[21:14];
                green1 = 8'd0;
                blue1  = 8'd255 - color_step1[21:14];
            end
            default: begin
                red1   = 8'd255;
                green1 = 8'd0;
                blue1  = 8'd0;
            end
        endcase
    end

    always_comb begin
        red2   = 8'd0;
        green2 = 8'd0;
        blue2  = 8'd0;
        case (color_step2[23:22])
            2'b00: begin
                red2   = 8'd255 - color_step2[21:14];
                green2 = color_step2[21:14];
                blue2  = 8'd0;
            end
            2'b01: begin
                red2   = 8'd0;
                green2 = 8'd255 - color_step2[21:14];
                blue2  = color_step2[21:14];
            end
            2'b10: begin
                red2   = color_step2[21:14];
                green2 = 8'd0;
                blue2  = 8'd255 - color_step2[21:14];
            end
            default: begin
                red2   = 8'd0;
                green2 = 8'd0;
                blue2  = 8'd255;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            showoff <= 6'd0;
        end else if (global_state == READ_TO_LEDS) begin
            case (fade_state)
                LED1_FADE: begin
                    showoff[0] <= 1'b1;
                    showoff[1] <= 1'b1;
                    showoff[2] <= 1'b1;
                    showoff[3] <= 1'b0;
                    showoff[4] <= 1'b0;
                    showoff[5] <= 1'b0;
                end
                LED2_FADE: begin
                    showoff[0] <= 1'b0;
                    showoff[1] <= 1'b0;
                    showoff[2] <= 1'b0;
                    showoff[3] <= 1'b1;
                    showoff[4] <= 1'b1;
                    showoff[5] <= 1'b1;
                end
                default: begin
                    showoff <= 6'd0;
                end
            endcase
        end else begin
            showoff <= 6'd0;
        end
    end

endmodule


module debouncer(
    input clk,
    input rst,
    input btn_in,
    output reg btn_out
);
    reg [4:0] shift_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 5'b0;
            btn_out <= 0;
        end else begin
            shift_reg <= {shift_reg[3:0], btn_in};
            btn_out <= shift_reg[3] & ~shift_reg[4]; // should be 1-cycle pulse on posedge
        end
    end
endmodule