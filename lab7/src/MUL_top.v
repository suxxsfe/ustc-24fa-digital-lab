module MUL_top #(
    parameter WIDTH = 4
) (
	input rst, clk, start,
	input [6: 0] sw,
	output [7:0] led,
	output [2: 0] select,
	output [3: 0] out
);

wire [7: 0] res;

MUL2 #(.WIDTH(WIDTH)) mul2(
    .clk(clk), .rst(rst), .start(start),
    .a({1'b0, sw[5:3]}),
    .b({1'b0, sw[2:0]}),
    .res(res)
);

Segment segment(
	.clk(clk), .rst(rst),
	.output_data({24'b1, res[7 : 0]}),
	.seg_data(out), .seg_an(select)
);

assign led[7:0] = res[7:0];

endmodule
