// ============================================
// Basys3 7-Segment 분:초 시계
// 자동모드 / 수동모드 전환 가능
// ============================================
module best_clock(
    input        clk,          // 100MHz 보드 클럭
    input        reset_p,      // 리셋 스위치 (sw[0])
    input  [2:0] btn,          // btn[0]=C, btn[1]=L, btn[2]=R
    output [7:0] seg,          // seg[0]~seg[6]=a~g, seg[7]=dp (active low)
    output [3:0] com_an        // 자릿수 선택 (active low)
);

    // ------------------------------------------
    // 1) 버튼 동기화 & 엣지 검출 (채터링 방지)
    // ------------------------------------------
    reg [19:0] debounce_cnt_C = 0;
    reg [19:0] debounce_cnt_L = 0;
    reg [19:0] debounce_cnt_R = 0;
    reg        btnC_current = 0, btnC_prev = 0;
    reg        btnL_current = 0, btnL_prev = 0;
    reg        btnR_current = 0, btnR_prev = 0;
    wire       btnC_pulse, btnL_pulse, btnR_pulse;

    // 약 10ms 디바운스 (100MHz 기준)
    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            debounce_cnt_C <= 0;
            debounce_cnt_L <= 0;
            debounce_cnt_R <= 0;
            btnC_current <= 0;
            btnL_current <= 0;
            btnR_current <= 0;
            btnC_prev <= 0;
            btnL_prev <= 0;
            btnR_prev <= 0;
        
        end else begin
            // btnC (btn[0]) 디바운스
            if (btn[0] != btnC_current) begin
                debounce_cnt_C <= debounce_cnt_C + 1;
                if (debounce_cnt_C >= 20'd999_999) begin
                    btnC_current <= btn[0];
                    debounce_cnt_C <= 0;
                end
            end else begin
                debounce_cnt_C <= 0;
            end

            // btnL (btn[1]) 디바운스
            if (btn[1] != btnL_current) begin
                debounce_cnt_L <= debounce_cnt_L + 1;
                if (debounce_cnt_L >= 20'd999_999) begin
                    btnL_current <= btn[1];
                    debounce_cnt_L <= 0;
                end
            end else begin
                debounce_cnt_L <= 0;
            end

            // btnR (btn[2]) 디바운스
            if (btn[2] != btnR_current) begin
                debounce_cnt_R <= debounce_cnt_R + 1;
                if (debounce_cnt_R >= 20'd999_999) begin
                    btnR_current <= btn[2];
                    debounce_cnt_R <= 0;
                end
            end else begin
                debounce_cnt_R <= 0;
            end

            // 이전 상태 저장 (엣지 검출용)
            btnC_prev <= btnC_current;
            btnL_prev <= btnL_current;
            btnR_prev <= btnR_current;
        end
    end

    // 상승 엣지 검출: 버튼 누르는 순간 1클럭 펄스
    assign btnC_pulse = (btnC_current == 1) && (btnC_prev == 0);
    assign btnL_pulse = (btnL_current == 1) && (btnL_prev == 0);
    assign btnR_pulse = (btnR_current == 1) && (btnR_prev == 0);

    // ------------------------------------------
    // 2) 1초 클럭 만들기 (100MHz -> 1Hz)
    // ------------------------------------------
    reg [26:0] sec_counter = 0;
    reg        one_sec_tick = 0;

    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            sec_counter <= 0;
            one_sec_tick <= 0;
        end else begin
            if (sec_counter >= 27'd99_999_999) begin
                sec_counter <= 0;
                one_sec_tick <= 1;
            end else begin
                sec_counter <= sec_counter + 1;
                one_sec_tick <= 0;
            end
        end
    end

    // ------------------------------------------
    // 3) 모드 관리 & 시간 카운터
    //    mode = 0 : 자동모드 (1초씩 증가)
    //    mode = 1 : 수동모드 (버튼으로 설정)
    // ------------------------------------------
    reg        mode = 0;        // 0=자동, 1=수동
    reg [5:0]  sec  = 0;        // 초 (0~59)
    reg [5:0]  min  = 0;        // 분 (0~59)

    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            mode <= 0;
            sec  <= 0;
            min  <= 0;
        end else begin
            // 모드 전환 (btnC)
            if (btnC_pulse)
                mode <= ~mode;

            // 자동모드: 1초마다 카운트 증가
            if (mode == 0) begin
                if (one_sec_tick) begin
                    if (sec >= 59) begin
                        sec <= 0;
                        min <= min + 1;
                        if (min >= 59)
                            min <= 0;
                        else
                            min <= min + 1;
                    end else begin
                        sec <= sec + 1;
                    end
                end
            end

            // 수동모드: 버튼으로 시간 설정
            if (mode == 1) begin
                if (btnR_pulse) begin       // 초 +1
                    if (sec >= 59) begin
                        sec <= 0;
                        min <= min + 1;
                    end else
                        sec <= sec + 1;
                end
                if (btnL_pulse) begin       // 분 +1
                    if (min >= 59)
                        min <= 0;
                    else
                        min <= min + 1;
                end
            end
        end
    end

    // ------------------------------------------
    // 4) 분/초를 각 자릿수로 분리
    // ------------------------------------------
    wire [3:0] min_tens, min_ones;
    wire [3:0] sec_tens, sec_ones;

    assign min_tens = min / 10;      // 분의 십의 자리
    assign min_ones = min % 10;      // 분의 일의 자리
    assign sec_tens = sec / 10;      // 초의 십의 자리
    assign sec_ones = sec % 10;      // 초의 일의 자리

    // ------------------------------------------
    // 5) 7세그먼트 다이나믹 구동
    //    4자리를 빠르게 번갈아 켜서 동시에 보이게 함
    // ------------------------------------------
    reg [17:0] refresh_counter = 0;  // 새로고침 카운터
    wire [1:0] digit_select;         // 현재 표시할 자릿수
    reg [3:0]  current_digit;        // 현재 자릿수 값
    reg [3:0]  an_reg;

    always @(posedge clk)
        refresh_counter <= refresh_counter + 1;

    // 상위 2비트로 자릿수 선택 (약 380Hz 새로고침)
    assign digit_select = refresh_counter[17:16];

    always @(*) begin
        case (digit_select)
            2'b00: begin    // 가장 오른쪽 = 초의 일의 자리
                an_reg = 4'b1110;
                current_digit = sec_ones;
            end
            2'b01: begin    // 초의 십의 자리
                an_reg = 4'b1101;
                current_digit = sec_tens;
            end
            2'b10: begin    // 분의 일의 자리
                an_reg = 4'b1011;
                current_digit = min_ones;
            end
            2'b11: begin    // 가장 왼쪽 = 분의 십의 자리
                an_reg = 4'b0111;
                current_digit = min_tens;
            end
        endcase
    end

    assign com_an = an_reg;

    // ------------------------------------------
    // 6) 숫자 -> 7세그먼트 디코더
    //    seg[7]=dp, seg[6:0]={a,b,c,d,e,f,g}
    //    모두 active low
    // ------------------------------------------
    reg [7:0] seg_reg;

    always @(*) begin
        case (current_digit)
            4'd0 : seg_reg[7:0] = 8'b11000000;     // 0
            4'd1 : seg_reg[7:0] = 8'b11111001;     // 1
            4'd2 : seg_reg[7:0] = 8'b10100100;     // 2
            4'd3 : seg_reg[7:0] = 8'b10110000;     // 3
            4'd4 : seg_reg[7:0] = 8'b10011001;     // 4
            4'd5 : seg_reg[7:0] = 8'b10010010;     // 5
            4'd6 : seg_reg[7:0] = 8'b10000010;     // 6
            4'd7 : seg_reg[7:0] = 8'b11111000;     // 7
            4'd8 : seg_reg[7:0] = 8'b10000000;     // 8
            4'd9 : seg_reg[7:0] = 8'b10011000;     // 9
            default: seg_reg[7:0] = 8'b11111111; // 꺼짐
        endcase
    end

    assign seg = seg_reg;

endmodule