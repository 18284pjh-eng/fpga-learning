`timescale 1ns/1ns

module tb_key_filter;

reg clk = 1'b1;
reg rst_n; reg key;
wire led;

parameter integer T_STABLE = 3000;
key_filter #(.CNT(25'd99)) u_key_filter ( .*);

always #10ns clk = ~clk; // clk: 20ns -- 50MHz

//random 20-200ns for simulate outside jitter
task automatic press_key();
   for (int i = 0; i < 8; i++) begin
      key = $urandom_range(1, 0);
      #(20 + $urandom_range(180, 0));
   end
   key = 0;
   #(T_STABLE);
   key = 1;
   #(T_STABLE);

endtask

initial begin
   rst_n = 0;
   #30ns rst_n = 1;
   $display("press_key-1");
   #30ns press_key();
   $display("press_key-2");
   #30ns press_key();
   $stop;
end
endmodule
