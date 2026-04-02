`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 03:57:33 PM
// Design Name: 
// Module Name: gates
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


module gates(
    input a, b,
    output q0, q1, q2, q3, q4, q5, q6
    );
    
    assign q0 = ~a;         //NOT
    assign q1 = a & b;      //AND
    assign q2 = a | b;      //OR
    assign q3 = ~(a & b);   //NAND
    assign q4 = ~(a | b);   //NOR
    assign q5 = a ^ b;      //XOR
    assign q6 = ~(a ^ b);    //XNOR
endmodule
