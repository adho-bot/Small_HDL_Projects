`timescale 1ns / 1ps

//1 bit adder
module adder1(input a, input b, input cin, output sum, output cout);
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (cin & (a ^ b));
endmodule
