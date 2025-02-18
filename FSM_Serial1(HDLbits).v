module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 

    parameter IDLE = 0, START = 1, STOP = 2, ERROR = 3, DATA = 4;
    reg [2:0]state, next_state;
    reg [3:0] counter = 0;
    always@(posedge clk) begin
        if(reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end      
    end
    
    always @(posedge clk) begin
        if(reset || state != DATA) begin
           counter <=0; 
        end else begin
            counter <= counter + 1;
        end
    end
    
    always@(*) begin
        case(state)
            IDLE:next_state = (!in) ? START:IDLE;
            START: next_state = DATA;
            DATA: begin
                if(counter < 7) begin
                    next_state = DATA;
                end else if(counter == 7 && in == 1) begin
                	next_state = STOP; 
                end else begin
                    next_state = ERROR;
                end 
            end
            STOP: next_state = (in == 1) ? IDLE : START;
            ERROR:next_state = (in == 1)? IDLE : ERROR;
         	default: next_state = IDLE;   
        endcase 
    end
    
    assign done = (state==STOP);
endmodule
