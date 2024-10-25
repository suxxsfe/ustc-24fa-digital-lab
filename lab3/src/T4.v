module T4(
    input                       clk,
    input                       rst,
    input       [31:0]          output_data,
	input       [ 7:0]          output_valid,

    output reg  [ 3:0]          seg_data,
    output reg  [ 2:0]          seg_an
);

reg [31:0] counter;
reg [2:0] seg_id;
reg [2:0] now_id;
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
		now_id <= 0;
	end
    else if(counter >= TIME_CNT) begin
		now_id <= now_id+3'd1;
		if(now_id == 0 || output_valid[now_id]) begin
		    seg_id <= now_id;
		end
		else begin
		    seg_id <= 0;
		end
	end
end

always @(*) begin
    seg_data = 0;
    seg_an = seg_id;
	seg_data = {output_data[seg_id*4+3], output_data[seg_id*4+2],
				 output_data[seg_id*4+1], output_data[seg_id*4]};
end

endmodule
