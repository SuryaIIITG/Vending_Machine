`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2024 12:41:48
// Design Name: 
// Module Name: vending_machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vending_machine(
    input clk, rst, // clock and reset
    input [1:0] in, // 2-bit input for inserted money
    output reg out, // 1-bit output for product dispense (0: no, 1: yes)
    output reg [1:0] change // 2-bit output for change (00=0rs, 01=5rs, 10=10rs)
);
    // Define states for 0rs, 5rs, and 10rs
    parameter s0 = 2'b00; // 0rs (no money inserted)
    parameter s1 = 2'b01; // 5rs
    parameter s2 = 2'b10; // 10rs

    reg [1:0] c_state, n_state; // Current state and next state

    always @(posedge clk or posedge rst) begin
        if (rst) begin // Reset the machine
            c_state <= s0;   // Reset to state 0 (no money)
            n_state <= s0;
            change <= 2'b00;  // No change initially
            out <= 0;         // No product dispensed
        end else begin
            c_state <= n_state; // Update current state to next state
        end
    end

    // State machine logic for vending machine behavior
    always @(c_state or in) begin
        // Default values
        out = 0;      // Default to no product dispensed
        change = 2'b00;  // Default to no change

        case (c_state)
            s0: begin // No money inserted (0rs)
                if (in == 2'b01) begin // 5rs inserted
                    n_state = s1;
                    out = 0;
                    change = 2'b00;  // No change required yet
                end else if (in == 2'b10) begin // 10rs inserted
                    n_state = s2;
                    out = 0;
                    change = 2'b00;  // No change required yet
                end else begin
                    n_state = s0;
                end
            end

            s1: begin // 5rs inserted
                if (in == 2'b00) begin // No input, return 5rs
                    n_state = s0;
                    change = 2'b01;  // Return 5rs as change
                    out = 0;
                end else if (in == 2'b01) begin // Another 5rs inserted
                    n_state = s2;
                    out = 0;
                    change = 2'b00;  // No change required
                end else if (in == 2'b10) begin // 10rs inserted
                    n_state = s0;
                    out = 1;         // Dispense product
                    change = 2'b01;  // Return 5rs as change
                end else begin
                    n_state = s1; // Remain in state s1 if invalid input
                end
            end

            s2: begin // 10rs inserted
                if (in == 2'b00) begin // No input, return 10rs
                    n_state = s0;
                    change = 2'b10;  // Return 10rs as change
                    out = 0;
                end else if (in == 2'b01) begin // 5rs inserted
                    n_state = s0;
                    out = 1;         // Dispense product
                    change = 2'b00;  // No change
                end else if (in == 2'b10) begin // Another 10rs inserted
                    n_state = s0;
                    out = 1;         // Dispense product
                    change = 2'b01;  // Return 5rs as change
                end else begin
                    n_state = s2; // Remain in state s2 if invalid input
                end
            end

            default: begin // For safety, in case of invalid state
                n_state = s0;
                out = 0;
                change = 2'b00;
            end
        endcase
    end
endmodule
