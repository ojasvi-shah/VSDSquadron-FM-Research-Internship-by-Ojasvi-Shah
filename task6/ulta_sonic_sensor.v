module hc_sr04 #(
  parameter TRIGGER_CYCLES = 120, // duration of trigger pulse (120 clock cycles)
  ) (
          input clk,       // system clock input
          input measure,
          output reg[1:0] state = 0,
          output ready,
          input echo,      // echo signal from ultrasonic sensor
          output trig,     // trigger signal to ultrasonic sensor
          output reg [23:0] distanceRAW = 0,
          output reg [15:0] distance_cm = 0,
          output reg buzzer_signal = 0
);

//----------------------------
// state definitions        --
//----------------------------
localparam IDLE = 2'b00;
           TRIGGER = 2'b01;
           WAIT = 2'b11;
           COUNTECHO = 2'b10;

assign ready = (state == IDLE);

// 10 bit ocunter for 10 microsecs TRIGGER
reg [9:0] counter = 10'd0;
wire trigcountDONE = (counter == TRIGGER_CYCLES);

//------------------------------
// finite state machine
//------------------------------
always @(posedge clk) begin
        case(state)
        IDLE: begin
                // wait for measure pulse
                if (measure && ready)
                        state <= TRIGGER;
        end
        TRIGGER: begin  // generate trigger pulse state
              if(trigcountDONE)
                      state <= WAIT;
        end
        WAIT: begin
                // wait for echo rising edge
                if(echo)
                          state <= COUNTECHO;
        end
        COUNTECHO: begin
              // once echo goes low =>
