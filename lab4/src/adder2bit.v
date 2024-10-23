module adder2bit(
    input           [1:0]         a,
    input           [1:0]         b,
    output          [1:0]         out,
    output                        Cout
);

assign out[0] = a[0] ^ b[0];
assign out[1] = (a[0] & b[0]) ^ a[1] ^ b[1];
assign Cout =  (a[0] & b[0] & a[1]) | (a[0] & b[0] & b[1]) | (a[1] & b[1]);

endmodule
