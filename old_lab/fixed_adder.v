`timescale 1ns / 1ps


module fixed_adder_par #(
    parameter int WIDTH = 32 ,
    parameter int acc_width = 34
) (
    input  logic [acc_width-1:0] acc,  
    input  logic [WIDTH-1:0]   a,    
    output logic [acc_width-1:0] sum   
);


    logic [WIDTH-1:0] no_signbit_a;
    logic [acc_width-1:0] no_signbit_acc;
    logic a_sign; 
    logic acc_sign = 0;
    logic  [WIDTH-1:0] a_neg;
    logic  [WIDTH-1:0] a_pos;




    always_comb begin
        if(a[WIDTH-1] == 1)
            a_sign = 1;
        else 
            a_sign = 0;
        if(acc[acc_width-1] == 1)
            acc_sign = 1;
        else 
            acc_sign = 0;    

        no_signbit_a = a & {0, a[WIDTH-2 : 0]};
        no_signbit_acc = acc & {0, acc[acc_width-2: 0]};
        if(no_signbit_a < no_signbit_acc || no_signbit_a == no_signbit_acc) begin
            if((a_sign == 0 && acc_sign == 0) || (a_sign == 1 && acc_sign == 1)) begin
                a_pos = no_signbit_acc + no_signbit_a;
                sum = a_pos | (acc_sign << acc_width-1);
            
            end
            else if((a_sign == 0 && acc_sign == 1) || (a_sign == 1 && acc_sign == 0)) begin
                a_neg = no_signbit_acc - no_signbit_a;
                sum = a_neg | (acc_sign << acc_width-1);
            
            end
        end
        else if (no_signbit_a > no_signbit_acc) begin          
            if((a_sign == 0 && acc_sign == 0) || (a_sign == 1 && acc_sign == 1)) begin
                a_pos = no_signbit_a + no_signbit_acc;
                sum = a_pos | (a_sign << acc_width-1);
            end
            else if((a_sign == 0 && acc_sign == 1) || (a_sign == 1 && acc_sign == 0)) begin
                a_neg = no_signbit_a - no_signbit_acc;
                sum = a_neg | (a_sign << acc_width-1);
            end
        end
    end

endmodule