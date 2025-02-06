module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
); 
    
    reg [2:0] state, next_state;
   	int counter;  // 5-bit counter to count falling time
    parameter LEFT = 0, RIGHT = 1, FALL_L = 2, FALL_R = 3, 
              DIG_L = 4, DIG_R = 5, SPLAT = 6;
    
    // Sequential logic: state update and counter update
    always @ (posedge clk or posedge areset) begin
        if(areset) begin
            state = LEFT;
        end else if(state == FALL_L || state == FALL_R)begin
            counter <= counter+1;
            state <= next_state;
        end
        else begin
            state <= next_state;
        	counter <= 0;
        end 
    end
    
    // Next State logic
    always @(*) begin
        case (state) 
            LEFT:   next_state = (!ground) ? FALL_L : (dig) ? DIG_L : (bump_left) ? RIGHT : LEFT;
            RIGHT:  next_state = (!ground) ? FALL_R : (dig) ? DIG_R : (bump_right) ? LEFT : RIGHT;
            
        	FALL_L: next_state = ground ? ((counter >= 20) ? SPLAT : LEFT) : FALL_L;
        	FALL_R: next_state = ground ? ((counter >= 20) ? SPLAT : RIGHT) : FALL_R;

            
            DIG_L:  next_state = (ground) ? DIG_L : FALL_L;
            DIG_R:  next_state = (ground) ? DIG_R : FALL_R;
            
            SPLAT:  next_state = SPLAT;
            
            default: next_state = LEFT;
        endcase
    end
    
    // Output logic
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L) | (state == FALL_R);
    assign digging    = (state == DIG_L) | (state == DIG_R);
    
endmodule
