module small_fc_top #(
    parameter LAYER_0_NEURON_COUNT=36,
    parameter LAYER_1_NEURON_COUNT=20,
    parameter LAYER_2_NEURON_COUNT=20,
    parameter LAYER_3_NEURON_COUNT=10,
    parameter ACCEL_IN_DIM=4,
    parameter ACCEL_OUT_DIM=10
)(
    input clk,
    input rst,
    input btns_debounced,
    output reg[9:0]prediciton
);
endmodule