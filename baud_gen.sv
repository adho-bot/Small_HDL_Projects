module baud_gen(
    input clk,
    output baud_rate
    );
    parameter Clk_Freq = 10000000;
    parameter Baud = 115200;
    parameter BaudGeneratorAccWidth = 16;
    parameter BaudGeneratorInc = (Baud << BaudGeneratorAccWidth - 4)+(Clk_Freq >>5)/(Clk_Freq>>4);
    
    reg[BaudGeneratorAccWidth:0]BaudGeneratorAcc;
    
    always@(posedge clk)begin
        BaudGeneratorAcc <= BaudGeneratorAcc[BaudGeneratorAccWidth - 1:0] + BaudGeneratorInc;
    end
    
    assign baud_rate = BaudGeneratorAcc[BaudGeneratorAccWidth];
    
    
    
endmodule