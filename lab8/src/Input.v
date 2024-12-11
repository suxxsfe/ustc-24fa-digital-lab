module Input(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,
    input                   [ 7 : 0]            sw,

    output                  [ 3 : 0]            hex,
    output                  [ 0 : 0]            pulse
);

reg [7:0] sw_reg_1, sw_reg_2, sw_reg_3;
always @(posedge clk) begin
    if(rst) begin
        sw_reg_1 <= 0;
        sw_reg_2 <= 0;
        sw_reg_3 <= 0;
    end
    else begin
        sw_reg_1 <= sw;
        sw_reg_2 <= sw_reg_1;
        sw_reg_3 <= sw_reg_2;
    end
end

wire [7:0] sw_change = sw_reg_1 & sw_reg_2 & (~sw_reg_3);
assign hex = sw_change[0] ? 0 : (sw_change[1] ? 1 : (sw_change[2] ? 2 :
             sw_change[3] ? 3 : (sw_change[4] ? 4 : (sw_change[5] ? 5 :
             sw_change[6] ? 6 : (sw_change[7] ? 7 : 0)))));
assign pulse = sw_change[0] | sw_change[1] | sw_change[2] | sw_change[3] |
               sw_change[4] | sw_change[5] | sw_change[6] | sw_change[7];

endmodule
