module Send(
    input                   [ 0 : 0]        clk, 
    input                   [ 0 : 0]        rst,

    output      reg         [ 0 : 0]        dout,

    input                   [ 0 : 0]        dout_vld,
    input                   [ 7 : 0]        dout_data
);

// Counter and parameters
localparam FullT        = 10416;
localparam TOTAL_BITS   = 9;
reg [ 15: 0] div_cnt;           // 分频计数器，范围 0 ~ 867
reg [ 4 : 0] dout_cnt;          // 位计数器，范围 0 ~ 9    

// Main FSM
localparam WAIT     = 0;
localparam SEND     = 1;
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
        if(dout_vld) begin
            next_state = SEND;
        end
    end
    else begin
        if(dout_cnt == TOTAL_BITS) begin
            next_state = WAIT;
        end
    end
end

// Counter
always @(posedge clk) begin
    if(rst) begin
        div_cnt <= 0;
        dout_cnt <= 0;
    end else if (current_state == SEND) begin
        if(div_cnt == FullT) begin
            div_cnt <= 0;
            dout_cnt <= dout_cnt + 1;
        end else begin
            div_cnt <= div_cnt + 1;
        end
    end else begin
        div_cnt <= 0;
        dout_cnt <= 0;
    end
end

reg [7 : 0] temp_data;      // 用于保留待发送数据，这样就不怕 dout_data 的变化了
always @(posedge clk) begin
    if (rst)
        temp_data <= 8'H0;
    else if (current_state == WAIT && dout_vld)
        temp_data <= dout_data;
end

always @(posedge clk) begin
    if (rst)
        dout <= 1'B1;
    else if(current_state == WAIT) begin
        dout <= 1'b1;
    end
    else begin
        dout <= dout_cnt == 0 ? 1'b0 :
                (dout_cnt == TOTAL_BITS ? 1'b1 : temp_data[dout_cnt - 1]);
    end
end
endmodule
