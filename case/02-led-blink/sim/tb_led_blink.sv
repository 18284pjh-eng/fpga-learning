// import ../src/led_blink.v
`timescale 1ns/1ns

module top;

reg clk = 1'b1;
reg rst_n;
wire led;

led_blink #(.CNT(25'd249)) u_led_blink ( .*);

always #10ns clk = ~clk; // half period

initial begin
   rst_n = 0;
   #30ns rst_n = 1;
   #20000ns;
   $display("02-tb_led_blink simv SUCCESS");
   $stop;
end

endmodule
