`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2026 09:54:11 AM
// Design Name: 
// Module Name: half_adder
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


module half_adder(
    input a,                // 1비트 입력 a
    input b,                // 1비트 입력 b
    output reg sum,         // 합(sum)을 저장할 레지스터 타입 출력
    output reg carry        // 자리올림(carry)를 저장할 레지스터 타입 출력 
    );
    
    // a 또는 b에 변화가 생길 때마다 always 블록 실행
    always @(a, b) begin
        case({a, b})        // 입력 a, b를 묶어서 2비트 벡터로 판단
            2'b00 : begin
                sum = 0;
                carry = 0;
            end
            2'b01 : begin
                sum = 1;
                carry = 0;
            end
            2'b10 : begin
                sum = 1;
                carry = 0;
            end
            2'b11 : begin
                sum = 0;
                carry = 1;
            end
            
        endcase             
    end                     

endmodule


module half_adder_structural (
    input A,
    input B,
    output s,
    output c
);

    and (c, A, B);
    xor (s, A, B);
endmodule


module half_adder_dataflow (
    input A,
    input B,
    output S,
    output C
);
    // a와 b의 합을 저장 2비트 와이어
    // 최대값이 1 + 1 = 2 (2'b10) 이므로 2비트가 필요
    wire [1 : 0] sum_value;

    // verilog의 '+' 연산자는 벡터를 생성해서 결과를 sum_value에 저장
    assign sum_value = A + B;


    // sum_value의 LSBdls sum_value[0]를 할당
    assign S = sum_value[0];        // 합

    assign C = sum_value[1];        // 자리올림
endmodule