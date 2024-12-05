module Receive(
    input                   [ 0 : 0]        clk,
    input                   [ 0 : 0]        rst,

    input                   [ 0 : 0]        din,

    output      reg         [ 0 : 0]        din_vld,
    output      reg         [ 7 : 0]        din_data
);

// Counter and parameters
localparam FullT        = 10416;
localparam HalfT        = 5208;
localparam TOTAL_BITS   = 8;
reg [15 : 0] div_cnt;       // 分频计数器，范围 0 ~ 867
reg [ 3 : 0] din_cnt;       // 位计数器，范围 0 ~ 8

// Main FSM
localparam WAIT     = 0;
localparam RECEIVE  = 1;
reg current_state, next_state;
always @(posedge clk) begin
    if (rst)
        current_state <= WAIT;
    else
        current_state <= next_state;
end

always @(*) begin
    next_state = current_state;
    if(current_state == WAIT) begin
        if(div_cnt == FullT - 1) begin
            next_state = RECEIVE;
        end
    end
    else if(din_cnt == TOTAL_BITS && div_cnt == FullT) begin
        next_state = WAIT;
    end
end

// Counter
always @(posedge clk) begin
    if (rst)
        div_cnt <= 16'D0;
    else if (current_state == WAIT) begin // STATE WAIT
        if(!din) begin
            div_cnt = div_cnt > HalfT ? (div_cnt + 1) : (HalfT + 1);
        end else begin
            div_cnt = div_cnt == HalfT ? 0 : (div_cnt + 1);
        end
    end
    else begin  // STATE RECEIVE
        div_cnt = div_cnt == FullT ? 0 : (div_cnt + 1);
    end
end

always @(posedge clk) begin
    if(rst || current_state == WAIT) begin
        din_cnt <= -1;
    end else if(div_cnt == FullT) begin
        din_cnt <= din_cnt + 1;
    end
end


// Output signals
reg [ 0 : 0] accept_din;    // 位采样信号
always @(*) begin
    accept_din = (div_cnt == FullT && din_cnt != TOTAL_BITS && din_cnt != -1);
end

always @(*) begin
    din_vld = (din_cnt == TOTAL_BITS && div_cnt == FullT);
end

always @(posedge clk) begin
    if (rst)
        din_data <= 8'B0;
    else if (current_state == WAIT)
        din_data <= 8'B0;
    else if (accept_din)
        din_data <= din_data | (din << din_cnt);
end
endmodule
