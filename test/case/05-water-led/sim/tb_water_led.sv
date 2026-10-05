`timescale 1ns/1ps

module tb_water_led;

    reg clk = 1'b0;
    reg rst_n = 1'b0;
    wire [3:0] led;
    integer errors = 0;

    localparam integer PHASE_MAX = 3;

    water_led #(
        .PHASE_CNT_MAX(PHASE_MAX)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .led(led)
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
        check(dut.phase == 8'd0, "reset phase");
        check(dut.pwm_cnt == 8'd0, "reset PWM counter");

        rst_n = 1'b1;
        #1;
        check(dut.duty0 == 8'd128, "phase 0 duty");
        check(dut.duty1 == 8'd255, "phase 0 plus 90 degrees duty");
        check(dut.duty2 == 8'd127, "phase 0 plus 180 degrees duty");
        check(dut.duty3 == 8'd0, "phase 0 plus 270 degrees duty");

        tick(PHASE_MAX + 1);
        #1;
        check(dut.phase == 8'd1, "phase increments after one phase period");

        force dut.phase = 8'd64;
        #1;
        check(dut.duty0 == 8'd255, "quarter-cycle maximum");
        release dut.phase;

        force dut.phase = 8'd128;
        #1;
        check(dut.duty0 == 8'd127, "half-cycle midpoint");
        release dut.phase;

        force dut.phase = 8'd192;
        #1;
        check(dut.duty0 == 8'd0, "three-quarter-cycle minimum");
        release dut.phase;

        force dut.phase = 8'd0;
        force dut.pwm_cnt = 8'd0;
        #1;
        check(led == 4'b1000, "PWM low count produces expected active-low outputs");
        release dut.pwm_cnt;

        force dut.pwm_cnt = 8'd200;
        #1;
        check(led == 4'b1101, "PWM high count changes duty outputs");
        release dut.pwm_cnt;
        release dut.phase;

        if (errors == 0) begin
            $display("TEST PASS");
            $finish;
        end else begin
            $display("TEST FAIL: %0d error(s)", errors);
            $fatal(1, "testbench failed");
        end
    end

endmodule
