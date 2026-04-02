`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2026 02:27:13 PM
// Design Name: 
// Module Name: tb_coder
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


module tb_encoder_4_2;

    reg [3 : 0] signal;
    wire [1 : 0] code;
    
    encoder_4_2 uut(
        .signal(signal),
        .code(code)
    );
    
    initial begin
        signal = 4'b0000;
        
        #10 signal = 4'b0001;
        #10 signal = 4'b0010;
        #10 signal = 4'b0100;
        #10 signal = 4'b1000;
        
        #10 signal = 4'b0000;
        #10 signal = 4'b0011;


        #10 $finish;
    
    end

endmodule


module tb_decoder_2_4;

    reg [1 : 0] code;
    wire [3 : 0] signal;
    
    decoder_2_4 uut(
         .code(code),
        .signal(signal)
    );
    
    initial begin
    
        #10 code = 2'b00;  // 00 입력 -> signal은 4'b0001 예상
        #10 code = 2'b01;  // 01 입력 -> signal은 4'b0010 예상
        #10 code = 2'b10;  // 10 입력 -> signal은 4'b0100 예상
        #10 code = 2'b11;
       
        #10 code = 2'b00; 

        #10 $finish;
    
    end

endmodule
