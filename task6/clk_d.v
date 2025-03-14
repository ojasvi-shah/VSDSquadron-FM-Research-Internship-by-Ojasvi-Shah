//---------------------------------------------------------
//                                                       --
//             Module Declaration                        --
//                                                       --
//---------------------------------------------------------
module clk_d (
  // inputs
  input wire clk,
  // outputs
  output wire clk2,
  output wire clk3,
  output wire clk4
);

  wire        int_osc;
  reg [3:0] q = 4'b0000;
  reg [1:0] b = 2'b00;

//--------------------------------------------------------
//                                                      --
//             Internal Oscilliator                     --
//                                                      --
//--------------------------------------------------------
  SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC ( .CLKHFPU(1'b1), .CLKFEN(1'b1), .CKLFD(int_osc));

//--------------------------------------------------------
//                                                      --
//              Clock Divider                           --
//                                                      --
//--------------------------------------------------------
  always @(posedge clk) begin
    q = q +1'b1
  end

assign clk2 = q[0];
assign clk4 = q[1];

always @(posedge clk) begin
  b = b +1'b1;
  if(b==2'b11)
    b=0;
end

assign clk3 = b[1];
endmodule
    
