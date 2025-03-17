//---------------------------------------------------------
//                                                       --
//             Module Declaration                        --
//                                                       --
//---------------------------------------------------------
module clk_d (
  // inputs
  input wire clk,
  // outputs
  output wire led_red,
  output wire led_blue,
  output wire led_green,
  output wire clk2,
  output wire clk3,
  output wire clk4
);

  wire         int_osc;
  reg [3:0] q = 4'b0000;
  reg [1:0] b = 2'b00;
  reg [31:0] cclkdiv = 32'd0;

//------------------------------------------------------
//                                                    --
//                  Internal Oscilliator              --
//                                                    --
//------------------------------------------------------
  SB_HFOSC #(.CLFHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1b'1), .CLKHFEN(1'b1), .CLKHF(int_osc));


//------------------------------------------------------
//                                                    --
//                 Clock Divider                      --
//                                                    --
//------------------------------------------------------
  always @(posedge clk)
  clkdiv = clkdiv + 1;
  always @(posedge clkdiv[24])
  begin
    q = q + 1'b1;
  end

  assign clk2 = q[0];
  assign clk4 = q[1];

  always @(posedge clkdiv[24])
  begin 
    b = b + 1'b1;
    if(b==2'b11)
      b = 0;

  end

  assign clk3 = b[1];

  //---------------------------------------------------
  //                                                 --
  //         Instantiate RGB primitive               --
  //                                                 --
  //---------------------------------------------------
  SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1                   ),
    .RGB0PWM (clk2),
    .RGB1PWM (clk3),
    .RGB2PWM (clk4),
    .CURREN  (1'b1                   ),
    .RGB0    (led_red                ),
    .RGB1    (led_green              ),
    .RGB2    (led_blue               )
  );
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";
endmodule

