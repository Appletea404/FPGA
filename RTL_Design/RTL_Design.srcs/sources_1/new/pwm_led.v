module pwm_Nfreq_Nstep (
    input clk, reset_p,
    input [31:0] duty,
    output reg pwm
);

    parameter SYS_CLK_FREQ = 100_000_000;   // system freq -> 100,000,000Hz
    parameter PWM_FREQ = 10_000;            // pwm freq -> 10,000Hz
    parameter DUTY_STEP = 200;              // duty resolution (0~199) 200단계
    parameter temp = SYS_CLK_FREQ / (PWM_FREQ * DUTY_STEP) / 2 -1;
	  // 용어 설명
	  // SYS_CLK_FREQ: 100,000,000Hz 사용
		// PWM_FREQ: 우리가 최종적으로 만들고 싶은 PWM 신호의 주파수
		// DUTY_STEP: 밝기나 속도를 얼마나 세밀하게 조절할 것인가를 정함 (예: 256단계, 100단계)
		// temp: 듀티비(Duty Cycle)를 딱 1단계(1 Step) 변화시키는 데 걸리는 시간을 시스템 클록 개수로 변환한 값

    //integer cnt;        // 분주 카운터
    reg [31:0] cnt;
    reg pwm_freqXstep;

    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            cnt = 0;
            pwm_freqXstep = 0;
        end else begin
            if (cnt >= temp) begin
                cnt = 0;
                pwm_freqXstep = ~pwm_freqXstep;     // 토글
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    wire pwm_freqXstep_pedge;

    edge_detector_n(
        .clk(clk),
        .reset_p(reset_p),
        .cp(pwm_freqXstep),
        .p_edge(pwm_freqXstep_pedge)
    );

    reg [31:0] cnt_duty;        // step 카운트

    always @(posedge clk or posedge reset_p) begin
        if (reset_p) begin
            cnt_duty = 0;
            pwm = 0;
        end 
        else if (pwm_freqXstep_pedge) begin
            if(cnt_duty >= DUTY_STEP - 1)
                cnt_duty = 0 ;
            else
                cnt_duty <= cnt_duty + 1;
            if(cnt_duty < (duty > DUTY_STEP ? DUTY_STEP : duty))
                pwm = 1;    // On
            else
                pwm = 0;    // Off            
        end
    end

endmodule



module led_pwm_control (
    input clk,      // 100MHZ
    input reset_p,
    input btn_up,   // 밝기 증가
    input btn_down, // 감소
    output pwm_led  // LED 출력
);

    wire btn_up_pedge, btn_down_pedge;

    button_edge uut_btn_up(
        .clk(clk),
        .reset_p(reset_p),
        .btn(btn_up),
        .p_edge(btn_up_pedge)
    );
    button_edge uut_btn_down(
        .clk(clk),
        .reset_p(reset_p),
        .btn(btn_down),
        .p_edge(btn_down_pedge)
    );

    parameter DUTY_STEP = 200;

    reg [7:0] duty;

    always @(posedge clk or posedge reset_p) begin
        if(reset_p)
            duty <= 0;
        else begin
            if(btn_up_pedge) begin
                if(duty < DUTY_STEP - 1)
                    duty <= duty + 1;
            end
            else if(btn_down_pedge) begin
                if(duty > 0)
                    duty <= duty - 1;
            end
        end
    end

    pwm_Nfreq_Nstep uut_pwm(
        .clk(clk),
        .reset_p(reset_p),
        .duty(duty),
        .pwm(pwm_led)
    );

endmodule




module button_edge(
    input clk, reset_p,
    input btn,
    output p_edge
);

    // ============================================================
    // 디바운스용 카운터 (~10ms)
    // ============================================================

    reg [19:0] cnt;
    reg btn_sync, btn_debounced;

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt <= 0;
            btn_sync <= 0;
            btn_debounced <= 0;
        end
        else begin
            btn_sync <= btn;

            if(btn_sync != btn_debounced) begin
                cnt <= cnt + 1;
                if(cnt == 1_000_000) begin   // 약 10ms @100MHz
                    btn_debounced <= btn_sync;
                    cnt <= 0;
                end
            end
            else
                cnt <= 0;
        end
    end

    // ============================================================
    // 엣지 검출
    // ============================================================

    reg btn_d;

    always @(posedge clk or posedge reset_p) begin
        if(reset_p)
            btn_d <= 0;
        else
            btn_d <= btn_debounced;
    end

    assign p_edge = btn_debounced & ~btn_d;

endmodule