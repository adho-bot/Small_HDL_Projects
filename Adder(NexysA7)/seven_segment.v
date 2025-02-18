`timescale 1ns / 1ps
//7 segment display on Nexys A7
module seven_segment(
    input wire [3:0] input_switch,
    output reg [6:0] seg_7_out
    );
    
    
    always@(*) begin
        case(input_switch)
        0:seg_7_out = 7'b1000000;
        1:seg_7_out = 7'b1111001;
        2:seg_7_out = 7'b0100100;
        3:seg_7_out = 7'b0110000;
        4:seg_7_out = 7'b0011001;
        5:seg_7_out = 7'b0010010;
        6:seg_7_out = 7'b0000010;
        7:seg_7_out = 7'b1111000;
        8:seg_7_out = 7'b0000000;
        9:seg_7_out = 7'b0010000;
        10:seg_7_out = 7'b0001000;
        11:seg_7_out = 7'b0000011;
        12:seg_7_out = 7'b1000110;
        13:seg_7_out = 7'b0100001;
        14:seg_7_out = 7'b0000110;
        15:seg_7_out = 7'b0001110;
        endcase
    end 
endmodule
