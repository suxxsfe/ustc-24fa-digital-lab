module Count4Ones(
    input       [2:0]         in,
    output reg  [1:0]         out
);

assign out = {0, in[0]}+{0, in[1]}+{0, in[2]};

endmodule
