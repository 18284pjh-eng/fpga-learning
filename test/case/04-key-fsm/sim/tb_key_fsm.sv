`timescale 1ns/1ps

module tb_key_fsm;
   reg clk = 1'b0;
   reg rst_n = 1'b0;
   reg key = 1'b1;
   wire led;
   integer errors = 0;
   integer short_pulse_count = 0;

   localparam integer DEBOUNCE_CNT = 3;
   localparam integer BLINK_DIV_CNT = 4;
   localparam integer LONG_PRESS_CNT = 8;

   always #5 clk = ~clk;
   always @(posedge clk) begin
      if (dut.short_pulse) short_pulse_count = short_pulse_count + 1;
   end

   key_fsm #(
      .CNT_MAX(DEBOUNCE_CNT),
      .BLINK_DIV_MAX(BLINK_DIV_CNT),
      .LONG_CNT_MAX(LONG_PRESS_CNT)
   ) dut (
         .clk(clk), .rst_n(rst_n), .key(key), .led(led)
   );

   task automatic tick(input integer n);
      repeat (n) @(posedge clk);
   endtask

   task automatic check (input integer condition, input [8*80-1:0] message);
      if (condition) $display("PASS: %0s", message);
      else begin
         $display("FAIL: %0s", message);
         errors = errors + 1;
      end
   endtask

   initial begin
      tick(4);
      rst_n = 1;
      tick(3);
      //reset
      check(dut.cur_state == 0, "cur_state");
      check(dut.short_pulse == 0, "short_pulse");
      check(dut.long_enable == 0, "long_enable");

      // short_pulse
      key = 0;
      tick(2);
      tick(4);
      key = 1;
      tick(6);
      #1ns check(dut.short_pulse == 1, "trigger short_pulse");
      tick(4);
      check(dut.led == 0, "led flip");
      check(short_pulse_count == 1, "short_pulse lasts one cycle");
      check(dut.long_enable == 0, "short press has no long enable");
      tick(10);

      // long_enable
      key = 0;
      tick(7);
      check(dut.cur_state == 2'd1, "held key enters PRESSED");
      tick(9);
      check(dut.cur_state == 2'd2, "long press enters LONG");
      tick(1);
      check(dut.long_enable == 1, "long enable is active");
      check(dut.led == 0, "led starts long press low");
      tick(BLINK_DIV_CNT + 2);
      check(dut.led == 1, "long press blinks led");
      tick(4);
      tick(4);
      key = 1;
      tick(6);
      tick(3);
      check(dut.cur_state == 2'd0, "release returns to IDLE");
      check(dut.long_enable == 0, "release clears long enable");

      // illegal state force
      force dut.cur_state = 2'b11;
      @(posedge clk);
      #1 check(dut.next_state == 2'd0, "illegal state returns to IDLE");
      release dut.cur_state;

      // error check
      if (errors == 0) begin
         $display("TEST PASS");
         $finish;
      end else begin
         $display("TEST FAIL: %0d errors", errors);
         $fatal(1, "testbench failed");
      end
   end
endmodule
