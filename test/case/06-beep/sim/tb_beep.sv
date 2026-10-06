`timescale 1ns/1ps

module tb_beep;

    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg key = 1'b1;
    wire beep;
    integer errors = 0;

    localparam integer DURATION_MAX = 8;

    beep #(
        .DURATION_CNT_MAX(DURATION_MAX)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .key(key),
        .beep(beep)
    );

    always #5 clk = ~clk;

    task automatic tick(input integer n);
        repeat (n) @(posedge clk);
    endtask

    task automatic check(input integer condition, input [8*80-1:0] message);
        if (condition)
            $display("PASS: %0s", message);
        else begin
            $display("FAIL[%0d]: %0s", errors, message);
            errors = errors + 1;
        end
    endtask

    initial begin
       tick(2);
       #1;
       check(beep == 1'b0, "reset beep is low");
       check(dut.melody_fsm == 3'd0, "reset starts at note A");
       check(dut.duration_cnt == 30'd0, "reset duration counter");

       rst_n = 1'b1;
       tick(1);
       #1;
       check(beep == 1'b0, "released key keeps beep low");

       // Compress the tone divider so the testbench can observe toggles quickly.
       force dut.tone_cnt_max = 17'd2;
       key = 0;
       tick(1);
       #1;
       check(dut.tone_cnt == 17'd1, "tone counter advances while playing");
       tick(1);
       #1;
       check(beep == 1'b1, "tone toggles at the divider boundary");
       tick(2);
       #1;
       check(beep == 1'b0, "tone toggles at a fixed interval");

       tick(DURATION_MAX - 4);
       #1;
       check(dut.melody_fsm == 3'd1, "duration changes A to B");
       check(dut.duration_cnt == 30'd0, "duration counter clears at note boundary");
       check(beep == 1'b0, "beep clears at note boundary");

       tick(DURATION_MAX * 6);
       #1;
       check(dut.melody_fsm == 3'd0, "note sequence wraps G to A");

       release dut.tone_cnt_max;
       force dut.melody_fsm = 3'd1;
       #1;
       check(dut.tone_cnt_max == 17'd50618, "B4 divider is selected in state B");
       force dut.melody_fsm = 3'd0;
       #1;
       check(dut.tone_cnt_max == 17'd56818, "A4 divider is selected in state A");
       release dut.melody_fsm;

       key = 1'b1;
       tick(1);
       #1;
       check(beep == 1'b0, "released key stops beep");
       check(dut.melody_fsm == 3'd0, "released key resets to note A");
       check(dut.duration_cnt == 30'd0, "released key clears duration counter");

       if (errors == 0) begin
           $display("TEST PASS");
           $finish;
       end else begin
           $display("TEST FAIL: %0d error(s)", errors);
           $fatal(1, "testbench failed");
       end
    end

endmodule
