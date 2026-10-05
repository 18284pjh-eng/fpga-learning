`timescale 1ns/1ps

module water_led #(
    parameter reg [19:0] PHASE_CNT_MAX = 500_000 - 1
) (
    input  wire       clk,
    input  wire       rst_n,
    output wire [3:0] led
);

    reg [19:0] phase_cnt;
    reg [7:0]  phase;
    reg [7:0]  pwm_cnt;

    wire        phase_tick;
    wire [7:0]  duty0, duty1, duty2, duty3;

    assign phase_tick = (phase_cnt == PHASE_CNT_MAX);

    // The four LUT instances are separated by 90 degrees of phase.
    sine_lut sine_lut_0 (
        .phase(phase),
        .duty(duty0)
    );

    sine_lut sine_lut_1 (
        .phase(phase + 8'd64),
        .duty(duty1)
    );

    sine_lut sine_lut_2 (
        .phase(phase + 8'd128),
        .duty(duty2)
    );

    sine_lut sine_lut_3 (
        .phase(phase + 8'd192),
        .duty(duty3)
    );

    // The board LEDs are active-low. pwm_cnt < duty means internally on.
    assign led[0] = ~(pwm_cnt < duty0);
    assign led[1] = ~(pwm_cnt < duty1);
    assign led[2] = ~(pwm_cnt < duty2);
    assign led[3] = ~(pwm_cnt < duty3);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_cnt <= 20'd0;
            phase     <= 8'd0;
            pwm_cnt   <= 8'd0;
        end else begin
            pwm_cnt <= pwm_cnt + 8'd1;

            if (phase_tick) begin
                phase_cnt <= 20'd0;
                phase     <= phase + 8'd1;
            end else begin
                phase_cnt <= phase_cnt + 20'd1;
            end
        end
    end

endmodule
