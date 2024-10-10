module FindMode_tb();
	reg clk, rst, next;
	reg [7:0] number;
	wire [7:0] ans;
	
	initial begin
		clk = 1;
		rst = 1;
		next = 0;
		
		#20 rst = 0;
		#20 next = 1; number = 8'd10;
		#10 number = 8'd20;
		#10 number = 8'd30;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 number = 8'd20;
		#10 number = 8'd30;
		#10 number = 8'd30;
		#10 number = 8'd30;
		#10 number = 8'd30;
		#10 number = 8'd30;
		#10 number = 8'd30;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 number = 8'd10;
		#10 next = 0;
		
	end
	
	always begin
		#5 clk = ~clk;
	end
	
	FindMode find(
		.clk(clk),
		.rst(rst),
		.next(next),
		.number(number),
		.out(ans)
	);
endmodule
