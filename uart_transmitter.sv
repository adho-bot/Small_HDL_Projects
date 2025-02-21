`timescale 1ns / 1ps

module uart_transmitter (
    input clk,
    input reset,        
    input [7:0] databit,
    output reg transmit
);
    wire baud_rate;
    reg [1:0] state, next_state;
    reg [2:0] counter; 
    reg [7:0] data_reg;
    
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

    baud_gen baud_instance(.clk(clk), .reset(reset), .baud_rate(baud_rate));

    always @(posedge baud_rate or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_reg <= 0;
        end else begin
            state <= next_state;
            if (state == STOP) begin
                data_reg <= databit;
            end
        end
    end
    
    always @(posedge baud_rate or posedge reset) begin
        if (reset || state != DATA) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
        
    always @(*) begin
        case (state) 
            IDLE: begin
                transmit = 1;
            end
            START: begin
                transmit = 0;
                next_state = DATA;
            end
            DATA: begin
                transmit = data_reg[counter];
                if (counter == 7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                transmit = 1;
                next_state = IDLE;
            end
            default: begin
                transmit = 1;
                next_state = IDLE;
            end
        endcase
    end 
endmodule