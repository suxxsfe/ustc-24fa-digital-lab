module Top2(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            btn,
    input                   [ 7 : 0]            sw,
    input                   [ 0 : 0]            uart_din,

    output                  [ 7 : 0]            led,
    output                  [ 2 : 0]            seg_an,
    output                  [ 3 : 0]            seg_data,
    output                  [ 0 : 0]            uart_dout
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

/******* get posedge of btn *******/
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

/******** random target ********/
wire [11: 0] target;
Random random(
    .clk(clk), .rst(rst),
    .sw_seed(sw),
    .generate_random(game_start),
    
    .random_data(target)
);

/********* command ***********/
reg [7: 0] last_din;
wire [7: 0] din;
wire din_vld, output_status;
reg force_new_game, pause;
reg [11: 0] dout_data;
reg [1: 0] output_answer;
reg start_send;
always @(posedge clk) begin
    force_new_game <= 0;
    if(rst) begin
        last_din <= 0;
        pause <= 0;
        dout_data <= 0;
        output_answer <= 0;
        start_send <= 0;
    end else begin
        if(output_status && output_answer) begin
            start_send <= 1;
        end else if(!output_status && start_send) begin
            start_send <= 0;
            output_answer <= output_answer - 1;
            dout_data <= {dout_data[7: 0], 4'b0};
        end
        
        if(din_vld) begin
            if(din == 8'h3B) begin // ';'
                if(last_din == 8'h70) begin // 'p'
                    pause <= ~pause;
                end else if(last_din == 8'h6E) begin // 'n'
                    force_new_game <= 1;
                end else if(last_din == 8'h61) begin // 'a'
                    output_answer <= 3;
                    dout_data <= target;
                end
            end
            last_din <= din;
        end
    end
end
Receive receive(
    .clk(clk), .rst(rst),
    .din(uart_din),
    
    .din_vld(din_vld), .din_data(din)
);
Send send(
    .clk(clk), .rst(rst),
    .dout_vld(start_send),
    .dout_data({4'b0011, dout_data[11: 8]}), // 0011_0000 = 48
    
    .dout(uart_dout), .finish(output_status)
);

/*********** modules *********/
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
    .set(set), .en(en & ~pause),
    
    .minute(minute), .second(second), .micro_second(micro_second),
    .finish(finish)
);

Control control(
    .clk(clk), .rst(rst),
    .btn(btn_posedge),
    .check_result(result), .timer_finish(finish),
    .force_new_game(force_new_game),
    
    .timer_en(en), .timer_set(set), .check_start(start),
    .led_sel(led_sel), .seg_sel(seg_sel),
    .game_running(game_running), .game_start(game_start)
);
Check check(
    .clk(clk), .rst(rst),
    .input_number(input_number[11: 0]), .target_number(target),
    .start_check(start),
    
    .check_result(result)
);


/******** output ********/
assign led = led_sel[0] ? 8'b1111_1111 : {2'b00, result};

wire [11: 0] min_output, sec_output, msec_output;
Hex2BCD min(
    .hex({4'b0, minute}),
    .bcd(min_output)
);
Hex2BCD sec(
    .hex({4'b0, second}),
    .bcd(sec_output)
);
Hex2BCD msec(
    .hex(micro_second),
    .bcd(msec_output)
);

reg [31: 0] counter;
localparam TIME_MAX = 100_000_000;
localparam TIME_1 = 25_000_000;
localparam TIME_2 = 50_000_000;
localparam TIME_3 = 75_000_000;
always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
    end else begin
        counter <= counter == TIME_MAX ? 0 : (counter + 1);
    end
end
Segment segment(
    .clk(clk), .rst(rst),
    .output_data(seg_sel[1] ? 32'h4444_4444 : (seg_sel[0] ? 32'h8888_8888 :
                {min_output[7: 0], sec_output[7: 0], 4'b0, msec_output})),
    .output_valid((seg_sel != 2'b00 || second >= 10 ||
                   (second >=3 && second < 10 && counter < TIME_2) ||
                   (second < 3 && (counter < TIME_1 || (counter >= TIME_2 && counter <= TIME_3))))          ? 8'b1111_1111 : 8'b0000_0000),
    
    .seg_data(seg_data), .seg_an(seg_an)
);


endmodule

