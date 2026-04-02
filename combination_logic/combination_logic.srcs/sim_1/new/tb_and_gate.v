`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 11:11:37 AM
// Design Name: 
// Module Name: tb_and_gate
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


module tb_and_gate;
    reg a, b;
    wire q;
    
//    and_gate uut(.a(a), .b(b), .q(q));
    and_gate_structual uut(.a(a), .b(b), .q(q));
//    and_gate_dataflow uut(.a(a), .b(b), .q(q));
//    and_gate_behavioral uut(.a(a), .b(b), .q(q));

    initial begin
        // test vector
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;
        $finish;
    end 
endmodule
