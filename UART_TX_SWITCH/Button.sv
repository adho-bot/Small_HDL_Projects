`timescale 1ns / 1ps

module debounce (
    input clk,        // Clock signal
    input reset,      // Reset signal
    input din,        // Input signal (noisy)
    output reg dout   // Debounced output signal (rising edge)
);

    // Parameters for debounce period (adjust based on clock frequency)
    parameter DEBOUNCE_COUNT = 16; // Example: 16 clock cycles for debouncing

    // Debounce counter and state
    reg [15:0] debounce_counter; // Adjust width based on DEBOUNCE_COUNT
    reg din_stable;

    // Debounce logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debounce_counter <= 0;
            din_stable <= 1'b0;
        end else begin
            if (din != din_stable) begin
                // Input has changed, reset counter
                debounce_counter <= 0;
                din_stable <= din;
            end else if (debounce_counter < DEBOUNCE_COUNT) begin
                // Count until debounce period is reached
                debounce_counter <= debounce_counter + 1;
            end
        end
    end

    // Rising edge detection
    reg din_prev;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            din_prev <= 1'b0;
            dout <= 1'b0;
        end else begin
            din_prev <= din_stable;//occurs delta cycle later
            // Detect rising edge
            if (!din_prev && din_stable) begin
                dout <= 1'b1;
            end else begin
                dout <= 1'b0;
            end
        end
    end

endmodule


   /*
    // Double flopping synatx incase of differnt clock domains
    reg din_sync1, din_sync2;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            din_sync1 <= 1'b0;
            din_sync2 <= 1'b0;
        end else begin
            din_sync1 <= din;
            din_sync2 <= din_sync1;
        end
    end
    */
