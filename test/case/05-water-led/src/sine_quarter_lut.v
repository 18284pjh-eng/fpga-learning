module sine_lut (
    input  wire [7:0] phase,
    output wire [7:0] duty
);

function [7:0] sine_quarter_lut;
    input [5:0] index;
    begin
        case (index)
            6'd0:  sine_quarter_lut = 8'd128;
            6'd1:  sine_quarter_lut = 8'd131;
            6'd2:  sine_quarter_lut = 8'd134;
            6'd3:  sine_quarter_lut = 8'd137;
            6'd4:  sine_quarter_lut = 8'd140;
            6'd5:  sine_quarter_lut = 8'd143;
            6'd6:  sine_quarter_lut = 8'd147;
            6'd7:  sine_quarter_lut = 8'd150;
            6'd8:  sine_quarter_lut = 8'd153;
            6'd9:  sine_quarter_lut = 8'd156;
            6'd10: sine_quarter_lut = 8'd159;
            6'd11: sine_quarter_lut = 8'd162;
            6'd12: sine_quarter_lut = 8'd165;
            6'd13: sine_quarter_lut = 8'd168;
            6'd14: sine_quarter_lut = 8'd171;
            6'd15: sine_quarter_lut = 8'd174;
            6'd16: sine_quarter_lut = 8'd177;
            6'd17: sine_quarter_lut = 8'd180;
            6'd18: sine_quarter_lut = 8'd183;
            6'd19: sine_quarter_lut = 8'd186;
            6'd20: sine_quarter_lut = 8'd188;
            6'd21: sine_quarter_lut = 8'd191;
            6'd22: sine_quarter_lut = 8'd194;
            6'd23: sine_quarter_lut = 8'd197;
            6'd24: sine_quarter_lut = 8'd199;
            6'd25: sine_quarter_lut = 8'd202;
            6'd26: sine_quarter_lut = 8'd204;
            6'd27: sine_quarter_lut = 8'd207;
            6'd28: sine_quarter_lut = 8'd209;
            6'd29: sine_quarter_lut = 8'd212;
            6'd30: sine_quarter_lut = 8'd214;
            6'd31: sine_quarter_lut = 8'd217;
            6'd32: sine_quarter_lut = 8'd219;
            6'd33: sine_quarter_lut = 8'd221;
            6'd34: sine_quarter_lut = 8'd223;
            6'd35: sine_quarter_lut = 8'd225;
            6'd36: sine_quarter_lut = 8'd227;
            6'd37: sine_quarter_lut = 8'd229;
            6'd38: sine_quarter_lut = 8'd231;
            6'd39: sine_quarter_lut = 8'd233;
            6'd40: sine_quarter_lut = 8'd235;
            6'd41: sine_quarter_lut = 8'd236;
            6'd42: sine_quarter_lut = 8'd238;
            6'd43: sine_quarter_lut = 8'd239;
            6'd44: sine_quarter_lut = 8'd241;
            6'd45: sine_quarter_lut = 8'd242;
            6'd46: sine_quarter_lut = 8'd244;
            6'd47: sine_quarter_lut = 8'd245;
            6'd48: sine_quarter_lut = 8'd246;
            6'd49: sine_quarter_lut = 8'd247;
            6'd50: sine_quarter_lut = 8'd248;
            6'd51: sine_quarter_lut = 8'd249;
            6'd52: sine_quarter_lut = 8'd250;
            6'd53: sine_quarter_lut = 8'd251;
            6'd54: sine_quarter_lut = 8'd252;
            6'd55: sine_quarter_lut = 8'd252;
            6'd56: sine_quarter_lut = 8'd253;
            6'd57: sine_quarter_lut = 8'd254;
            6'd58: sine_quarter_lut = 8'd254;
            6'd59: sine_quarter_lut = 8'd254;
            6'd60: sine_quarter_lut = 8'd255;
            6'd61: sine_quarter_lut = 8'd255;
            6'd62: sine_quarter_lut = 8'd255;
            6'd63: sine_quarter_lut = 8'd255;
            default: sine_quarter_lut = 8'd128;
        endcase
    end
endfunction

function [7:0] sine_value;
    input [7:0] phase_value;
    reg [5:0] index;
    begin
        case (phase_value[7:6])
            2'b00: begin
                index = phase_value[5:0];
                sine_value = sine_quarter_lut(index);
            end
            2'b01: begin
                index = ~phase_value[5:0];
                sine_value = sine_quarter_lut(index);
            end
            2'b10: begin
                index = phase_value[5:0];
                sine_value = 8'd255 - sine_quarter_lut(index);
            end
            2'b11: begin
                index = ~phase_value[5:0];
                sine_value = 8'd255 - sine_quarter_lut(index);
            end
            default: sine_value = 8'd128;
        endcase
    end
endfunction

assign duty = sine_value(phase);

endmodule
