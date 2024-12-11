module Top2(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            btn,
    input                   [ 7 : 0]            sw,

    output                  [ 7 : 0]            led,
    output                  [ 2 : 0]            seg_an,
    output                  [ 3 : 0]            seg_data
);

wire rst = sw[7];

wire [7: 0] minute, second;
wire [11: 0] micro_second;
wire set, en;
wire finish;

wire [31: 0] input_number;
wire [3: 0] hex;
wire pulse, start, game_running, game_start;

wire [5: 0] result;

wire [1: 0] led_sel, seg_sel;

reg btn_reg1, btn_reg2;
wire btn_posedge;
always @(posedge clk) begin
    if(rst) begin
        btn_reg1 <= 0;
        btn_reg2 <= 0;
    end else begin
        btn_reg1 <= btn;
        btn_reg2 <= btn_reg1;
    end
end

assign btn_posedge = btn_reg1 & ~btn_reg2;

wire [11: 0] target;
Random random(
    .clk(clk), .rst(rst),
    .sw_seed(sw),
    .generate_random(game_start),
    
    .random_data(target)
);

Input input_(
    .clk(clk), .rst(rst),
    .sw({0, sw[6: 0]}),
    
    .hex(hex), .pulse(pulse)
);
ShiftReg shift_reg(
    .clk(clk), .rst(rst | ~game_running),
    .hex(hex), .pulse(pulse),
    
    .dout(input_number)
);

Timer timer(
    .clk(clk), .rst(rst),
    .set(set), .en(en),
    
    .minute(minute), .second(second), .micro_second(micro_second),
    .finish(finish)
);

Control control(
    .clk(clk), .rst(rst),
    .btn(btn_posedge),
    .check_result(result), .timer_finish(finish),
    
    .timer_en(en), .timer_set(set), .check_start(start),
    .led_sel(led_sel), .seg_sel(seg_sel),
    .game_running(game_running)
);
Check check(
    .clk(clk), .rst(rst),
    .input_number(input_number[11: 0]), .target_number(target),
    .start_check(start),
    
    .check_result(result)
);

assign led = led_sel[0] ? 8'b1111_1111 : {2'b00, result};

wire [31: 0] time_output;
Hex2BCD min(
    .hex({4'b0, minute}),
    .bcd2(time_output[31: 28]), .bcd3(time_output[27: 24])
);
Hex2BCD sec(
    .hex({4'b0, second}),
    .bcd2(time_output[23: 20]), .bcd3(time_output[19: 16])
);
assign time_output[15: 12] = 4'b0;
Hex2BCD msec(
    .num(micro_second),
    .bcd1(time_output[11: 8]), .bcd2(time_output[7: 4]), .bcd3(time_output[3: 0])
);

Segment segment(
    .clk(clk), .rst(rst),
    .output_data(seg_sel[1] ? 32'h4444_4444 :
                              (seg_sel[0] ? 32'h8888_8888 : time_output)),
    
    .seg_data(seg_data), .seg_an(seg_an)
);

endmodule

