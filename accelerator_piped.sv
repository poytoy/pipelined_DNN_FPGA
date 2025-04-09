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
        IDLE, LOAD_BATCH, RUN_BATCH, ACCUMULATE_SETUP, ACCUMULATE_WAIT, ACCUMULATE, 
        FINALIZE_SETUP, FINALIZE_WAIT, FINALIZE, RELU, WRITE_OUT, NEXT_OUTPUT, DONE
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

    
    // Addition pipeline registers
    logic [15:0] add_operand1;
    logic [15:0] add_operand2;
    logic [$clog2(MAX_PARALLEL):0] add_idx;  // Index tracking for addition operations
    logic add_is_active;
    
    // Temporary index calculation variables
    logic [31:0] bias_idx;

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
            RUN_BATCH:   next_state = ACCUMULATE_SETUP;
            
            // Modified state transitions for pipelined addition
            ACCUMULATE_SETUP: next_state = ACCUMULATE_WAIT;
            ACCUMULATE_WAIT: next_state = ACCUMULATE;
            ACCUMULATE: if (add_idx == 0) begin
                           if (input_batch_idx == NUM_INPUT_BATCHES - 1)
                               next_state = FINALIZE_SETUP;
                           else
                               next_state = LOAD_BATCH;
                       end else begin
                           next_state = ACCUMULATE_SETUP;
                       end
                       
            FINALIZE_SETUP: next_state = FINALIZE_WAIT;
            FINALIZE_WAIT: next_state = FINALIZE;
            FINALIZE: if (add_idx == 0) next_state = RELU;
                     else next_state = FINALIZE_SETUP;
                     
            RELU:        next_state = WRITE_OUT;
            WRITE_OUT:   if (output_batch_idx == NUM_OUTPUT_BATCHES - 1)
                             next_state = DONE;
                         else
                             next_state = NEXT_OUTPUT;
            NEXT_OUTPUT: next_state = LOAD_BATCH;
            DONE:        next_state = IDLE;
        endcase
    end

    // Main control logic with proper integer handling
    always_ff @(posedge clk) begin
        case (state)
            IDLE: begin
                output_batch_idx <= 0;
                input_batch_idx <= 0;
                done <= 0;
                for (int i = 0; i < MAX_PARALLEL; i++) accum[i] <= 0;
                add_is_active <= 0;
            end

            LOAD_BATCH: begin
                // Process inputs and weights with indices defined inside the loop
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    automatic int idx = input_batch_idx * MAX_PARALLEL + i;
                    sliced_inputs[i] <= (idx < INPUT_NEURON_COUNT) ? inputs[idx] : 16'h0;
                end
                
                for (int o = 0; o < MAX_PARALLEL; o++) begin
                    for (int i = 0; i < MAX_PARALLEL; i++) begin
                        automatic int out_idx = output_batch_idx * MAX_PARALLEL + o;
                        automatic int in_idx = input_batch_idx * MAX_PARALLEL + i;
                        sliced_weights[o * MAX_PARALLEL + i] <= (out_idx < OUTPUT_NEURON_COUNT && in_idx < INPUT_NEURON_COUNT)
                            ? weights[out_idx * INPUT_NEURON_COUNT + in_idx] : 16'h0;
                    end
                end
            end
            
            // Setup addition pipeline
            ACCUMULATE_SETUP: begin
                if (!add_is_active) begin
                    add_idx <= MAX_PARALLEL - 1; // Start from last element
                    add_is_active <= 1;
                end
                
                // Setup adder inputs
                num1 <= accum[add_idx];
                num2 <= partial_outs[add_idx];
            end
            
            // Wait state for adder to complete
            ACCUMULATE_WAIT: begin
                // Just wait for adder to process
            end
            
            // Capture adder result
            ACCUMULATE: begin
                // Store result back to accumulator
                accum[add_idx] <= num_out;
                
                // Decrement index or complete
                if (add_idx > 0) begin
                    add_idx <= add_idx - 1;
                end else begin
                    add_is_active <= 0;
                    input_batch_idx <= input_batch_idx + 1;
                end
            end
            
            // Setup bias addition
            FINALIZE_SETUP: begin
                if (!add_is_active) begin
                    add_idx <= MAX_PARALLEL - 1; // Start from last element
                    add_is_active <= 1;
                end
                
                // Calculate bias index first
                bias_idx <= output_batch_idx * MAX_PARALLEL + add_idx;
                
                // Setup adder inputs for bias addition
                num1 <= accum[add_idx];
                num2 <= (output_batch_idx * MAX_PARALLEL + add_idx < OUTPUT_NEURON_COUNT) ? 
                         biases[output_batch_idx * MAX_PARALLEL + add_idx] : 16'h0;
            end
            
            // Wait state for bias addition
            FINALIZE_WAIT: begin
                // Just wait for adder to process
            end
            
            // Capture bias addition result
            FINALIZE: begin
                accum[add_idx] <= num_out;
                
                // Decrement index or complete
                if (add_idx > 0) begin
                    add_idx <= add_idx - 1;
                end else begin
                    add_is_active <= 0;
                end
            end

            RELU: begin
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    accum[i] <= relu_outs[i]; // latch relu output into accum
                end
            end

            WRITE_OUT: begin
                for (int i = 0; i < MAX_PARALLEL; i++) begin
                    automatic int idx = output_batch_idx * MAX_PARALLEL + i;
                    if (idx < OUTPUT_NEURON_COUNT)
                        out[idx] <= accum[i];
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
