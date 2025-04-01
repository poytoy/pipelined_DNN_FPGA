module accelerator#(
    parameter int INPUT_NEURON_COUNT = 15,
    parameter int OUTPUT_NEURON_COUNT = 15
)(
    input logic [15:0] inputs [INPUT_NEURON_COUNT-1:0], // inputs neuron amt of inputs
    input logic [15:0] weights [OUTPUT_NEURON_COUNT*INPUT_NEURON_COUNT-1:0] , // each link between input and output neurons have special weight values.
    output logic [15:0] out [OUTPUT_NEURON_COUNT-1:0] //output neuron amt of outputs

);


//this for flattening the weihts double array.
genvar i;
generate
    for (i = 0; i < OUTPUT_NEURON_COUNT; i = i + 1) begin : neuron_inst
        logic [16*INPUT_NEURON_COUNT-1:0] packed_inputs;
        logic [16*INPUT_NEURON_COUNT-1:0] packed_weights;
    // Pack inputs into a flat vector [16*INPUT_NEURON_COUNT-1:0]
    for (genvar j = 0; j < INPUT_NEURON_COUNT; j = j + 1) begin : input_pack
        assign packed_inputs[16*(j+1)-1 -: 16] = inputs[j];
        assign packed_weights[16*(j+1)-1 -: 16] = weights[i * INPUT_NEURON_COUNT + j];
    end

    // Instantiate the neuron with the temporary weight array
    neuron #(
      .N(INPUT_NEURON_COUNT)
    ) neuron_inst (
      .inputs(packed_inputs),
      .weights(packed_weights),
      .result(out[i])
    );
  end
endgenerate
endmodule