module uart(
        input clk,
        input rst,
        input rx,
        output tx,
        input transmit,
        input [7:0] tx_byte,
        output recieved,
        output [7:0] rx_byte,
        output wire is_receiving
        output wire is_transmitting,
        output wire recv_error,
        output reg [3:0] rx_samples,
        output reg [3:0] rx_sample_countdown,
        );
parameter baud_rate = 9600;
parameter sys_clk_freq = 120000000;

parameter one_baud_cnt = sys_clk_freq / (baud_rate);

parameter [2:0] RX_IDLE = 3'd0;
parameter [2:0] RX_CHECK_START = 3'd1;
parameter [2:0] RX_SAMPLE_BITS = 3'd2;
parameter [2:0] RX_READ_BITS = 3'd3;
parameter [2:0] RX_CHECK_STOP = 3'd4;
parameter [2:0] RX_DELAY_RESTART = 3'd5;
parameter [2:0] RX_ERROR = 3'd6;
parameter [2:0] RX_RECIEVED = 3'd7;

parameter [1:0] TX_IDLE = 2'd0;
parameter [1:0] TX_SENDING = 2'd1;
parameter [1:0] TX_DELAY_RESTART = 2'd2;
parameter [1:0] TX_RECOVER = 2'd3;

// SIGNAL DECLARATIONS

reg [log2(one_baud_cnt * 16)-1 : 0] rx_clk;
reg [log2(one_baud_cnt)-1 : 0] tx_clk;

reg [2:0] recv_state = RX_IDLE;
reg [3:0] tx_bits_remaining;
reg [7:0] tx_data;

reg tx_out = 1'b1;
reg [1:0] tx_state = TX_IDLE;
reg [3:0] tx_bits_remaining;
reg [7:0] tx_data;

// Assign Statements
assign received = recv_state == RX_RECIEVED;
assign recv_error = recv_state == RX_ERROR;
assign is_recieving = recv_state != RX_IDLE;
assign rx_byte = rx_data;

assign tx = tx_out;
assign is_transmitting = tx_state != TX_IDLE;

// Tasks/Functions

  function integer log2(input integer M)
            integer i;
            begin
                    log2 = 1;
                    for (i= 0, 2**i <= M, i = i+1)
                            log2 = i +1;
            end
  endfunction

  // Body

  always @(posedge clk) begin
    if(rst)begin
         recv_state = RX_IDLE;
         tx_state = TX_IDLE;
         end

         // countdown timers for the recieving and transmitting machines are decremented
    if(rx_clk)begin
            rx_clk = rx_clk - 1'd1;
    end

    if(tx_clk)begin
            tx_clk = tx_clk - 1'd1;
    end

// Receiving state machine
    case(recv_state)
    // RX_IDLE is the idle state when the reciever waits for the next start signal
    RX_IDLE: begin
            // a low pulse on the receive line indicates start of data
      if(!rx) begin
              // wait 1/2 of the bit period
              rx_clk = one_baud_cnt / 2;
              recv_state = RX_CHECK_START;
      end
    end
    // RX_CHECK_START verifies that the signal is still valid
    RX_CHECK_START: begin
      if (!rx_clk) begin
                // check if the pulse is still there
        if(!rx) begin
                // wait for bit period + 3/8 of the next
          rx_clk = (one_baud_cnt / 2) + (one_baud_cnt * 3) / 8;
          rx_bits_remaining = 8;
          recv_state = RX_SAMPLE_BITS;
          rx_samples = 0;
          rx_sample_countdown = 5;
          rx_bits_remaining = rx_bits_remaining - 1'd1;

          if(rx_bits_remaining)begin
                  recv_state = RX_SAMPLE_BITS;
          end else begin
                  recv_state = RX_CHECK_STOP;
                  rx_clk = one_baud_cnt / 2;
          end
        end
      end
      // RX_CHECK_STOP checks for the stop bit after reading data
      // if the rx line is high during the stop bit period, the state transitions to RX_RECEIVED (successful) else RX_ERROR
      RX_CHECK_STOP: begin
        if(!rx_clk) begin
                recv_state = rx ? RX_RECEIVED : RX_ERROR;
        end
      end
      // RX_ERROR handles errors in receiving data. when an error occurs, the receiver needs to reset and delay before trying again
      // the rx_clk is set to a longer delay (8 baud periods), which introduces a pause before accepting another transmission
      RX_ERROR: begin
        rx_clk = sys_clk_freq / (baud_rate);
        recv_state = RX_DELAY_RESTART;
      end
      // RX_DELAY_RESTART waits before restarting the reception after an error
      RX_DELAY_RESTART: begin
              recv_state = rx_clk ? RX_DELAY_RESTART : RX_IDLE;
      end
      // RX_RECEIVED inidicates that a byte of data was successfully received
      RX_RECEIVED: begin
              recv_state = RX_IDLE;
      end
      endcase

      // Transmit state machine
      case(tx_state)
      // TX_IDLE is the starting state when transmitter is idle
      TX_IDLE: begin
        if(transmit) begin
                // if transmit is high, it means data is ready to be sent
                tx_data = tx_byte;
                tx_clk = one_baud_cnt; // set the transmission clock to the baud rate
                tx_out = 0; // low pulse on the tx_out line, signals start of transmission
                tx_bits_remaining = 8;
                tx_state = TX_SENDING;
        end
      end
      // TX_SENDING state is responsible for transmitting the data bits. tx_clk is used to manage timing of each bit
      // if tx_clk has expired i.e. one baud period has passed, then it proceeds with transmission
      TX_SENDING: begin
        if (!tx_clk) begin
          if(tx_bits_remaining) begin
            tx_bits_remaining  = tx_bits_remaining - 1'd1;
            tx_out = tx_data[0]; // send the lsb
            tx_data = {1'b0, tx_data[7:1]}; // shifts the data so that next bit is ready for transmission on the next clock cycle
            tx_clk = one_baud_cnt;
            tx_state = TX_SENDING;
          end else begin
            tx_out = 1;
            tx_clk = 16 * one_baud_cnt; // sets tx_clk to a longer duration to implement the stop bit delay
            tx_state = TX_DELAY_RESTART; // manage delay between transmission
          end
        end
      end
      // TX_DELAY_RESTART handles the delay after sending all data and the stop bit
      // it ensures that the transmitter stays idle for the correct amount of time before starting another transmission
      TX_DELAY_RESTART: begin
            tx_state = tx_clk ? TX_DELAY_RESTART : TX_RECOVER;
      end
      TX_RECOVER: begin
              tx_state = transmit ? TX_RECOVER : TX_IDLE;
      end
      endcase
  end
  endmodule
      
