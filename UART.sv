`timescale 1ns / 1ps


module UART(
    input clk,
    input reset,
    input [7:0] datain,
    input start_transmitting,

    output reg transmit

    );
    
    wire new_clk;
    
    //module instantiations
    uart_transmitter instance1(.clk(new_clk),.reset(reset),.start(start_transmitting),.databit(datain),.transmit(transmit));
    baud_gen instance2(.clk(clk),.baud_rate(new_clk));
    
    
    
    
endmodule

