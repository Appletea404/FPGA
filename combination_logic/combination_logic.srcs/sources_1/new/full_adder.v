`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2026 11:50:36 AM
// Design Name: 
// Module Name: full_adder
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


module full_adder_behavioral(
    input a, b, cin,
    output reg sum, carry
    );
    always @(a, b, cin) begin
        case({a, b, cin})
            3'b000 : begin sum = 0; carry = 0; end
            3'b001 : begin sum = 1; carry = 0; end
            3'b010 : begin sum = 1; carry = 0; end
            3'b011 : begin sum = 0; carry = 1; end
            3'b100 : begin sum = 1; carry = 0; end
            3'b101 : begin sum = 0; carry = 1; end
            3'b110 : begin sum = 0; carry = 1; end
            3'b111 : begin sum = 1; carry = 1; end

        endcase
    end
endmodule


module full_adder_structural (
    input a, b, cin,
    output sum, carry
);

    wire sum_0;         // 첫번째 반가산기의 합 출력
    wire carry_0;       // 첫번째 반가산기의 자리올림 출력 
    wire carry_1;       // 두번째 반가산기의 자리올림 출력
    
    // 첫번째 반가산기 : 입력 a, b를 더함
    // sum_0에 중간합이 저장되고 carry_0에 자리올림
    half_adder_structural ha0(
        .A(a),
        .B(b),
        .s(sum_0),
        .c(carry_0)
    );
    
    // 두번째 반가산기 : sum_0하고 cin 더함
    half_adder_structural ha1(
        .A(sum_0),
        .B(cin),
        .s(sum),
        .c(carry_1)
    );
    
    or (carry, carry_0, carry_1);
    
endmodule




module full_adder_dataflow(
    input a, b, cin,
    output sum, carry
    );
    
    wire[1:0] sum_value;
    
    // 3개의 입력을 더한 결과를 sum_value에 저장
    assign sum_value = a + b + cin;
    
    // sum_value의 하위비트가 sum, 상위가 carry
    assign sum = sum_value[0];
    assign carry = sum_value[1];
endmodule


module fadder_4bit_dataflow(
    input [3:0] a,b,
    input cin,
    output [3:0] sum,
    output carry 
    
);

    wire [4:0] sum_value;
    
    assign sum_value = a + b + cin;
    
    assign sum = sum_value[3:0];
    assign carry = sum_value[4];
    
    

endmodule

module fadder_4bit_structural(
    input [3:0] a,b,        // 4bit input
    input cin,              // first place carry in
    output [3:0] sum,       // 4bit sum
    output carry            // end carry
    
);

    wire [2:0] carry_w;     // 내부적인 전가산기 간의 연결
    
    // 첫번째 비트 -> cin과 계산
    full_adder_structural fa0(
        .a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry(carry_w[0])
    );
    full_adder_structural fa1(
        .a(a[1]), .b(b[1]), .cin(carry_w[0]), .sum(sum[1]), .carry(carry_w[1])
    );
    full_adder_structural fa2(
        .a(a[2]), .b(b[2]), .cin(carry_w[1]), .sum(sum[2]), .carry(carry_w[2])
    );
    full_adder_structural fa3(
        .a(a[3]), .b(b[3]), .cin(carry_w[2]), .sum(sum[3]), .carry(carry)
    );
    
endmodule

// N-bit Ripple Carry Adder
// full adder를 N개 연결해서 N비트 덧셈
// parameter 를 이용

module n_bit_adder_structural #(
    parameter N = 8        //기본 비트수
)(            
    input [N-1 : 0] a, b,   // N비트 입력수
    input cin,              // 초기 캐리(LSB << 여기에서 올라옴)
    output [N-1:0] sum,     // N비트 합
    output carry

);
    // carry_w[0] : 외부입력 -> cin
    // carry_w[1] : 첫번째 full_adder의 출력 carry
    // ...
    // carry_w[N] : 마지막 full_adder 의 출력 (최종 carry)
    
    wire [N:0] carry_w;
    
    assign carry_w[0] = cin;        // 첫번째 시작점
    assign carry = carry_w[N];      // 마지막 full_adder carry이 최종 carry
    
    genvar i;                       //generate 구문에서 사용할 반복 변수
    
    generate
        for (i = 0; i < N; i = i + 1) begin : fa_loop
            full_adder_structural fa(
                .a(a[i]),           // i번째 비트 입력 a
                .b(b[i]),           // i번째 비트 입력 b
                .cin(carry_w[i]),   // 이전단계에서 넘겨온 carry
                .sum(sum[i]),       // i번째 비트 결과
                .carry(carry_w[i+1])    //다음 단계로 전달할 carry
                 
            );
        
        end
    endgenerate
endmodule