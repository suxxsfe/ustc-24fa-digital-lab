module mul_comb(
    input                   [ 7 : 0]        a,
    input                   [ 7 : 0]        b,
    output                  [15 : 0]        res
);

    wire [15 : 0] val0, val1, val2, val3, val4, val5, val6,
                  val7, val8, val9, val10, val11, val12, val13;

    assign val0 = {16{b[0]}} & {8'b0, a};
    assign val1 = {16{b[1]}} & {7'b0, a, 1'b0};
    assign val2 = {16{b[2]}} & {6'b0, a, 2'b0};
    assign val3 = {16{b[3]}} & {5'b0, a, 3'b0};
    assign val4 = {16{b[4]}} & {4'b0, a, 4'b0};
    assign val5 = {16{b[5]}} & {3'b0, a, 5'b0};
    assign val6 = {16{b[6]}} & {2'b0, a, 6'b0};
    assign val7 = {16{b[7]}} & {1'b0, a, 7'b0};
    
    Adder8 #(.WIDTH(16)) adder0(
        .a(val0), .b(val1), .ci(0),
        .s(val8)
    );
    Adder8 #(.WIDTH(16)) adder1(
        .a(val2), .b(val3), .ci(0),
        .s(val9)
    );
    Adder8 #(.WIDTH(16)) adder2(
        .a(val4), .b(val5), .ci(0),
        .s(val10)
    );
    Adder8 #(.WIDTH(16)) adder3(
        .a(val6), .b(val7), .ci(0),
        .s(val11)
    );
    
    
    Adder8 #(.WIDTH(16)) adder01(
        .a(val8), .b(val9), .ci(0),
        .s(val12)
    );
    Adder8 #(.WIDTH(16)) adder23(
        .a(val10), .b(val11), .ci(0),
        .s(val13)
    );
    
    
    Adder8 #(.WIDTH(16)) adder0123(
        .a(val12), .b(val13), .ci(0),
        .s(res)
    );

endmodule
