`timescale 1ns / 1ps
module clk_div(input clock, output slow_clk);
parameter clk_div = 16;

reg [clk_div:0]clk_count;//divides by 2^16

    initial begin 
        clk_count = 0;
    end

always@(posedge clock) begin
clk_count <= clk_count + 1;
end 
assign slow_clk = clk_count[16];
endmodule
