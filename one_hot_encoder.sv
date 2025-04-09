module one_hot_encode #(
  parameter N = 10  // Default width parameter
)(
    input logic [15:0] inputs[0:N-1],
    output logic [N-1:0] outputs  //little endian so 0010 is 1.
);
integer i;
reg [15:0] max_val;
integer max_idx;
//float comparison
function is_greater;
  input [15:0] a, b;

  reg sign_a, sign_b;
  reg [4:0] exp_a, exp_b;
  reg [9:0] frac_a, frac_b;

  begin
    sign_a = a[15];
    sign_b = b[15];
    exp_a  = a[14:10];
    exp_b  = b[14:10];
    frac_a = a[9:0];
    frac_b = b[9:0];

    // Handle special case: a == b
    if (a == b) begin
      is_greater = 0;
    end
    // a is positive, b is negative ? a > b
    else if (sign_a == 0 && sign_b == 1) begin
      is_greater = 1;
    end
    // a is negative, b is positive ? a < b
    else if (sign_a == 1 && sign_b == 0) begin
      is_greater = 0;
    end
    // both positive
    else if (sign_a == 0 && sign_b == 0) begin
      if (exp_a > exp_b) is_greater = 1;
      else if (exp_a < exp_b) is_greater = 0;
      else is_greater = (frac_a > frac_b);
    end
    // both negative ? reverse comparison
    else begin
      if (exp_a < exp_b) is_greater = 1;
      else if (exp_a > exp_b) is_greater = 0;
      else is_greater = (frac_a < frac_b);
    end
  end
endfunction

always @(*) begin
    max_val = inputs[0];
    max_idx=0;
    for(i=1;i<N;i=i+1)begin
        if (is_greater(inputs[i], max_val))begin
            max_val=inputs[i];
            max_idx = i;
        end
    end

    outputs={N{1'b0}};
    outputs[max_idx]=1'b1;
end 

endmodule
