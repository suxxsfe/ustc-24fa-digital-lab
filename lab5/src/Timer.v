module Timer(
    input                        clk, rst,
    output           [3:0]       out,
    output           [2:0]       select
);

wire go;
reg [3:0] hour;
reg [3:0] minLow, minHigh, secLow, secHigh;

Counter #(
    .MAX_VALUE(32'd100_000_000)
) counter(
    .clk(clk),
    .rst(rst),
    .out(go)
);

always @(posedge clk) begin
    if(rst) begin
        hour <= 4'd9;
        minHigh <= 4'd5;
        minLow <= 4'd8;
        secHigh <= 4'd3;
        secLow <= 4'd0;
    end
    else if(go) begin
        if(secLow == 4'd9) begin
            secLow <= 0;
            if(secHigh == 4'd5) begin
                secHigh <= 0;
                if(minLow == 4'd9) begin
                    minLow <= 0;
                    minHigh <= minHigh == 4'd5 ?
                               0 : (minHigh+1);
                    hour <= minHigh ==4'd5 ?
                            (hour == 4'd11 ? 0 : (hour+1)) : hour;
                end
                else begin
                    minLow <= minLow+1;
                end
            end
            else begin
                secHigh <= secHigh+1;
            end
        end
        else begin
            secLow <= secLow+1;
        end
    end
end

Segment(
    .clk(clk),
    .rst(rst),
    .output_data({
        {12{0}},
        hour[3:0],
        minHigh[3:0], minLow[3:0],
        secHigh[3:0], secLow[3:0]
    }),
    .seg_data(out),
    .seg_an(select)
);

endmodule
