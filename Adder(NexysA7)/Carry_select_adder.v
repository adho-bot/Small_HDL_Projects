//Adder
module Carry_select_adder(
input [3:0] in1,
input [3:0] in2,
output [4:0] sum    
    );
    
    wire cout1, cout2, cout3, cout4;
    wire [3:0] sum_wire;
    
    adder1 instance1(in1[0], in2[0], 0, sum_wire[0], cout1); 
    adder1 instance2(in1[1], in2[1], cout1, sum_wire[1], cout2);
    adder1 instance3(in1[2], in2[2], cout2, sum_wire[2], cout3);    
    adder1 instance4(in1[3], in2[3], cout3, sum_wire[3], cout4);   
    assign sum = {cout4, sum_wire};  
endmodule
