`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 11:25:48 AM
// Design Name: 
// Module Name: sequential_logic
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


module sequential_logic(

    );
endmodule

module shift_register_PISO (
    input clk,
    input reset_p,
    input [3:0] d,
    input shift_load,       // 0 -> load, 1 -> shift
    output q
);

    reg [3:0] piso_reg;

    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            piso_reg = 4'b0000;
        end else begin
            if (shift_load) begin
                piso_reg <= {1'b0, piso_reg[3:1]};  // MSB -> LSB
            end else begin
                piso_reg <= d;
            end
        end
    end

    assign q = piso_reg[0];
    
endmodule


module register_Nbit_p #(parameter N = 8)(
    input clk,
    input reset_p,
    input [N-1:0] d,                // N 비트 입력 데이터
    input wr_en,                    // 쓰기 활성화 신호
    input rd_en,                    // 읽기 활성화 신호
    output [N-1:0] register_data,   // 내부 레지스터값
    output [N-1:0] q                // 읽기 활성화시 출력 아니면 Z
);
    reg [N-1:0] register;           // 내부 N비트 레지스터

    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            register = {N{1'b0}};       // 0 <- 초기화
        end
        else if (wr_en) begin
            register = d;               // 쓰기 활성화시 입력 저장
        end
    end

    assign q = rd_en ? register : {N{1'bz}};    // rd_en 신호에 따라 출력 활성화 or z

    assign register_data = register;            // 레지스터값 항상 출력(읽기신호무관)
    
endmodule


module ring_counter_led_flag(
    input clk, reset_p,
    output reg [15:0] led);
    
    reg [31:0] clk_div;
    always @(posedge clk)clk_div = clk_div + 1;
    
    reg flag;
       
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
            led = 16'b0000_0000_0000_0001;
            flag = 0;
        end
        else begin
            if(clk_div[22] && flag == 0)begin
                led <= {led[14:0], led[15]};
                flag = 1;
            end
            if(clk_div[22] == 0)flag = 0;
        end
    end

endmodule


module memory (
    input clk,
    input reset_p,

    input [7:0] i_data,     // 입력 데이터
    input [9:0] wr_addr,    // write 주소
    input [9:0] rd_addr,    // read 주소

    output reg [7:0] o_data // 출력데이터
);

    reg [7:0] ram [0:1023];     // 1024 X 8bit RAM 선언

    always @(posedge clk) begin
        // write
        ram[wr_addr] <= i_data;
        //read
        o_data <= ram[rd_addr];
    end

endmodule



module memory_one_addr_bus (
    input clk,
    input reset_p,
    input [7:0] i_data,
    input wr_en,
    input [9:0] addr,

    output reg [7:0] o_data
);

    reg [7:0] ram [0:1023];

    always @(posedge clk) begin
        if (wr_en) begin
            ram[addr] <= i_data;
        end else begin
            o_data <= ram[addr];
        end
    end
    
endmodule