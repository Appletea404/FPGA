`timescale 1ns / 1ps


module tb_fadder_4bits();

    reg [3:0] A, B;
    reg carry_in;
    wire [3:0] sum; 
    wire carry;
    
    fadder_4bit_dataflow DUT(A,B,carry_in,sum,carry);
    
    initial begin
        A = 0;
        B = 0;
        carry_in = 0;
    end
    
    integer i, j, k;
    initial begin
        for (k = 0; k < 2; k = k + 1) begin
            for(i = 0; i < 16; i = i+1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    carry_in = k;
                    A = i;
                    B = j;
                    #10;
                    if(A+B+carry_in != sum) $display ("error");
//                    $display("%d + %d + %d = %d", A, B, carry_in, sum);
                end
            
            end
        end
            
            $finish;
    end

endmodule
