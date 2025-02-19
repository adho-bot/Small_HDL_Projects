`timescale 1ns / 1ps

module uart_transmitter (
    input clk,
    input reset,            
    input [7:0] databit,
    output reg transmit
);

    reg [1:0] state, next_state;
    reg [2:0] counter; 
    
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    always@(posedge clk or posedge reset) begin
        if(reset || state != DATA) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
        
    always@(*) begin
        case(state) 
        IDLE: begin
            transmit =  1;
            next_state = START;
        end
        START: begin
            transmit = 0;
            next_state = DATA;
        end
        DATA: begin
                transmit = databit[counter];
                if(counter == 7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
        STOP:begin
            transmit = 1;
            next_state = START;
        end
        default:next_state = IDLE;
        endcase
    end 
endmodule
