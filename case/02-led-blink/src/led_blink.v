`timescale 1ns/1ns

module led_blink #(
   parameter CNT = 25'd25_000_000 - 1 // 20ns * 25_000_000 = 500ms
)(
   input wire clk, rst_n,
   output reg led
);

reg [24:0] cnt;
reg cnt_flag;

always@(posedge clk or negedge rst_n)
   if(rst_n == 0) begin
      cnt <= 0;
      cnt_flag <= 0;
   else if(cnt == CNT) begin
      cnt <= 0;
      cnt_lfag <= 1;
   end
   else cnt <= cnt + 'd1;

always@(posedge clk or negedge rst_n)
   if(rst_n == 0) led <= 0;
   else if (cnt_flag == 1) led <= ~led;

endmodule
