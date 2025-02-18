`timescale 1ns / 1ps

module uart_transmitter (
    input clk,
    input reset,
    input start,              // New input to start transmission
    input [7:0] datain,
    output reg transmit
);

    reg [1:0] state, next_state;
    reg [2:0] counter; // 3-bit counter (0 to 7)
    
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transmit <= 1; // Idle state keeps line high
            counter <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: 
                if (start) 
                    next_state = START;
                else 
                    next_state = IDLE;
            
            START: 
                next_state = DATA;

            DATA: 
                if (counter == 7) 
                    next_state = STOP;
                else 
                    next_state = DATA;
            
            STOP: 
                next_state = IDLE;

            default: 
                next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transmit <= 1;
            counter <= 0;
        end else begin
            case (state)
                START: 
                    transmit <= 0; // Start bit

                DATA: begin
                    transmit <= datain[counter]; // Send data bit
                    counter <= counter + 1;
                end
                
                STOP: begin
                    transmit <= 1; // Stop bit
                    counter <= 0;
                end
            endcase
        end
    end

endmodule
