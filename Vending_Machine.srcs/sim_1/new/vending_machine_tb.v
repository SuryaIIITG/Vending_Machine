`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2024 12:44:33
// Design Name: 
// Module Name: vending_machine_tb
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


module vending_machine_tb;

    // Declare testbench signals
    reg clk;               // Clock signal
    reg rst;               // Reset signal
    reg [1:0] in;          // Input signal (money inserted)
    wire out;              // Output signal (product dispensed)
    wire [1:0] change;     // Change to be returned

    // Instantiate the vending_machine module
    vending_machine uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out),
        .change(change)
    );

    // Clock generation (50MHz clock, 20ns period)
    always begin
        #10 clk = ~clk;  // Toggle clock every 10ns (50MHz)
    end

    // Initial block to apply reset and stimuli
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        in = 2'b00;  // No money inserted initially

        // Apply reset
        $display("Applying reset...");
        rst = 1; #20;  // Apply reset for two clock cycles
        rst = 0; #20;  // Release reset

        // Test case 1: Insert 5rs (2'b01)
        $display("Inserting 5rs...");
        in = 2'b01; #20;  // Insert 5rs
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 00

        // Test case 2: Insert 10rs (2'b10)
        $display("Inserting 10rs...");
        in = 2'b10; #20;  // Insert 10rs
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 00

        // Test case 3: Return change for 5rs (after inserting 10rs, change = 5rs)
        $display("Returning change after 10rs inserted...");
        in = 2'b00; #20;  // No input, should return change (5rs)
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 01 (5rs)

        // Test case 4: Insert another 5rs to make 10rs
        $display("Inserting another 5rs to make 10rs...");
        in = 2'b01; #20;  // Insert another 5rs
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 00

        // Test case 5: Insert 10rs and dispense product
        $display("Inserting 10rs and dispensing product...");
        in = 2'b10; #20;  // Insert 10rs
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 00

        // Test case 6: Return 10rs as change after inserting 10rs
        $display("Returning 10rs as change...");
        in = 2'b00; #20;  // No input, should return 10rs
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 10

        // Test case 7: Insert 10rs, dispense product, and return 5rs change
        $display("Inserting 10rs, dispensing product, and returning 5rs...");
        in = 2'b10; #20;  // Insert 10rs
        $display("out = %b, change = %b", out, change);  // Expect: out = 0, change = 00

        // Insert 5rs for additional product or transition
        in = 2'b01; #20;  // Insert 5rs, should return product with 5rs change
        $display("out = %b, change = %b", out, change);  // Expect: out = 1, change = 01 (5rs)

        // End of simulation
        $stop;
    end

endmodule
