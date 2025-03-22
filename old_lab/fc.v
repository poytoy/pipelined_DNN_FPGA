`timescale 1ns / 1ps

module fcl#(
    parameter int WIDTH = 32,
    parameter int INPUT_NEURON_COUNT = 15,
    parameter int OUTPUT_NEURON_COUNT = 15,
    parameter int RELU_THRESHOLD = 6,
    parameter int fxp_frac = 15,
    parameter int fxp_finalint = 8,
    parameter int relu_out = 16
) (
    input logic [15:0] inputs [INPUT_NEURON_COUNT-1:0], // inputs neuron amt of inputs
    input logic [15:0] weights [OUTPUT_NEURON_COUNT-1:0] [INPUT_NEURON_COUNT-1:0] , // each link between input and output neurons have special weight values.
    input logic [15:0] biases [OUTPUT_NEURON_COUNT-1:0], //each output neuron has one bias value
    output logic [15:0] out [OUTPUT_NEURON_COUNT-1:0] //output neuron amt of outputs

);
localparam accumulator_width = $clog2(INPUT_NEURON_COUNT) + WIDTH;
logic [WIDTH-1:0] product [OUTPUT_NEURON_COUNT-1:0][INPUT_NEURON_COUNT-1:0];
logic [accumulator_width-1:0] product_sum [OUTPUT_NEURON_COUNT-1:0][INPUT_NEURON_COUNT:0];
logic [accumulator_width-1:0] final_sum [OUTPUT_NEURON_COUNT-1:0];

genvar j, i;

    generate
        for ( j = 0; j < OUTPUT_NEURON_COUNT ; j = j + 1) begin
            assign product_sum[j][0] = 32'b0;
            for ( i = 0; i < INPUT_NEURON_COUNT ; i = i + 1) begin
            
                fixed_multiplier fc_mult(inputs[i], weights[j][i], product[j][i]);
                fixed_adder_par #(.WIDTH(WIDTH), .acc_width(accumulator_width))
                    products_adder(product_sum[j][i], product[j][i], product_sum[j][i+1]);
            end
            fixed_adder_par #(.WIDTH(accumulator_width))
                bias_adder(product_sum[j][INPUT_NEURON_COUNT], {{(16){0}}, biases[j] << fxp_finalint}, final_sum[j]); // adding bias to Q16.15 format while the bias is Q8.7. Convert!!!
                    
            relu_param #(accumulator_width, RELU_THRESHOLD, fxp_frac, fxp_finalint, relu_out) 
                relu6(final_sum[j], out[j]);
        end
    endgenerate    
            



endmodule




