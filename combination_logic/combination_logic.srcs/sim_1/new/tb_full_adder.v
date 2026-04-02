`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2026 11:58:23 AM
// Design Name: 
// Module Name: tb_full_adder
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





module tb_full_adder;
    reg a, b, cin;
    wire sum, carry;


//    full_adder_behavioral uut(
//        .a(a),
//        .b(b),
//        .cin(cin),
//        .sum(sum),
//        .carry(carry)
//    );
    
    full_adder_structural uut(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .carry(carry)
    );
    
    
    initial begin
        $display("Time\ta b | sum carry");
        $monitor("%4t\t%b %b %b | %b %b", $time, a, b, cin, sum, carry);
        
        
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;


        
        $finish;
     end
    
   
endmodule




module tb_fadder_4bit_structural;

    // 입, 출력 신호를 선언
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire carry;
    
    fadder_4bit_structural uut(
        .a(a), .b(b), .cin(cin), .sum(sum), .carry(carry)
    
    );
    
    initial begin
        
        //테스트벡터
        cin = 0; a = 4'b0000; b = 4'b0000; #10;
        cin = 0; a = 4'b0001; b = 4'b0001; #10;
        cin = 1; a = 4'b0010; b = 4'b0011; #10;
        cin = 0; a = 4'b1111; b = 4'b0001; #10;
        cin = 1; a = 4'b1010; b = 4'b0101; #10;
        cin = 0; a = 4'b1111; b = 4'b1111; #10;
        cin = 1; a = 4'b1111; b = 4'b1111; #10;
        
        #10 $finish;

        
    end
    


endmodule


// N-bit fadder testbench

module tb_n_bit_adder;
    
    // 파라미터 맞춰야함
    parameter N = 8;

    reg [N-1 : 0] a, b;
    reg cin;
    wire [N-1 : 0] sum;
    wire carry;
    
    n_bit_adder_structural #(.N(N)) uut(
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .carry(carry)
    );
    
    initial begin
        // 초기값
        a = 0; b = 0; cin = 0;
        #10;                     //10ns 이후에
        
        // 100 + 50 = 150
        a = 8'd100; b = 8'd50; cin = 0;
        #10;
        
        // 200 + 100 -> 오버플로우
        a = 8'd200; b = 8'd100; cin = 0;
        #10;
        
        // 모든 비트가 1일때(최대값)
        a = {N{1'b1}};  // N비트를 모두 1로 채움
        b = {N{1'b1}};
        cin = 1;
        #10;
        
        repeat (5) begin
            #10;
            a = $random;
            b = $random;
            cin = $random % 2;
        end
        
        #20;
        $finish;
        
        
    end
    
endmodule