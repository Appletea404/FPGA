`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2026 02:13:34 PM
// Design Name: 
// Module Name: coder
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


module coder(

    );
endmodule



module encoder_4_2 (
    input [3 : 0] signal,       // 4개의 신호중에 1개를 1이라고 가정
    output reg [1 : 0] code     // 2비트 출력 : 입력 중에 켜진 위치를 이진수로 출력
    );
    
    always @(signal) begin
        case (signal)
            4'b0001 : code = 2'b00;         // 0번째 입력 활성화
            4'b0010 : code = 2'b01;         // 1번째 입력 활성화
            4'b0100 : code = 2'b10;         // 2번째 입력 활성화
            4'b1000 : code = 2'b11;         // 3번째 입력 활성화
            default : code = 2'b00;         // 예외의 경우 기본값 설정 
            
        endcase
    end
//     always @(signal) begin
//        if(signal == 4'b0001)
//            code = 2'b00;
//        else if(signal == 4'b0010)
//            code = 2'b01;
//        else if(signal == 4'b0100)
//            code = 2'b10;
//        else if(signal == 4'b1000)
//            code = 2'b11;
//     end  
    
    
endmodule



module decoder_2_4 (
    input [1 : 0] code,
    output [3 : 0] signal
    );
    
    assign signal = (code == 2'b00) ? 4'b0001 :
                    (code == 2'b01) ? 4'b0010 :
                    (code == 2'b10) ? 4'b0100 : 4'b1000;

    
    
    
endmodule


module decoder_7seg (
    input [3:0] hex_value,
    output reg [7:0] seg_7,
    output [3:0] com_an
);

    assign com_an = 4'b0110;           // 켜주고 싶은곳에


    always @(hex_value) begin
        
        case (hex_value)
            4'd0 : seg_7 = 8'b11000000;     // 0
            4'd1 : seg_7 = 8'b11111001;     // 1
            4'd2 : seg_7 = 8'b10100100;     // 2
            4'd3 : seg_7 = 8'b10110000;     // 3
            4'd4 : seg_7 = 8'b10011001;     // 4
            4'd5 : seg_7 = 8'b10010010;     // 5
            4'd6 : seg_7 = 8'b10000010;     // 6
            4'd7 : seg_7 = 8'b11111000;     // 7
            4'd8 : seg_7 = 8'b10000000;     // 8
            4'd9 : seg_7 = 8'b10011000;     // 9
            4'd10 : seg_7 = 8'b10001000;     // A
            4'd11 : seg_7 = 8'b10000011;     // B
            4'd12 : seg_7 = 8'b11000110;     // C
            4'd13 : seg_7 = 8'b10100001;     // D
            4'd14 : seg_7 = 8'b10000110;     // E
            4'd15 : seg_7 = 8'b10001110;     // F
        endcase
    end
    
endmodule