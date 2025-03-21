`include "uart_trx.v"

//------------------------------------------------------------
//                                                          --
//              Module Declaration                          --
//                                                          --
//------------------------------------------------------------
module top (
  output wire led_red  ,
  output wire led_blue  ,
  output wire led_green  ,
  output wire uarttx  ,
  input wire hw_clk,
  input wire uartrx
);

wire reset = 0;
reg transmit;
reg [7:0] tx_byte;
wire recieved;
wire [7:0] rx_byte;
wire is_recieving;
wire is_transmitting;
wire recv_error;
wire             int_osc          ;

//--------------------------------------------------------------
//                                                            --
//                 Internal Oscilliator                       --
//                                                            --
//--------------------------------------------------------------
  SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

uart #(.baud_rate(9600),
      .sys_clk_freq(12000000)
      )
  uartsimple(
    .clk(int_osc),
    .rst(reset),
    .rx(uartrx),
    .tx(uarttx),
    .transmit(transmit),
    .tx_byte(tx_byte),
    .recieved(recieved),
    .rx_byte(rx_byte),
    .is_recieving(is_recieving),
    .is_transmitting(is_transmitting),
    .recv_error(recv_error)
    );


//------------------------------------------------------------------
//                                                                --
//                         Counter                                --
//                                                                --
//------------------------------------------------------------------
  always @(posededge int_osc) begin
    if(recieved)begin
                  // convert lower case letters to upper case letters
                  // if rx_byte is between 61 hex and 7a hex, invluse, use rx_byte anded with 0xDF
                  // otherwise use rx_byte as is
      if(rx_byte >= 8'h61 && rx_byte <= 8'h7a)
              tx_byte <= rx_byte & 8'hDF;
      else begin
              tx_byte <= rx_byte;
      end
      transmit <= 1 ;
    end else begin
      // else
      transmit <= 0;
    end
  end

//-------------------------------------------------------------------
//                                                                 --
//                  Instantiate RGB Primitive                      --
//                                                                 --
//-------------------------------------------------------------------
  SB_RGBA_DRV RGB_DRIVER  (
    .RGBLEDEN(1'b1                                                 ),
    .RGB0PWM (1'b1                                                 ),
    .RGB1PWM (1'b0                                                 ),
    .RGB2PWM (1'b1                                                 ),
    .CURREN  (led_green                                            ),
    .RGB1    (led_blue                                             ),
    .RGB2    (led_red                                              ),
);
defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
