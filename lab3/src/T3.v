module T3(
    input                       clk,
    input                       rst,
    input       [31:0]          output_data,

    output reg  [ 3:0]          seg_data,
    output reg  [ 2:0]          seg_an
);

reg [31:0] counter;
reg [2:0] seg_id;
parameter TIME_CNT = 250_000;

always @(posedge clk) begin
	if(rst) begin
		counter <= 0;
	end
	else  begin
		if(counter >= TIME_CNT) begin
			counter <= 0;
		end
		else begin
			counter <= counter + 32'd1;
		end
	end
end

always @(posedge clk) begin
	if(rst) begin
		seg_id <= 0;
	end
    else if(counter >= TIME_CNT) begin
		seg_id <= seg_id+3'd1;
	end
end

always @(*) begin
    seg_data = 0;
    seg_an = seg_id;
	seg_data = {output_data[seg_id*4+3], output_data[seg_id*4+2],
				output_data[seg_id*4+1], output_data[seg_id*4]};
end

endmodule
