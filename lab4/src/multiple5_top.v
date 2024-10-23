module multiple5_top(
    input [7:0]     sw,
    output [7:0]    led
);

wire out;

multiple5(
    .num(sw[7:0]),
    .ismultiple5(out)
);

assign led[7:0] = {8{out}};

endmodule
