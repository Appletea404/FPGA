`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 11:33:58 AM
// Design Name: 
// Module Name: tb_shift_register_PISO
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


module tb_shift_register_PISO;
    reg clk;
    reg reset_p;
    reg [3:0] d;
    reg shift_load;
    wire q;

    shift_register_PISO uut(
        .clk(clk), 
        .reset_p(reset_p), 
        .d(d), 
        .shift_load(shift_load), 
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_p = 1;
        d = 4'b0000;
        shift_load = 0;
        
        // 1. 리셋 해제
        #15 reset_p = 0;
        
        // 2. 데이터 준비 및 로드 (shift_load = 0)
        // 클럭의 하강 엣지에서 신호를 주면 상승 엣지에서 안정적으로 입력됨
        @(negedge clk);
        d = 4'b1011;
        shift_load = 0; 

        // 3. 한 클럭 동안 로드 상태 유지
        @(negedge clk);
        
        // 4. 시프트 모드 전환 (shift_load = 1)
        shift_load = 1;
        
        // 5. 4번 이상의 클럭 대기 (데이터가 하나씩 빠져나가는 것 확인)
        repeat (5) @(negedge clk);

        // 6. 새로운 데이터 로드 테스트 (선택 사항)
        d = 4'b1100;
        shift_load = 0;
        @(negedge clk);
        shift_load = 1;
        repeat (5) @(negedge clk);

        $finish;

        $finish;
    end
endmodule


module tb_register_Nbit_p;
    parameter N = 8;

    reg clk;
    reg reset_p;
    reg [N-1:0] d;
    reg wr_en;
    reg rd_en;
    wire [N-1:0] register_data;
    wire [N-1:0] q;

    register_Nbit_p #(N) uut(
        .clk(clk), .reset_p(reset_p), .d(d),
        .wr_en(wr_en), .rd_en(rd_en), .register_data(register_data), .q(q)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        reset_p = 1;
        wr_en = 0;
        rd_en = 0;
        d = 0;

        #25 reset_p = 0;

        #20 d = 8'h3c;  wr_en = 1;
        #20 wr_en = 0;

        #20 rd_en = 1;
        #40;

        #20 rd_en = 0;
        #20;

        $finish;
    end

endmodule


module tb_memory;
    reg clk;
    reg reset_p;
    reg [7:0] i_data;
    reg [9:0] wr_addr;
    reg [9:0] rd_addr;
    wire [7:0] o_data;
    
    memory uut(
        .clk(clk), .reset_p(reset_p), .i_data(i_data), .wr_addr(wr_addr),
        .rd_addr(rd_addr), .o_data(o_data)
    );

    always #5 clk = ~clk;

    integer i, j;

    initial begin
        clk = 0;
        reset_p = 0;
        i_data = 0;
        wr_addr = 0;
        rd_addr = 0;

        #10 reset_p = 1; #10 reset_p = 0;

        $display("--- 쓰기 동작 시작 ---");
        for (i = 0; i < 10 ; i = i + 1) begin
            @(posedge clk);
            wr_addr = i;            // 주소 0, 1, 2......
            i_data = i + 10;        // 데이터는 10, 11, 12....
        end

        @(posedge clk);
        wr_addr = 0;
        i_data = 0;

        $display("--- 읽기 동작 시작 ---");
        for (j = 0; j < 10 ; j = j + 1 ) begin
            @(posedge clk);
            rd_addr = j;

            @(posedge clk);
            $display("Addr : %d, Data : %d",j, o_data);
        end
        #50 $finish;
    end
endmodule

