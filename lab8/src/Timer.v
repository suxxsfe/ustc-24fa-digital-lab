module Timer(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [ 0 : 0]            set,
    input                   [ 0 : 0]            en,

    output      reg         [ 7 : 0]            minute,
    output      reg         [ 7 : 0]            second,
    output      reg         [11 : 0]            micro_second,

    output                  [ 0 : 0]            finish
);

localparam SECOND_MAX = 59;
localparam MSECOND_MAX = 999;

wire go;
Counter #(.MAX_VALUE(32'd100_000)) counter(
    .clk(clk), .rst(rst),
    .out(go)
);

always @(posedge clk) begin
    if(rst) begin
        minute <= -1;
        second<= -1;
        micro_second<= -1;
    end else if(set) begin
        minute <= 8'd1;
        second<= 0;
        micro_second<= 0;
    end else if(!second && !micro_second && !minute) begin
        second <= -1;
        micro_second <= -1;
        minute <= -1;
    end else if(en && go) begin
        if(!second && !micro_second) begin
            minute <= minute - 1;
            second <= SECOND_MAX;
            micro_second <= MSECOND_MAX;
        end else if(!micro_second) begin
            second <= second - 1;
            micro_second <= MSECOND_MAX;
        end else begin
            micro_second <= micro_second - 1;
        end
    end
end

assign finish = !minute && !second && !micro_second;

endmodule
