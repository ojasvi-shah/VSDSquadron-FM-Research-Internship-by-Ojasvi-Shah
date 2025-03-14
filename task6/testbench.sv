`timescale lus/1ns
module SB_HFOSC #(parameter integer CLKHF_DIV=1)  (
    input CLKHFPU,
    input CLKHFEN,
    output CLKHF,
);
endmodule

`include "clk_d.v"
module testbench();

//Testbench variable
parameter HALF_PERIOD_VLK2 = 0.5;
parameter HALF_PERIOD_CLK4 = 0.25;

reg clk2;
reg clk4 = 0;
reg clk3;

initial begin
  $dumpfile("testbench.vcd");
  $dumpvars(0, testbench);
end

initial begin
  clk2 = 0;
  forever begin
              #(HALF_PERIOD_CLK2); clk2 = -clk2
  end
end

always begin
              #(HALF_PERIOD_CLK4); clk4 = -clk4
end

initial begin
    clk3 = 1;
    forever begin
    clk3 = 1; #(0.3);
    clk3 = 0; #(0.7);
    end
end

initial begin
  #40 $stop;
end
  
endmodule
