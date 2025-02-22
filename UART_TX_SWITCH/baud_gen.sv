`timescale 1ns / 1ps

module baud_gen#(
    parameter Clk_Freq = 32'd100000000,
    parameter Baud = 32'd115200,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    output reg baud_rate_tx,
    output reg baud_rate_rx
);
    
    localparam MAX_TX = Clk_Freq / Baud;
    localparam MAX_RX = Clk_Freq / (Baud * OVERSAMPLE);
    localparam WIDTH_TX = $clog2(MAX_TX);
    localparam WIDTH_RX = $clog2(MAX_RX);
        
    reg [WIDTH_TX - 1:0] accumulator_tx;
    reg [WIDTH_RX - 1:0] accumulator_rx;
    
    initial begin
        baud_rate_tx = 0;
        baud_rate_rx = 0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator_tx <= 0;
            baud_rate_tx <= 0;
        end else if (accumulator_tx == MAX_TX - 1) begin
            accumulator_tx <= 0;
            baud_rate_tx <= 1;
        end else begin
            accumulator_tx <= accumulator_tx + 1;
            baud_rate_tx <= 0;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator_rx <= 0;
            baud_rate_rx <= 0;
        end else if (accumulator_rx == MAX_RX - 1) begin
            accumulator_rx <= 0;
            baud_rate_rx <= 1;
        end else begin
            accumulator_rx <= accumulator_rx + 1;
            baud_rate_rx <= 0;
        end
    end    

endmodule
