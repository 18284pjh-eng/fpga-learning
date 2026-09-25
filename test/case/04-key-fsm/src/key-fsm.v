`timescale 1ns/1ns

module key_fsm #(
   parameter CNT = 20'd1000_000 - 1
) (
   input wire clk, rst_n, key,
   output wire led
);

// need 1: current state register
always @(posedge clk or negedge rst_n)
   if (rst_n == 0)

// need 2: next state set
// need 3: output state short pulse

endmodule
