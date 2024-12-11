module game_tb();

reg clk;
initial begin
    clk = 0;
    forever begin
        #5 clk = ~clk;
    end
end

reg rst, btn;
reg [7: 0] sw;

wire [7: 0] minute, second;
wire [11: 0] micro_second;
wire set, en;
wire finish;

wire [31: 0] input_number;
reg [11: 0] target;
wire [3: 0] hex;
wire pulse, start;
wire [5: 0] result;

wire led_sel, seg_sel;

initial begin
    target = 12'b0000_0001_0010;
    sw = 0;

    rst = 1;
    #20;
    rst = 0;
    #20
    btn = 1;
    #20
    btn = 0;
    #100
    sw = 8'b0000_0100;
    #100000
    sw = 8'b0000_0001;
    #100000
    sw = 8'b0000_0010;
    #100000
    btn = 1;
    # 20
    btn = 0;
    # 20
    sw = 8'b0000_0100;
    #100000
    btn = 1;
    # 20
    btn = 0;
    # 20
    sw = 0;
    
    rst = 1;
    #20;
    rst = 0;
    #20
    btn = 1;
    #20
    btn = 0;
    #100
    sw = 8'b0000_0001;
    #100000
    sw = 8'b0000_0010;
    #100000
    sw = 8'b0000_0100;
    #100000
    btn = 1;
    # 20
    btn = 0;
    # 20
    sw = 0;
    $finish;
end

Input input_(
    .clk(clk), .rst(rst),
    .sw(sw),
    
    .hex(hex), .pulse(pulse)
);
ShiftReg shift_reg(
    .clk(clk), .rst(rst),
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
    .btn(btn),
    .check_result(result), .timer_finish(finish),
    
    .timer_en(en), .timer_set(set), .check_start(start),
    .led_sel(led_sel), .seg_sel(seg_sel)
);
Check check(
    .clk(clk), .rst(rst),
    .input_number(input_number[11: 0]), .target_number(target),
    .start_check(start),
    
    .check_result(result)
);

endmodule

