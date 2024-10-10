module FindMode(
    input                               clk,
    input                               rst,
    input                               next,
    input       [7:0]                   number,
    output reg  [7:0]                   out
); 
	reg [7:0] cnt;
	
	initial begin
		cnt = 0;
	end
	
	always @(posedge clk) begin
		if(rst) begin
			out <= 0;
			cnt <= 0;
		end
		if(next) begin
			if(number == out) begin
				cnt <= cnt+1;
			end
			else if(cnt == 0) begin
				cnt <= 1;
				out <= number;
			end
			else begin
				cnt <= cnt-1;
			end
		end
	end
endmodule
