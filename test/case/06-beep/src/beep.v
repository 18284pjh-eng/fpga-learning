`timescale 1ns/1ps

module beep #(
    parameter [29:0] DURATION_CNT_MAX = 25_000_000
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       key,
    output reg        beep
);

   reg [16:0] tone_cnt;
   reg [16:0] tone_cnt_max;
   reg [29:0] duration_cnt;
   reg [2:0] melody_fsm;
   // main clk = 50MHz
   localparam [2:0] NOTE_A = 3'd0;
   localparam [2:0] NOTE_B = 3'd1;
   localparam [2:0] NOTE_C = 3'd2;
   localparam [2:0] NOTE_D = 3'd3;
   localparam [2:0] NOTE_E = 3'd4;
   localparam [2:0] NOTE_F = 3'd5;
   localparam [2:0] NOTE_G = 3'd6;

   localparam [16:0] TONE_A = 17'd56818; // A4: 440Hz
   localparam [16:0] TONE_B = 17'd50618; // B4: 494Hz
   localparam [16:0] TONE_C = 17'd47777; // C5: 523Hz
   localparam [16:0] TONE_D = 17'd42565; // D5: 587Hz
   localparam [16:0] TONE_E = 17'd37921; // E5: 659Hz
   localparam [16:0] TONE_F = 17'd35792; // F5: 698Hz
   localparam [16:0] TONE_G = 17'd31887; // G5: 784Hz

   // update fsm--duration
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         duration_cnt <= 30'd0;
         melody_fsm <= NOTE_A;
      end else if (key) begin
         duration_cnt <= 30'd0;
         melody_fsm <= NOTE_A;
      end
      else if (duration_cnt == DURATION_CNT_MAX - 1) begin
         duration_cnt <= 30'd0;
         if (melody_fsm == NOTE_G)
            melody_fsm <= NOTE_A;
         else
            melody_fsm <= melody_fsm + 3'd1;
      end else begin
         duration_cnt <= duration_cnt + 30'd1;
      end
   end

   // update tone_cnt
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         tone_cnt <= 0;
         beep <= 1'd0;
      end else if (key) begin
         tone_cnt <= 0;
         beep <= 1'd0;
      end else if (duration_cnt == DURATION_CNT_MAX - 1) begin
         tone_cnt <= 17'd0;
         beep <= 1'd0;
      end else if (tone_cnt == tone_cnt_max - 1) begin
         beep <= ~beep;
         tone_cnt <= 0;
      end else tone_cnt <= tone_cnt + 17'd1;
   end

   // execution fsm
   always @(*) begin
      case (melody_fsm)
          NOTE_A: tone_cnt_max = TONE_A;
          NOTE_B: tone_cnt_max = TONE_B;
          NOTE_C: tone_cnt_max = TONE_C;
          NOTE_D: tone_cnt_max = TONE_D;
          NOTE_E: tone_cnt_max = TONE_E;
          NOTE_F: tone_cnt_max = TONE_F;
          NOTE_G: tone_cnt_max = TONE_G;
         default: tone_cnt_max = TONE_A;
      endcase
   end

endmodule
