`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2026 09:21:03 AM
// Design Name: 
// Module Name: mux
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


module mux_2_1(

    input [1:0] d,          // 입력 신호 2개
    input s,                // 선택 신호 1개
    output f
    );
    
    assign f = s ? d[1] : d[0];
    
endmodule


module mux_4_1 (
    input [3 : 0] d,      // 4개의 데이터 입력
    input [1 : 0] s,      // 2비트 선택 신호
    output reg f          // always 블록 사용을 위한 reg 선언
);

    always @(*) begin
        case (s)
            2'b00 : f = d[0];
            2'b01 : f = d[1];
            2'b10 : f = d[2];
            2'b11 : f = d[3];
//            default : f = 1'b0;
        endcase
    end

endmodule


module mux_8_1 (
    input [7 : 0] d,      
    input [2 : 0] s,      
    output f          
);

    assign f = d[s];
    
    

endmodule


// DEMUX
// 하나의 입력을 여러 출력장치중에 하나로 보내는 장치

module demux_1_2 (
    input in,
    input s,
    output reg [1:0] out
);


    always @(*) begin
        case (s)
            1'b0 : out = {1'b0, in};
            1'b1 : out = {in, 1'b0};    // MSB in, LSB 0
            default : out = 2'b00;      //x(Don't care) Z (high impedence)
        endcase       
    end
endmodule



module demux_1_4 (
    input d,
    input [1:0] s,
    output [3:0] f
);

    assign f = (s == 2'b00) ? {3'b000, d} : 
               (s == 2'b01) ? {2'b00, d, 1'b0} :
               (s == 2'b10) ? {1'b0, d, 2'b00} :
                              {d, 3'b000};
                              
//    assign f[0] = (s == 2'b00) ? d : 0;
//    assign f[1] = (s == 2'b01) ? d : 0;
//    assign f[2] = (s == 2'b10) ? d : 0;
//    assign f[3] = (s == 2'b11) ? d : 0;
    
    
endmodule


module mux_demux_test (
    input [3:0] d,
    input [1:0] mux_s,
    input [1:0] demux_s,
    output [3:0] f
);

    wire mux_f;
    
    mux_4_1 mux4(
        .d(d),
        .s(mux_s),
        .f(mux_f)
    );
    
    demux_1_4 demux4(
        .d(mux_f),
        .s(demux_s),
        .f(f)
    );
endmodule



module bin_to_bcd(

    input [11 : 0] bin,                          
    output reg [15 : 0] bcd
    );
    
    integer i;
    
    always @(bin) begin
        bcd = 0;
        
        
        for (i = 0; i < 12; i = i + 1) begin
        
            if (bcd[3:0] >= 5)              //1의 자리
                bcd[3:0] = bcd[3:0] + 3;
            if (bcd[7:4] >= 5)              //10의 자리
                bcd[7:4] = bcd[7:4] + 3;
            if (bcd[11:8] >= 5)              //100의 자리
                bcd[11:8] = bcd[11:8] + 3;
            if (bcd[15:12] >= 5)              //1000의 자리
                bcd[15:12] = bcd[15:12] + 3;
            
            bcd = {bcd[14:0], bin[11-i]};     
        end
        
    end
    
endmodule


