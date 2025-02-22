`timescale 1ns / 1ps
module uart_transmitter
  #(parameter CLKS_PER_BIT = 868)
  (
   input       clk_i,          //100MHZ
   input       reset_i,        
   input [7:0] databit_i,      
   input       start_tx_i,     
   output reg  transmit_o,     
   output reg  active_f,      
   output reg  done_f         
   );
 
  // FSM states
  parameter IDLE  = 3'b000;
  parameter START = 3'b001;
  parameter DATA  = 3'b010;
  parameter STOP  = 3'b011;
  parameter CLEANUP = 3'b100;
   
  reg [2:0] state, next_state;             
  reg [2:0] counter;    
  reg [7:0] Data_r;      
  reg       Done_r;     
  reg       Active_r;    
  reg       start_flag; // Flag to latch begin_tx_w
        
  // Baud rate generator instance
  baud_gen instance1(
    .clk(clk_i),
    .reset(reset_i),
    .baud_rate_tx(clk_tx),
    .baud_rate_rx(clk_rx) // Unused 
  );
  wire clk_tx;
  wire clk_rx; // Unused

  // Debounce button instance
  debounce instance2(
    .clk(clk_i),        // Clock signal
    .reset(reset_i),    // Reset signal
    .din(start_tx_i),   // Input signal (noisy)
    .dout(begin_tx_w)   // Debounced output signal
  );
  wire begin_tx_w;

  // Latch the begin_tx_w signal
  always @(posedge clk_i or posedge reset_i) begin
    if (reset_i) begin
      start_flag <= 1'b0;
    end else if (begin_tx_w) begin
      start_flag <= 1'b1; // Latch the start signal
    end else if (state == START) begin
      start_flag <= 1'b0; // Clear the flag once the state machine starts
    end
  end

  // State transition logic
  always @(posedge clk_i or posedge reset_i) begin
    if (reset_i) begin
      state <= IDLE; 
    end else if (clk_tx) begin 
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE :
        begin
          if (start_flag) begin
            next_state = START;
          end else begin
            next_state = IDLE;
          end
        end
         
      START :
        begin
          next_state = DATA;
        end
         
      DATA :
        begin
          if (counter < 7) begin
            next_state = DATA;
          end else begin
            next_state = STOP;
          end
        end
         
      STOP :
        begin
          next_state = CLEANUP;
        end
         
      CLEANUP :
        begin
          next_state = IDLE;
        end
         
      default :
        next_state = IDLE;
    endcase
  end

  // State output logic
  always @(posedge clk_i or posedge reset_i) begin
    if (reset_i) begin
      transmit_o    <= 1'b1; 
      active_f      <= 0;
      done_f        <= 0;
      counter       <= 0;
      Data_r        <= 0;
      Done_r        <= 0;
      Active_r      <= 0;
    end else if (clk_tx) begin 
      case (state)
        IDLE :
          begin
            transmit_o   <= 1'b1; 
            Done_r       <= 1'b0;
            counter      <= 0;
             
            if (start_flag) begin
              Active_r   <= 1'b1;
              Data_r     <= databit_i;
            end
          end
         
        START :
          begin
            transmit_o <= 1'b0;
            counter    <= 0; 
          end
         
        DATA :
          begin
            transmit_o <= Data_r[counter];                 
            if (counter < 7) begin
              counter <= counter + 1;
            end else begin
              counter <= 0;
            end
          end
         
        STOP :
          begin
            transmit_o <= 1'b1;
            Done_r     <= 1'b1;
            Active_r   <= 1'b0;
          end
         
        CLEANUP :
          begin
            Done_r <= 1'b1;
          end
         
        default :
          begin
            transmit_o <= 1'b1;
            Done_r     <= 0;
            Active_r   <= 0;
          end
      endcase

      active_f <= Active_r;
      done_f   <= Done_r;
    end
  end
 
endmodule