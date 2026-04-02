`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 02:56:32 PM
// Design Name: 
// Module Name: exam_module
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


module watch(
    input clk, reset_p,
    input [2:0] btn,
    output reg [7:0] sec, min
    );

    reg set_watch;      // 시계설정 모드
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) set_watch = 0;
        else if(btn[0]) set_watch = ~set_watch; // 모드 전환(btn[0] 토글)
    end

    integer cnt_sysclk;     // 시간 1초짜리 만들라고
    always @(posedge clk ) begin
        if(reset_p) begin
            cnt_sysclk = 0;
            sec = 0;
            min = 0;
        end
        else begin
            if(set_watch) begin
                // btn[1] -> 초 증가
                if(btn[1])begin
                    if(sec >= 59) sec = 0;
                    else sec = sec + 1;
                end
                // btn[2] -> 분 증가
                if(btn[2])begin
                    if(min >= 59) min = 0;
                    else min = min + 1;
                end
            end
            else begin
                // 100MHz 기준 1초
                if(cnt_sysclk >= 27'd99_999_999)begin
                    cnt_sysclk = 0;

                    //초 증가
                    if(sec >= 59)begin
                        sec = 0;
                        //분 증가
                        if(min>=59) min = 0;
                        else min = min + 1;
                    end
                    else sec = sec + 1;
                end
                else cnt_sysclk = cnt_sysclk + 1;   //클럭 카운트 증가
            end
        end
    end

endmodule


module watch_fnd(
    input clk, reset_p,
    input [2:0] btn,
    output [7:0] seg,
    output [3:0] com_an
    );
    
    wire[7:0] sec,min;
    
    watch(
    .clk(clk),
    .reset_p(reset_p),
    .btn(btn),
    .sec(sec),
    .min(min)
    );
    
    seg_decoder (
    .hex_value(sec),
    .seg(seg)
    );
    
    assign com_an = 4'b1110;
//    input clk, reset_p,
//    input [2:0] btn,
//    output reg [7:0] sec, min
//    );

//    reg set_watch;      // 시계설정 모드
    
//    always @(posedge clk or posedge reset_p) begin
//        if(reset_p) set_watch = 0;
//        else if(btn[0]) set_watch = ~set_watch; // 모드 전환(btn[0] 토글)
//    end

//    integer cnt_sysclk;     // 시간 1초짜리 만들라고
//    always @(posedge clk ) begin
//        if(reset_p) begin
//            cnt_sysclk = 0;
//            sec = 0;
//            min = 0;
//        end
//        else begin
//            if(set_watch) begin
//                // btn[1] -> 초 증가
//                if(btn[1])begin
//                    if(sec >= 59) sec = 0;
//                    else sec = sec + 1;
//                end
//                // btn[2] -> 분 증가
//                if(btn[2])begin
//                    if(min >= 59) min = 0;
//                    else min = min + 1;
//                end
//            end
//            else begin
//                // 100MHz 기준 1초
//                if(cnt_sysclk >= 27'd99_999_999)begin
//                    cnt_sysclk = 0;

//                    //초 증가
//                    if(sec >= 59)begin
//                        sec = 0;
//                        //분 증가
//                        if(min>=59) min = 0;
//                        else min = min + 1;
//                    end
//                    else sec = sec + 1;
//                end
//                else cnt_sysclk = cnt_sysclk + 1;   //클럭 카운트 증가
//            end
//        end
//    end

endmodule

