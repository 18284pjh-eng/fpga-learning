`timescale 1ns/1ns

module key_fsm #(
   parameter CNT_MAX = 20'd1000_000 - 1,
   parameter BLINK_DIV_MAX = 22'd4_000_000 - 1,
   parameter LONG_CNT_MAX = 26'd50_000_000 - 1
) (
   input wire clk, rst_n, key,
   output reg led
);

reg [19:0] debounce_cnt;
reg [21:0] blink_div_cnt;
reg [25:0] long_press_cnt;
wire long_press_done;

reg key_ff1, key_ff2;
reg key_stable;
reg short_pulse, long_enable;

localparam [1:0] IDLE    = 2'd0;
localparam [1:0] PRESSED = 2'd1;
localparam [1:0] LONG    = 2'd2;
reg [1:0] next_state;
reg [1:0] cur_state;

// generate key_stable
always @(posedge clk) key_ff1 <= key;
always @(posedge clk) key_ff2 <= key_ff1;

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      key_stable <= 1'b1;
      debounce_cnt <= 20'd0;
   end else if (key_ff2 != key_stable) begin
      if (debounce_cnt == CNT_MAX - 1) begin
         key_stable <= key_ff2;
         debounce_cnt <= 20'd0;
      end else debounce_cnt <= debounce_cnt + 1'b1;

   end else  debounce_cnt <= 20'd0;
end

// current state register
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) cur_state <= IDLE;
   else cur_state <= next_state;
end

// next state set
always @(*) begin
   next_state = cur_state;
   case (cur_state)
      IDLE: if (!key_stable) next_state = PRESSED;
      PRESSED: begin
         if (key_stable) next_state = IDLE;
         else if (long_press_done) next_state = LONG;
      end
      LONG: if (key_stable) next_state = IDLE;
      default: next_state = IDLE;
   endcase
end

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) long_press_cnt <= 26'd0;
   else if (cur_state != PRESSED || key_stable) long_press_cnt <= 26'd0;
   else if (long_press_cnt < LONG_CNT_MAX) long_press_cnt <= long_press_cnt + 1'b1;
end

assign long_press_done = (long_press_cnt >= LONG_CNT_MAX);

// output state short/long pulse
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      short_pulse <= 1'b0;
      long_enable <= 1'b0;
   end else begin
      short_pulse <= 1'b0;
      long_enable <= 1'b0;

      if (cur_state == PRESSED && key_stable) short_pulse <= 1'b1;

      if (cur_state == LONG) long_enable <= 1'b1;
   end
end

// led output
always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      led <= 1'b1;
      blink_div_cnt <= 22'd0;
   end

   else if (short_pulse) begin
      led <= ~led;
      blink_div_cnt <= 22'd0;
   end else if (long_enable) begin
      if (blink_div_cnt == BLINK_DIV_MAX) begin
         led <= ~led;
         blink_div_cnt <= 22'd0;
      end else blink_div_cnt <= blink_div_cnt + 1'b1;
   end else begin
      blink_div_cnt <= 22'd0;
   end
end


endmodule
