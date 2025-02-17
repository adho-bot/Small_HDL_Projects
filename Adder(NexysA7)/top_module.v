`timescale 1ns / 1ps

module top_module(
input  clk,
input  [3:0] sw,// sw 0-3
input [3:0] sw2, //sw 4-7
output reg [6:0] disp,
output reg[7:0] an,
output  dp
);
    //multi display
    wire [6:0] disp1, disp2, disp3;
    reg [1:0]disp_select;
    
    //clock
    wire clk_1khz;
    
    wire [4:0]adder_sum;
    
    //INSTANCE INSTANTIATIONS-------------------------------------------------
    //7 seg
    seven_segment instance1(.input_switch(sw), .seg_7_out(disp1));
    seven_segment instance2(.input_switch(sw2), .seg_7_out(disp2));
    seven_segment instance3(.input_switch(adder_sum), .seg_7_out(disp3));
    
    //Adder
    Carry_select_adder adder_instance(.in1(sw),.in2(sw2),.sum(adder_sum));
    
    //Clk div
    clk_div clk_instance(.clock(clk),.slow_clk(clk_1khz));
    
    assign dp = 1;//dp off
    initial begin
        disp_select = 0; // Initialize disp_select to 0
    end
    always@(posedge clk_1khz) begin
        disp_select <= disp_select + 1;
    end

    always@(*) begin
        case(disp_select) 
        0: begin
                an = 8'b11111110; 
                disp = disp1;
           end
        1: begin
                an = 8'b11111101; 
                disp = disp2;
           end
        2: begin
                an = 8'b11101111; 
                disp = disp3;
           end         
        default: begin
                    an = 8'b11111111; // Avoid undefined states
                    disp = 7'b0000000;
                 end
        endcase
    end
endmodule
