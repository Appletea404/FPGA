`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2026 09:26:29 AM
// Design Name: 
// Module Name: tb_mux
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


module tb_mux(

    );
endmodule


module tb_mux_2_1;
    
    reg [1:0] d;
    reg s;
    wire f;

    mux_2_1 uut(
        .d(d),
        .s(s),
        .f(f)
    );

    initial begin
        d = 2'b10; s = 0; #10;
                   s = 1; #10;
        d = 2'b01; s = 0; #10;
                   s = 1; #10;

        $finish;             
    end
endmodule


module tb_mux_4_1;
    
    reg [3:0] d;
    reg [1:0] s;
    wire f;

    mux_4_1 uut(
        .d(d),
        .s(s),
        .f(f)
    );

    initial begin
    
        d = 4'b1010;
        s = 2'b00;
        #10;
        
        s = 2'b01; #10;
        s = 2'b10; #10;
        s = 2'b11; #10;

        $finish;             
    end
endmodule


module tb_mux_8_1;
    
    reg [7:0] d;
    reg [2:0] s;
    wire f;

    mux_8_1 uut(
        .d(d),
        .s(s),
        .f(f)
    );

    initial begin
    
        d = 8'b11001010;
        
        s = 3'b000; #10;
        s = 3'b001; #10
        s = 3'b010; #10
        s = 3'b011; #10
        s = 3'b100; #10
        s = 3'b101; #10
        s = 3'b110; #10
        s = 3'b111; #10

        $finish;             
    end
endmodule

module tb_demux_1_2;

    reg in;
    reg s;
    wire [1 : 0]out;
    
    demux_1_2 uut(
        .in(in),
        .s(s),
        .out(out)
    );
    
    initial begin
        in = 0; s = 0; #10;

        
        in = 1; s = 0; #10;
        in = 0; s = 0; #10;
        
        in = 1; s = 1; #10;
        in = 0; s = 1; #10;
        
        $finish;
    end
endmodule



module tb_demux_1_4;

    reg d;
    reg [1:0] s;
    wire [3 : 0] f;
    
    demux_1_4 uut(
        .d(d),
        .s(s),
        .f(f)
    );
    
    initial begin
        $display("Time\t d s\t|\tf");
        $monitor("%4t\t %b %b\t|\t%b",$time,d,s,f);
        
        d = 1;
        s = 2'b00; #10;     // f = 0001
        s = 2'b01; #10;     // f = 0010
        s = 2'b10; #10;     // f = 0100
        s = 2'b11; #10;     // f = 1000
        
        d = 0;
        s = 2'b00; #10;     // f = 0000
        s = 2'b01; #10;     // f = 0000
        s = 2'b10; #10;     // f = 0000
        s = 2'b11; #10;     // f = 0000
        
        
        $finish;
    end
endmodule


module tb_mux_demux_test;

    reg [3:0] d;
    reg [1:0] mux_s;
    reg [1:0] demux_s;
    wire [3 : 0] f;
    
    mux_demux_test dut(
        .d(d),
        .mux_s(mux_s),
        .demux_s(demux_s),
        .f(f)
    );
    
    initial begin
        $display("\t\t\t\tTim\td\tmux_s\tdemux_s\t|\tf");
        $monitor("%4t\t%b\t%b\t%b\t|\t%b",$time,d,mux_s,demux_s,f);
        
        
        d = 4'b1010;
        
        mux_s = 2'b00;  demux_s = 2'b00; #10;       // d[0] -> f[0]
        mux_s = 2'b01;  demux_s = 2'b01; #10;       
        mux_s = 2'b10;  demux_s = 2'b10; #10;
        mux_s = 2'b11;  demux_s = 2'b11; #10;
        
        mux_s = 2'b11;  demux_s = 2'b00; #10;       // d[3] -> f[0]
        mux_s = 2'b00;  demux_s = 2'b11; #10;       // d[0] -> f[3]  
        
        
        
        $finish;
    end
endmodule




module tb_bin_to_bcd;
    reg [11:0] bin;
    wire [15:0] bcd;

    bin_to_bcd uut(
        .bin(bin),
        .bcd(bcd)
    );

    initial begin
        bin = 12'b0;

        #10 bin = 12'b0000_0000_0000;   // 0
        #10 bin = 12'b0000_0000_0001;   // 1
        #10 bin = 12'b0000_0000_1001;   // 9
        #10 bin = 12'b0000_0001_0100;   // 20
        #10 bin = 12'b0000_1011_1001;   // 185
        #10 bin = 12'b1011_0110_1101;   // 2925
        #10 bin = 12'b1111_1111_1111;   // 4095

        #20 $stop;
    end

    initial begin
        $monitor("Time=%0t | bin=%b (%0d) -> BCD=%b (BCD digits: %0d%0d%0d%0d)", 
                  $time, bin, bin, bcd, 
                  bcd[15:12], bcd[11:8], bcd[7:4], bcd[3:0]);
    end

endmodule
