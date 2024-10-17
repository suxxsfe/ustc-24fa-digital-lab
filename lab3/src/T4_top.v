module T4_top(
    input                   clk,
    input                   btn,
	input  [7:0]			sw,
    output [2:0]            seg_an,
    output [3:0]            seg_data
);
T4 segment(
    .clk(clk),
    .rst(btn),
    .output_data(32'h24000176),
    .seg_data(seg_data),
    .seg_an(seg_an),
	.output_valid(sw)
);
endmodule
