`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2026 10:14:54 AM
// Design Name: 
// Module Name: tb_half_adder
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


module tb_half_adder;
    reg a, b;
    wire sum, carry;

    // DUT(Design Under Test) 인스턴스 생성
//    half_adder uut(
//        .a(a),
//        .b(b),
//        .sum(sum),
//        .carry(carry)
//    );
    
//    half_adder_structural uut(
//        .A(a),
//        .B(b),
//        .s(sum),
//        .c(carry)
//    );
    
    half_adder_dataflow uut(
        .A(a),
        .B(b),
        .S(sum),
        .C(carry)
    );
    
    
    initial begin
        $display("Time\ta b | sum carry");
        $monitor("%4t\t%b %b | %b %b", $time, a, b, sum, carry);
        //입력값 변화 
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        
        $finish;
     end
    
   
endmodule
