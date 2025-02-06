HDLBits HDLBits
Problem Set
Browse Problem Set
Problem Set Stats
User Rank List
Simulation
Run a Simulation (Icarus Verilog)
garyi_ct's Profile
Log in/out
Profile Settings
My Stats
Help
Getting Started
About HDLBits
Bugs and Suggestions
01xz.net
01xz.net Home
HDLBits — Verilog practice
ASMBits — Assembly language practice
CPUlator — Nios II, ARMv7, and MIPS simulator
Search HDLBits
 Search
Lemmings4
lemmings3PreviousNextfsm_onehot

See also: Lemmings1, Lemmings2, and Lemmings3.

Although Lemmings can walk, fall, and dig, Lemmings aren't invulnerable. If a Lemming falls for too long then hits the ground, it can splatter. In particular, if a Lemming falls for more than 20 clock cycles then hits the ground, it will splatter and cease walking, falling, or digging (all 4 outputs become 0), forever (Or until the FSM gets reset). There is no upper limit on how far a Lemming can fall before hitting the ground. Lemmings only splatter when hitting the ground; they do not splatter in mid-air.

Extend your finite state machine to model this behaviour.

Falling for 20 cycles is survivable:
1
2
3
...
18
19
20
clk
ground
walk_left
aaah

Falling for 21 cycles causes splatter:
1
2
3
...
18
19
20
21
oops
clk
ground
walk_left
aaah

Module Declaration
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
    output digging ); 
Hint...
Write your solution here

[Load a previous submission]
Load
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
​
            
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
​
 
Upload a source file... 


fsm3combfsm3onehotfsm3fsm3sexams/ece241_2013_q4lemmings1lemmings2lemmings3 ·
lemmings4

 
· fsm_onehotfsm_ps2fsm_ps2datafsm_serialfsm_serialdatafsm_serialdpfsm_hdlcexams/ece241_2013_q8
lemmings3PreviousNextfsm_onehot
This page was last edited on 23 March 2020, at 03:33.
About HDLBits