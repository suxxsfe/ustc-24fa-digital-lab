module T2(
	input 				  btn,
	input			      clk,
    output reg [7:0]      led
);

wire out;
Counter #(
	.MAX_VALUE(26'd50_000_000)
) counter(
	.out(out),
	.clk(clk),
	.rst(btn)
);

always @(posedge clk) begin
	if(btn) begin
		led <= 0;
	end
	else if(out) begin
		led <= ~led;
	end
end

endmodule
