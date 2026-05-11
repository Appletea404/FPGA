`timescale 1ns / 1ps


module ultra_sonic_top(
    input clk, reset_p,
    input echo,
    output trig,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);

    wire [8:0] distance_cm;
    hc_sr04_cntr ultra(
        .clk(clk), .reset_p(reset_p),
        .echo(echo), .trig(trig),
        .distance_cm(distance_cm));
    wire [15:0] distance_bcd;
    bin_to_dec btd_x(.bin(distance_cm), .bcd(distance_bcd));
    
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), 
            .fnd_value(distance_bcd), .seg(seg), .com(com));

endmodule

module dht11_top(
    input clk, reset_p,
    inout dht11_data,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
    
    wire [7:0] humidity, temperature;
    dht11_cntr dht(clk, reset_p, dht11_data, humidity, temperature, led);
    
    wire [7:0] humidity_bcd, temperature_bcd;
    bin_to_dec btd_humi(.bin(humidity), .bcd(humidity_bcd));
    bin_to_dec btd_tmpr(.bin(temperature), .bcd(temperature_bcd));
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), 
            .fnd_value({humidity_bcd, temperature_bcd}), .seg(seg), .com(com));

endmodule
