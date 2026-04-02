`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2026 11:49:01 AM
// Design Name: 
// Module Name: tb_comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_comparator;

    reg a,b;
    wire equal, greater, less;
    
    comparator_dataflow uud(
        .a(a),
        .b(b),
        .equal(equal),
        .greater(greater),
        .less(less)
    );


    initial begin
        a = 0; b = 0; #10;  
        a = 0; b = 1; #10;  
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
    end

endmodule


module tb_comparator_4bit_full;

    reg [3:0] a, b;
    wire equal, greater, less;
    
    comparator_Nbit #(.N(4)) dut(
        .a(a),
        .b(b),
        .equal(equal),
        .greater(greater),
        .less(less)
        
    );
    
    integer i, j;
    
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                #5;
                
            end
        
        end
        $finish;

    end
    
endmodule
