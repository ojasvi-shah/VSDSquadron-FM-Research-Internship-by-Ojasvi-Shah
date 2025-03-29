`include "uart_trx.v"
`include "ultra_sonice_sensor.v"

//------------------------------------------------
//                                              --
//             Module Declaration               --
//                                              --
//------------------------------------------------
module top (
  // outputs
  output wire led_red  , // Red
  output wire led_blue , // Blue
  output wire led_green  , // Green
  output wire uarttx  , // UART Transmission pin
  input wire uartx  , // UART reception pin
  input wire hw_clk  ,
  input wire echo, // External echo signal from sensor
  output wire trig, // Trigger output for sensor
  output wire buzzer
);

wire         int_osc            ;
//------------------------------------------------
//                                              --
//         Internal Oscilliator (12Mhz)         --
//                                              --
//------------------------------------------------
  SB_HFOSC #(.CLKHF_DIV ("0b10")) u_SB_HFOSC (  .CLKHFPU(1'b1),  .CLKHFEN(1'b1), .CLKHF(int_osc));

  /* 9600 Hz clock generation (from 6Mhz) */
    reg clk_9600 = 0;
    reg [31:0] cntr_9600 = 32'b0;
    parameter period_9600 =625; // half period for 12 Mhz -> 9600 baud

always @(posedge int_osc) begin
        cntr_9600 <= cntr_9600 + 1;
        if (cntr_9600 == period_9600) begin
           clk_9600 <= ~clk_9600;
           cntr_9600 <= 32'b0;
         end
end

//------------------------------------------------
//                                              --
//          Ultrasonic sensor signals           --
//                                              --
//------------------------------------------------
wire [23:0] distanceRAW; // If the sensor module also provides raw
wire [15:0] distance_cm;
wire sensor_ready;
wire measure;
wire buzzer_signal;

// instantiate ultrasonic snesor module
hc_sr04 u_sensor  (
        .clk(int_osc),
        .trig(trig)
        .echo(echo)
        .ready(sensor_ready)
        .distanceRAW(distanceRAW)
        .distance_cm(distance_cm)
        .measure(measure)
        .buzzer_signal(buzzer_signal)
);

// Trigger the sensor every 50ms
refresher50ms trigger_timer (
  .clk(int_osc),
  .en(1'b1),
  .measure(measure)
);

// UART control
  reg [7:0] tx_data; // data byte to transmit
  reg send_data; // signal to indicate UART transmission

//-----------------------------------------------------------
//                                                         --
//    Finite state machine to print distance_cn as ASCII   --
//                                                         --
//-----------------------------------------------------------
  reg [3:0] state;
  localparam IDLE = 4'd0;
             DIGIT_4 = 4'd1;
             DIGIT_3 = 4'd2;
             DIGIT_2 = 4'd3;
             DIGIT_1 = 4'd4;
             DIGIT_0 = 4'd5;
             SEND_CR = 4'd6;
             SEND_LF = 4'd7;
             DONE = 4'd8;
  reg [31:0] distance_reg;

  // we run this state machine at clk_9600 so we only load
  // one character per 1-bit time
  always @(posedge clk_9600) begin
    send_data <= 1'b0;
    case(state)
          IDLE: begin
            if(sensor_ready) begin
                    distance_reg <= distance_cm;
                    buzzer <= buzzer_signal;
                    state <= DIGIT_4;
            end
          end
          DIGIT_4: begin
            tx_data <= ((distance_reg / 10000) % 10) + 8'h30;
            send_data <= 1'b1
            state <= DIGIT_3
          end
          DIGIT_3: begin
            tx_data <= ((distance_reg / 1000) % 10) + 8'h30;
            send_data <= 1'b1;
            state <= DIGIT_3;
          end
          DIGIT_2: begin
            tx_data <= ((distance_reg / 100) % 10) + 8'h30;
            send_data <= 1'b1;
            state <= DIGIT_1;
          end
          DIGIT_1: begin
            tx_data <= ((distance_reg / 10) % 10) + 8'h30;
            send_data <= 1'b1;
            state <= DIGIT_0;
          end
          DIGIT_0: begin
            tx_data <= (distance_reg % 10) + 8'h30;
            send_data <= 1'b1;
            state <= SEND_CR;
          end
          SEND_CR: begin
            tx_data <= 8'h0D;
            send_data <= 1'b1;
            state <= SEND_LF;
          end
          SEND_LF: begin
            tx_data <= 8'h0A;
            send_data <= 1'b1;
            state <= DONE;
          end
          DONE: begi'n
            state <= IDLE;
          end
          default: state <= IDLE;
    endcase
  end

  // UART transmitter
  uart_tx_8n1 sensor_uart(
    .clk(clk_9600),
    .txbyte(tx_data),
    .senddata(send_data),
    .tx(uarttx)
  );

  //--------------------------------------------
  //                                          --
  //          Instantiate RGB Primitive       --
  //                                          --
  //--------------------------------------------
    SB_RGBA_DRV RGB_DRIVER (
      .RGBLEDEN(1'b1                           ),
      .RGB0PWM (1'b0),
      .RGB1PWM (1'b0),
      .RGB2PWM ((distance_cm <=5) ? 1'b1 : 1'b0),
      .CURREN  (1'b1                           ),
      .RGB0    (led_green                      ),
      .RGB1    (led_blue                       ),
      .RGB2    (led_red                        )
    );
    defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
    defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
            
      
  
