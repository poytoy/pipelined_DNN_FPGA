// Top-level FSM-based FCL controller that reuses a 20x20 accelerator

module accelerator_piped #(
    parameter int INPUT_NEURON_COUNT = 60,
    parameter int OUTPUT_NEURON_COUNT = 50,
    parameter int MAX_PARALLEL = 20
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [15:0] inputs  [INPUT_NEURON_COUNT-1:0],
    input  logic [15:0] weights [OUTPUT_NEURON_COUNT * INPUT_NEURON_COUNT - 1:0],
    input  logic [15:0] biases  [OUTPUT_NEURON_COUNT-1:0],
    output logic [15:0] out     [OUTPUT_NEURON_COUNT-1:0],
    output logic done
);

    typedef enum logic [3:0] {
        IDLE, LOAD_BATCH, RUN_BATCH, ACCUMULATE, FINALIZE, RELU, WRITE_OUT, NEXT_OUTPUT, DONE
    } state_t;

    state_t state, next_state;

    localparam int NUM_OUTPUT_BATCHES = (OUTPUT_NEURON_COUNT + MAX_PARALLEL - 1) / MAX_PARALLEL;
    localparam int NUM_INPUT_BATCHES  = (INPUT_NEURON_COUNT + MAX_PARALLEL - 1) / MAX_PARALLEL;

    logic [$clog2(NUM_OUTPUT_BATCHES)-1:0] output_batch_idx;
    logic [$clog2(NUM_INPUT_BATCHES)-1:0] input_batch_idx;
    logic [15:0] accum [MAX_PARALLEL-1:0];
    logic [15:0] sliced_inputs [MAX_PARALLEL-1:0];
    logic [15:0] sliced_weights [MAX_PARALLEL*MAX_PARALLEL-1:0];
    logic [15:0] partial_outs [MAX_PARALLEL-1:0];
    logic [15:0] relu_outs [MAX_PARALLEL-1:0];

    // Accelerator instantiation (20x20 block)
    accelerator #(
        .INPUT_NEURON_COUNT(MAX_PARALLEL),
        .OUTPUT_NEURON_COUNT(MAX_PARALLEL)
    ) acc_inst (
        .inputs(sliced_inputs),
        .weights(sliced_weights),
        .out(partial_outs)
    );
    genvar r;
    generate
        for (r = 0; r < MAX_PARALLEL; r++) begin : relu_inst
            relu6 relu_unit (
                .in(accum[r]),
                .out(relu_outs[r])
            );
        end
    endgenerate

    logic [15:0] num1;
    logic [15:0] num2;
    logic [15:0] num_out;
    float_adder add_inst (
        .num1(num1),
        .num2(num2),
        .result(num_out)
    );
   

    // FSM logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE:        if (start) next_state = LOAD_BATCH;
            LOAD_BATCH:  next_state = RUN_BATCH;
            RUN_BATCH:   next_state = ACCUMULATE;
            ACCUMULATE: if (input_batch_idx == NUM_INPUT_BATCHES - 1)
                            next_state = FINALIZE;
                        else
                            next_state = LOAD_BATCH;
            FINALIZE:    next_state = RELU;
            RELU:        next_state = WRITE_OUT;
            WRITE_OUT: if (output_batch_idx == NUM_OUTPUT_BATCHES - 1)
                            next_state = DONE;
                        else
                            next_state = NEXT_OUTPUT;
            NEXT_OUTPUT: next_state = LOAD_BATCH;
            DONE:        next_state = IDLE;
        endcase
    end

    // Main control logic
    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                output_batch_idx <= 0;
                input_batch_idx <= 0;
                done <= 0;
                for (int i = 0; i < MAX_PARALLEL; i++) accum[i] <= 0;
            end

            LOAD_BATCH: begin
                // Slice inputs[input_batch_idx]
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    int idx = input_batch_idx * MAX_PARALLEL + i;
                    sliced_inputs[i] = (idx < INPUT_NEURON_COUNT) ? inputs[idx] : 0;// inputs 0 if exceeds
                end
                // Slice weights for current input/output batch
                for (int o = 0; o < MAX_PARALLEL; o++) begin
                    for (int i = 0; i < MAX_PARALLEL; i++) begin
                        int out_idx = output_batch_idx * MAX_PARALLEL + o;
                        int in_idx = input_batch_idx * MAX_PARALLEL + i;
                        sliced_weights[o * MAX_PARALLEL + i] = (out_idx < OUTPUT_NEURON_COUNT && in_idx < INPUT_NEURON_COUNT)
                            ? weights[out_idx * INPUT_NEURON_COUNT + in_idx] : 0;//weights 0 if exceeds so neuorons are virtualy useless
                    end
                end
            end

            ACCUMULATE: begin
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    num1 <= accum[i];
                    num2 <= partial_outs[i];
                    accum[i] <= num_out;
                end
                input_batch_idx <= input_batch_idx + 1;
            end

            FINALIZE: begin
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    int idx = output_batch_idx * MAX_PARALLEL + i;//calcualtes indexes of biases
                    if (idx < OUTPUT_NEURON_COUNT)
                    num1 <= accum[i];
                    num2 <= biases[idx];
                    accum[i] <= num_out;
                end
            end
            RELU: begin
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    accum[i] <= relu_outs[i]; // latch relu output into accum
                end
            end

            WRITE_OUT: begin
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    int idx = output_batch_idx * MAX_PARALLEL + i;//calculates the output batch index
                    if (idx < OUTPUT_NEURON_COUNT)
                    out[idx] <= accum[i];//now has the relu outputs in.
                end
            end

            NEXT_OUTPUT: begin
                output_batch_idx <= output_batch_idx + 1;
                input_batch_idx <= 0;
                for (int i = 0; i < MAX_PARALLEL; i++) accum[i] <= 0;
            end

            DONE: begin
                done <= 1;
            end
        endcase
    end
endmodule