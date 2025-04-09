module top_module #(
    parameter LAYER_0_NEURON_COUNT = 100,
    parameter LAYER_1_NEURON_COUNT = 80,
    parameter LAYER_2_NEURON_COUNT = 40,
    parameter LAYER_3_NEURON_COUNT = 10,
    parameter ACCEL_IN_DIM = 20, 
    parameter ACCEL_OUT_DIM = 20  
)(
    input clk,
    input rst,
    input btns_debounced, // Single input for triggering
    output reg [9:0] prediction
);
    logic [15:0] input_data [LAYER_0_NEURON_COUNT-1:0];

initial begin
        input_data[0] = 16'h0000;
        input_data[1] = 16'h0000;
        input_data[2] = 16'h0000;
        input_data[3] = 16'h0000;
        input_data[4] = 16'h0000;
        input_data[5] = 16'h0000;
        input_data[6] = 16'h0000;
        input_data[7] = 16'h0000;
        input_data[8] = 16'h0000;
        input_data[9] = 16'h0000;
        input_data[10] = 16'h0000;
        input_data[11] = 16'h0000;
        input_data[12] = 16'h0000;
        input_data[13] = 16'h0000;
        input_data[14] = 16'h0000;
        input_data[15] = 16'h0000;
        input_data[16] = 16'h0000;
        input_data[17] = 16'h0000;
        input_data[18] = 16'h0000;
        input_data[19] = 16'h0000;
        input_data[20] = 16'h0000;
        input_data[21] = 16'h0000;
        input_data[22] = 16'h0000;
        input_data[23] = 16'h0000;
        input_data[24] = 16'h0000;
        input_data[25] = 16'h0000;
        input_data[26] = 16'h0000;
        input_data[27] = 16'h0000;
        input_data[28] = 16'h0000;
        input_data[29] = 16'h0000;
        input_data[30] = 16'h0000;
        input_data[31] = 16'h0000;
        input_data[32] = 16'h0000;
        input_data[33] = 16'h0000;
        input_data[34] = 16'h3C00;
        input_data[35] = 16'h3C00;
        input_data[36] = 16'h3C00;
        input_data[37] = 16'h3C00;
        input_data[38] = 16'h0000;
        input_data[39] = 16'h0000;
        input_data[40] = 16'h0000;
        input_data[41] = 16'h0000;
        input_data[42] = 16'h0000;
        input_data[43] = 16'h0000;
        input_data[44] = 16'h0000;
        input_data[45] = 16'h0000;
        input_data[46] = 16'h3C00;
        input_data[47] = 16'h0000;
        input_data[48] = 16'h0000;
        input_data[49] = 16'h0000;
        input_data[50] = 16'h0000;
        input_data[51] = 16'h0000;
        input_data[52] = 16'h0000;
        input_data[53] = 16'h0000;
        input_data[54] = 16'h0000;
        input_data[55] = 16'h3C00;
        input_data[56] = 16'h3C00;
        input_data[57] = 16'h0000;
        input_data[58] = 16'h0000;
        input_data[59] = 16'h0000;
        input_data[60] = 16'h0000;
        input_data[61] = 16'h0000;
        input_data[62] = 16'h0000;
        input_data[63] = 16'h3C00;
        input_data[64] = 16'h3C00;
        input_data[65] = 16'h3C00;
        input_data[66] = 16'h3C00;
        input_data[67] = 16'h3C00;
        input_data[68] = 16'h3C00;
        input_data[69] = 16'h0000;
        input_data[70] = 16'h0000;
        input_data[71] = 16'h0000;
        input_data[72] = 16'h0000;
        input_data[73] = 16'h0000;
        input_data[74] = 16'h3C00;
        input_data[75] = 16'h0000;
        input_data[76] = 16'h0000;
        input_data[77] = 16'h0000;
        input_data[78] = 16'h0000;
        input_data[79] = 16'h0000;
        input_data[80] = 16'h0000;
        input_data[81] = 16'h0000;
        input_data[82] = 16'h0000;
        input_data[83] = 16'h3C00;
        input_data[84] = 16'h0000;
        input_data[85] = 16'h0000;
        input_data[86] = 16'h0000;
        input_data[87] = 16'h0000;
        input_data[88] = 16'h0000;
        input_data[89] = 16'h0000;
        input_data[90] = 16'h0000;
        input_data[91] = 16'h0000;
        input_data[92] = 16'h0000;
        input_data[93] = 16'h3C00;
        input_data[94] = 16'h0000;
        input_data[95] = 16'h0000;
        input_data[96] = 16'h0000;
        input_data[97] = 16'h0000;
        input_data[98] = 16'h0000;
        input_data[99] = 16'h0000;
end    

    // FSM states
    typedef enum logic [3:0] {
        IDLE,
        LOAD_INPUTS,
        LOAD_LAYER1_WEIGHTS,
        PROCESS_LAYER1,
        LOAD_LAYER2_WEIGHTS,
        PROCESS_LAYER2,
        LOAD_LAYER3_WEIGHTS,
        PROCESS_LAYER3,
        FIND_MAX,
        DONE
    } state_t;
    
    state_t current_state, next_state;
    
    logic mem_we;
    logic [14:0] mem_addr; 
    logic [15:0] mem_din, mem_dout;

    logic [15:0] fc1_weight_data, fc1_bias_data;
    logic [15:0] fc2_weight_data, fc2_bias_data;
    logic [15:0] fc3_weight_data, fc3_bias_data;
    logic [14:0] fc1_weight_addr, fc1_bias_addr;
    logic [14:0] fc2_weight_addr, fc2_bias_addr;
    logic [14:0] fc3_weight_addr, fc3_bias_addr;

    
    // Delay counters for memory reads
    logic [1:0] weight_delay_counter;
    logic [1:0] bias_delay_counter;
    logic weight_delay_active;
    logic bias_delay_active;
    
    // BRAM instances: unchanged
    blk_mem_fcl1_weight fc1_w (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b0),
        .addra(fc1_weight_addr),
        .dina(16'b0),
        .douta(fc1_weight_data)
    );
    
    blk_mem_fc1_bias fc1_b (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b0),
        .addra(fc1_bias_addr),
        .dina(16'b0),
        .douta(fc1_bias_data)
    );

    blk_mem_fc2_weight fc2_w (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b0),
        .addra(fc2_weight_addr),
        .dina(16'b0),
        .douta(fc2_weight_data)
    );
    
    blk_mem_fc2_bias fc2_b (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b0),
        .addra(fc2_bias_addr),
        .dina(16'b0),
        .douta(fc2_bias_data)
    );

    blk_mem_fc3_weight fc3_w (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b0),
        .addra(fc3_weight_addr),
        .dina(16'b0),
        .douta(fc3_weight_data)
    );
    
    blk_mem_fc3_bias fc3_b (
        .clka(clk),
        .ena(1'b1),
        .wea(1'b0),
        .addra(fc3_bias_addr),
        .dina(16'b0),
        .douta(fc3_bias_data)
    );
    //initiate one_hot_encoder
    logic [15:0] one_hot_in [LAYER_3_NEURON_COUNT-1:0];  
    logic [LAYER_3_NEURON_COUNT-1:0] one_hot_out;

    one_hot_encode #(
        .N(LAYER_3_NEURON_COUNT)
    )one_hot(
    .inputs(one_hot_in),
    .outputs(one_hot_out)
    );
    //accel logic
    logic [15:0] layer0_outputs [LAYER_0_NEURON_COUNT-1:0];  
    logic [15:0] layer1_outputs [LAYER_1_NEURON_COUNT-1:0];
    logic [15:0] layer2_outputs [LAYER_2_NEURON_COUNT-1:0];
    logic [15:0] layer3_outputs [LAYER_3_NEURON_COUNT-1:0];
    
    // Accelerator interface
    logic [15:0] accel_inputs  [ACCEL_IN_DIM-1:0];
    logic [15:0] accel_weights [ACCEL_IN_DIM*ACCEL_OUT_DIM-1:0];
    logic [15:0] accel_biases  [ACCEL_OUT_DIM-1:0];
    logic [15:0] accel_out     [ACCEL_OUT_DIM-1:0];
    logic        accel_done;
    logic        start_accel;
    logic find_max_waiting;
    
    // Instantiate accelerator
    accelerator_piped #(
        .INPUT_NEURON_COUNT(ACCEL_IN_DIM),
        .OUTPUT_NEURON_COUNT(ACCEL_OUT_DIM),
        .MAX_PARALLEL(ACCEL_IN_DIM)
    ) accelerator (
        .clk(clk),
        .rst(rst),
        .start(start_accel),
        .inputs(accel_inputs),
        .weights(accel_weights),
        .biases(accel_biases),
        .out(accel_out),
        .done(accel_done)
    );
    
    logic [$clog2(LAYER_0_NEURON_COUNT)-1:0] input_idx;
    logic [$clog2(LAYER_1_NEURON_COUNT/ACCEL_OUT_DIM):0] layer1_batch_idx; 
    logic [$clog2(LAYER_2_NEURON_COUNT/ACCEL_OUT_DIM):0] layer2_batch_idx;
    logic [$clog2(LAYER_3_NEURON_COUNT/ACCEL_OUT_DIM):0] layer3_batch_idx;
    
    logic [$clog2(ACCEL_IN_DIM*ACCEL_OUT_DIM)-1:0] weight_load_idx;
    logic [$clog2(ACCEL_OUT_DIM)-1:0] bias_load_idx;
    
    logic [15:0] max_value;
    logic [3:0] max_index;
    logic [3:0] compare_idx;
    
    // Next state logic remains unchanged
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (btns_debounced) next_state = LOAD_INPUTS;
            end
            LOAD_INPUTS: begin
                if (input_idx >= LAYER_0_NEURON_COUNT-1) next_state = LOAD_LAYER1_WEIGHTS;
            end
            LOAD_LAYER1_WEIGHTS: begin
                if (bias_load_idx >= ACCEL_OUT_DIM && !start_accel)
                    next_state = PROCESS_LAYER1;
            end
            PROCESS_LAYER1: begin
                if (accel_done) begin
                    if ((layer1_batch_idx + 1) * ACCEL_OUT_DIM < LAYER_1_NEURON_COUNT)
                        next_state = LOAD_LAYER1_WEIGHTS;
                    else
                        next_state = LOAD_LAYER2_WEIGHTS;
                end
            end
            LOAD_LAYER2_WEIGHTS: begin
                if (bias_load_idx >= ACCEL_OUT_DIM && !start_accel)
                    next_state = PROCESS_LAYER2;
            end
            PROCESS_LAYER2: begin
                if (accel_done) begin
                    if ((layer2_batch_idx + 1) * ACCEL_OUT_DIM < LAYER_2_NEURON_COUNT)
                        next_state = LOAD_LAYER2_WEIGHTS;
                    else
                        next_state = LOAD_LAYER3_WEIGHTS;
                end
            end
            LOAD_LAYER3_WEIGHTS: begin
                if (bias_load_idx >= ACCEL_OUT_DIM && !start_accel)
                    next_state = PROCESS_LAYER3;
            end
            PROCESS_LAYER3: begin
                if (accel_done) begin
                    if ((layer3_batch_idx + 1) * ACCEL_OUT_DIM < LAYER_3_NEURON_COUNT)
                        next_state = LOAD_LAYER3_WEIGHTS;
                    else
                        next_state = FIND_MAX;
                end
            end
            FIND_MAX: begin
                if (compare_idx >= LAYER_3_NEURON_COUNT) next_state = DONE;
            end
            DONE: begin
                if (!btns_debounced) next_state = IDLE;
            end
        endcase
    end
    
    // Main sequential block
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state     <= IDLE;
            input_idx         <= 0;
            layer1_batch_idx  <= 0;
            layer2_batch_idx  <= 0;
            layer3_batch_idx  <= 0;
            weight_load_idx   <= 0;
            bias_load_idx     <= 0;
            max_value         <= 0;
            max_index         <= 0;
            compare_idx       <= 0;
            prediction        <= 0;
            start_accel       <= 0;
            weight_delay_counter <= 0;
            bias_delay_counter <= 0;
            weight_delay_active <= 0;
            bias_delay_active <= 0;
            find_max_waiting <= 0;
        end else begin
            current_state <= next_state;
            
            // Handle delay counters
            if (weight_delay_active) begin
                if (weight_delay_counter < 2) begin  // Wait for 3 cycles (0,1,2)
                    weight_delay_counter <= weight_delay_counter + 1;
                end else begin
                    weight_delay_active <= 0;  // Delay complete
                end
            end
            
            if (bias_delay_active) begin
                if (bias_delay_counter < 2) begin  // Wait for 3 cycles (0,1,2)
                    bias_delay_counter <= bias_delay_counter + 1;
                end else begin
                    bias_delay_active <= 0;  // Delay complete
                end
            end
            
            case (current_state)
                IDLE: begin
                    if (btns_debounced) begin
                        input_idx       <= 0;
                        layer1_batch_idx<= 0;
                        layer2_batch_idx<= 0;
                        layer3_batch_idx<= 0;
                        weight_load_idx <= 0;
                        bias_load_idx   <= 0;
                        max_value       <= 0;
                        max_index       <= 0;
                        compare_idx     <= 0;
                    end
                end
                LOAD_INPUTS: begin
                    if (!mem_we) begin 
                        layer0_outputs[input_idx] <= mem_dout;
                        input_idx <= input_idx + 1;
                    end
                end
                
                // Modified LOAD_LAYER1_WEIGHTS with delay
                LOAD_LAYER1_WEIGHTS: begin
                    if (weight_load_idx < ACCEL_IN_DIM * ACCEL_OUT_DIM) begin
                        if (!weight_delay_active) begin
                            // Set address and start delay
                            fc1_weight_addr <= layer1_batch_idx * ACCEL_OUT_DIM * LAYER_0_NEURON_COUNT + weight_load_idx;
                            weight_delay_active <= 1;
                            weight_delay_counter <= 0;
                        end else if (weight_delay_counter == 2) begin
                            // After delay, capture data and move to next
                            accel_weights[weight_load_idx] <= fc1_weight_data;
                            weight_load_idx <= weight_load_idx + 1;
                        end
                    end else if (bias_load_idx < ACCEL_OUT_DIM) begin
                        if (!bias_delay_active) begin
                            // Set address and start delay
                            fc1_bias_addr <= layer1_batch_idx * ACCEL_OUT_DIM + bias_load_idx;
                            bias_delay_active <= 1;
                            bias_delay_counter <= 0;
                        end else if (bias_delay_counter == 2) begin
                            // After delay, capture data and move to next
                            accel_biases[bias_load_idx] <= fc1_bias_data;
                            bias_load_idx <= bias_load_idx + 1;
                        end
                    end else begin
                        // Load inputs for accelerator from layer0 outputs
                        for (int i = 0; i < ACCEL_IN_DIM; i++) begin
                            if (i < LAYER_0_NEURON_COUNT)
                                accel_inputs[i] <= input_data[i];
                            else
                                accel_inputs[i] <= 16'h0000; 
                        end
                        start_accel <= 1;
                        weight_load_idx <= 0;
                        bias_load_idx <= 0;
                    end
                end
                
                PROCESS_LAYER1: begin
                    if (accel_done) begin
                        start_accel <= 0;
                        for (int i = 0; i < ACCEL_OUT_DIM; i++) begin
                            if (layer1_batch_idx * ACCEL_OUT_DIM + i < LAYER_1_NEURON_COUNT)
                                layer1_outputs[layer1_batch_idx * ACCEL_OUT_DIM + i] <= accel_out[i];
                        end
                        if (next_state == LOAD_LAYER1_WEIGHTS)
                            layer1_batch_idx <= layer1_batch_idx + 1;
                    end
                end
                
                // Modified LOAD_LAYER2_WEIGHTS with delay
                LOAD_LAYER2_WEIGHTS: begin
                    if (weight_load_idx < ACCEL_IN_DIM * ACCEL_OUT_DIM) begin
                        if (!weight_delay_active) begin
                            // Set address and start delay
                            fc2_weight_addr <= layer2_batch_idx * ACCEL_OUT_DIM * LAYER_1_NEURON_COUNT + weight_load_idx;
                            weight_delay_active <= 1;
                            weight_delay_counter <= 0;
                        end else if (weight_delay_counter == 2) begin
                            // After delay, capture data and move to next
                            accel_weights[weight_load_idx] <= fc2_weight_data;
                            weight_load_idx <= weight_load_idx + 1;
                        end
                    end else if (bias_load_idx < ACCEL_OUT_DIM) begin
                        if (!bias_delay_active) begin
                            // Set address and start delay
                            fc2_bias_addr <= layer2_batch_idx * ACCEL_OUT_DIM + bias_load_idx;
                            bias_delay_active <= 1;
                            bias_delay_counter <= 0;
                        end else if (bias_delay_counter == 2) begin
                            // After delay, capture data and move to next
                            accel_biases[bias_load_idx] <= fc2_bias_data;
                            bias_load_idx <= bias_load_idx + 1;
                        end
                    end else begin
                        for (int i = 0; i < ACCEL_IN_DIM; i++) begin
                            if (i < LAYER_1_NEURON_COUNT)
                                accel_inputs[i] <= layer1_outputs[i];
                            else
                                accel_inputs[i] <= 16'h0000; 
                        end
                        start_accel <= 1;
                        weight_load_idx <= 0;
                        bias_load_idx <= 0;
                    end
                end
                
                PROCESS_LAYER2: begin
                    if (accel_done) begin
                        start_accel <= 0;
                        for (int i = 0; i < ACCEL_OUT_DIM; i++) begin
                            if (layer2_batch_idx * ACCEL_OUT_DIM + i < LAYER_2_NEURON_COUNT)
                                layer2_outputs[layer2_batch_idx * ACCEL_OUT_DIM + i] <= accel_out[i];
                        end
                        if (next_state == LOAD_LAYER2_WEIGHTS) begin
                            layer2_batch_idx <= layer2_batch_idx + 1;
                        end
                    end
                end
                
                // Modified LOAD_LAYER3_WEIGHTS with delay
                LOAD_LAYER3_WEIGHTS: begin
                    if (weight_load_idx < ACCEL_IN_DIM * ACCEL_OUT_DIM) begin
                        if (!weight_delay_active) begin
                            // Set address and start delay
                            fc3_weight_addr <= layer3_batch_idx * ACCEL_OUT_DIM * LAYER_2_NEURON_COUNT + weight_load_idx;
                            weight_delay_active <= 1;
                            weight_delay_counter <= 0;
                        end else if (weight_delay_counter == 2) begin
                            // After delay, capture data and move to next
                            accel_weights[weight_load_idx] <= fc3_weight_data;
                            weight_load_idx <= weight_load_idx + 1;
                        end
                    end else if (bias_load_idx < ACCEL_OUT_DIM) begin
                        if (!bias_delay_active) begin
                            // Set address and start delay
                            fc3_bias_addr <= layer3_batch_idx * ACCEL_OUT_DIM + bias_load_idx;
                            bias_delay_active <= 1;
                            bias_delay_counter <= 0;
                        end else if (bias_delay_counter == 2) begin
                            // After delay, capture data and move to next
                            accel_biases[bias_load_idx] <= fc3_bias_data;
                            bias_load_idx <= bias_load_idx + 1;
                        end
                    end else begin
                        for (int i = 0; i < ACCEL_IN_DIM; i++) begin
                            if (i < LAYER_2_NEURON_COUNT)
                                accel_inputs[i] <= layer2_outputs[i];
                            else
                                accel_inputs[i] <= 16'h0000; 
                        end
                        start_accel <= 1;
                        weight_load_idx <= 0;
                        bias_load_idx <= 0;
                    end
                end
                
                PROCESS_LAYER3: begin
                    if (accel_done) begin
                        start_accel <= 0;
                        for (int i = 0; i < ACCEL_OUT_DIM; i++) begin
                            if (layer3_batch_idx * ACCEL_OUT_DIM + i < LAYER_3_NEURON_COUNT)
                                layer3_outputs[layer3_batch_idx * ACCEL_OUT_DIM + i] <= accel_out[i];
                        end
                        if (next_state == LOAD_LAYER3_WEIGHTS)
                            layer3_batch_idx <= layer3_batch_idx + 1;
                        else if (next_state == FIND_MAX) begin
                            max_value <= layer3_outputs[0];
                            max_index <= 0;
                            compare_idx <= 1;
                        end
                    end
                end
                
                FIND_MAX: begin
                    if (!find_max_waiting) begin
                        one_hot_in <= layer3_outputs;
                        find_max_waiting <= 1;
                    end 
                    else begin
                        // After one cycle delay, capture the one-hot encoded output
                        prediction <= one_hot_out;
                        compare_idx <= LAYER_3_NEURON_COUNT;  // This will trigger transition to DONE
                    end
                end
                       
                
                DONE: begin
                    // Remain in done state
                end
            endcase
        end
    end
    
    // Memory control logic
    always_comb begin
        mem_we  = 0; 
        mem_din = 0; 
        case (current_state)
            IDLE:         mem_addr = 0;
            LOAD_INPUTS:  mem_addr = input_idx;
            default:      mem_addr = 0;
        endcase
    end
endmodule
