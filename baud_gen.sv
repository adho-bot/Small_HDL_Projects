`timescale 1ns / 1ps

module baud_gen#(
    parameter Clk_Freq = 32'd10000000,
    parameter Baud = 32'd115200,
    parameter INCREMENT = $rtoi((Baud * 65536.0) / Clk_Freq)//division is wrong without $rtoi and decimal points
)(
    input clk,
    input reset,
    output baud_rate
);
    
    reg [16:0] accumulator;
    
    always @(posedge clk) begin
        if(reset) begin
            accumulator <= 0;
        end else begin 
            accumulator <= accumulator + INCREMENT[16:0];
        end
    end
    
    assign baud_rate = accumulator[16];
endmodule