`timescale 1us/1ns
module SB_HFOSC #(parameter integer CLKHF_DIV=1)    (
    input CLKHFPU
    input CLKHFEN
    output CLKHF
);
endmodule

module SB_FGBA_DRV #(parameter integer RGB0_CURRENT=1, parameter integer RGB1_CURRENT=1, parameter integer RGB2_CURRENT=1)    (
    input RGBLEDEN,
    input RGB0PWM,
    input RGB1PWM,
    input RGB2PWM,
    input CURREN,
    output RGB0,
    output RGB1,
    output RGB2
);
    assign RGB0 = RGB0PWM;
    assign RGB1 = RGB1PWM;
    assign RGB2 = RGB2PWM;
endmodule

`include "clk_d.v"
module testbench();

//Testbench variables
parameter HALF_PERIOD_CLK2 = 0.5;
parameter HALF_PERIOD_CLK4 = 0.25;

reg clk2l
reg clk4 = 1'b0;
reg clk3;

initial begin
    clk2 = 1'b0;
    forever begin
                #(HALF_PERIOD_CLK2); clk2 = ~clk2;
    end
end

always begin
                #(HALF_PERIOD_CLK4); clk4 = ~clk4;
end

initial begin
    clk3 = 1'b1;
    forever begin
    clk3 = 1'b1; #(0.3);
    clk3 = 1'b1; #(0.7)
    end
end

initial begin
 #40
        $finish;
end

endmodule
