module encode_top(
    input [7:0]         sw,
    output [7:0]    led
);

assign led[6:2] = 5'b0;

encode en(
    .I(sw[3:0]),
    .Y(led[1:0]),
    .en(led[7])
);

endmodule
