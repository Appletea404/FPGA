`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2026 10:44:39 AM
// Design Name: 
// Module Name: and_gate
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


// Behavioral Modeling
// 동작적 모델링 -> 사람이 무엇을 할건지 코드로 표현
// -> 하드웨어 동작을 if, case, for 등 알고리즘 중심으로 기술
// -> always 블록 사용 -> 주로 상위레벨 기능이나 복잡한 제어에 사용
// -> 설계하기는 쉬움 복잡한 로직가능
// -> RTL 시뮬레이션을 가능하나 실제 구조파악은 어려움
module and_gate(            // module 은 입출력 포트가 있는 회로를 정의 
    input a, b,             // ()안에는 입출력 포트의 목록이 들어감, 실제 IO처럼 동작
    output reg q
    );
    
    always @(a, b) begin
        case({a, b})
            2'b00 : q = 0;
            2'b01 : q = 0;
            2'b10 : q = 0;
            2'b11 : q = 1;
        endcase
    end
    
endmodule


// Behavioral Modeling
// 입력 a, b의 AND 연산 결과를 출력 q에 저장
module and_gate_behavioral(
    input a, b,           // 두 개의 입력 신호 a, b
    output reg q);          // 출력 신호 q (레지스터 타입)
    
    // a 또는 b 중 하나라도 값이 변경되면 항상 블록 실행
    always @(a or b) begin
        // a와 b가 모두 1이면 q에 1 저장
        if (a == 1'b1 && b == 1'b1)
            q = 1'b1;
        // 그렇지 않으면 q에 0 저장
        else
            q = 1'b0;
    end
    

endmodule

// Structual Modeling

module and_gate_structual(
    input a, b,
    output q);    //wire type이여야 함
    
    and U1(q, a, b);  // and gate 인스턴스 생성 
endmodule


// Dataflow Modeling

module and_gate_dataflow(
    input a, b,
    output q);
    
    // assign 문을 활용 AND연산 결과를 Q에 연결!!
    assign q = a & b;
endmodule


