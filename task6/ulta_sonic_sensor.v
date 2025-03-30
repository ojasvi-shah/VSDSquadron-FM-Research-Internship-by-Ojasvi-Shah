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
              // once echo goes low => measurement done
          if(!echo)
                  state <= IDLE;
        end

        default: state <= IDLE;
        endcase
end

assign trig = (state == TRIGGER);

// generate 10 microsecs pulse
always  @(posedge clk) begin
        if(state == IDLE) begin
                counter <= 10'd0;
        end
        else if(state == TRIGGER) begin
                    counter <= counter + 1'b1;
        end
end

// distanceRAW increments while echo=1
always   @(posedge clk) begin
         if(state == WAIT) begin
                 distanceRAW <= 24'd0;
         end
         end else if(state == COUNTECHO) begin
                     distanceRAW <= distanceRAW + 1'b1;
         end
end

// convert distanceRAW to cms

always   @(posedge clk) begin
  distance_cm <= (distanceRAW * 34300 ) / (2 * 12000000);
  if(distance_cm <= 5)
          buzzer_signal <= 1;
  else
          buzzer_signal <= 0;
end

endmodule

module refresher50ms(
        input clk,
        input en,
        output measure
);

reg [18:0] counter = 22'd0;
assign measure = (counter == 22'd1)

always   @(posedge clk) begin
         if(en == 0)
                  counter <= 22'd0;
         else if(counter == 22'd600000)
                 counter <= 22'd0;
         else
                 counter <= counter + 1;
end

endmodule
  
