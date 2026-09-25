`timescale 1ns/1ns

module key_filter #(
   parameter CNT = 20'd1000_000 - 1
) (
   input wire key, clk, rst_n,
   output reg led
);

// key_flag will change when 20ms, 20ms / 20ns == 1e6
reg [19:0] cnt;

reg key_ff1, key_ff2, key_prev, key_stable, key_flag;

always@(posedge clk) key_ff1 <= key;
always@(posedge clk) key_ff2 <= key_ff1;

always@(posedge clk or negedge rst_n)
   if (rst_n == 0) begin
      key_stable <= 1; cnt <= 0;
   end
   else if (key_ff2 != key_stable) begin
      if (cnt == CNT - 1) begin
         key_stable <= key_ff2;
         cnt <= 0;
      end else
         cnt <= cnt + 1;
   end else
      cnt <= 0;

always@(posedge clk or negedge rst_n)
   if (rst_n == 0) begin
      key_flag <= 0; key_prev <= 1;
   end
   else begin
      key_prev <= key_stable;
      key_flag <= key_prev & ~key_stable;
   end

always@(posedge clk or negedge rst_n)
   if (rst_n == 0) led <= 1;
   else if (key_flag) led <= ~led;

endmodule
