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

    initial begin
        clk = 0;
        reset_p = 0;
        i_data = 0;
        wr_addr = 0;
        rd_addr = 0;

        #10 reset_p = 1; #10 reset_p = 0;

        $display("--- 쓰기 동작 시작 ---");
        for(integer i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            wr_addr = i;        // 주소 0, 1 ,2...
            i_data = i + 10;    // 데이터는 10, 11, 12...
        end         
        
        @(posedge clk);
        wr_addr = 0;
        i_data = 0;

        $display("--- 읽기 동작 시작 ---");
        for(integer j = 0; j < 10; j = j + 1) begin
            @(posedge clk);
            rd_addr = j;

            @(posedge clk);
            $display("Addr : %d, Data : %d",j, o_data);
        end
        #50 $finish;
    end
endmodule