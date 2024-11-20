module Adder8 #(parameter WIDTH = 64)(
    input                   [WIDTH-1 : 0]      a, b,
    input                   [ 0 : 0]           ci,
    output                  [WIDTH-1 : 0]      s,
    output                  [ 0 : 0]           co
);

    localparam N = (WIDTH + 7) / 8;

    wire [N : 0] cmid;
    assign cmid[0] = ci;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            Adder_LookAhead8 adder(
                .a(a[i*8 +: 8]),
                .b(b[i*8 +: 8]),
                .ci(cmid[i]),
                .s(s[i*8 +: 8]),
                .co(cmid[i+1])
            );
        end
    endgenerate

    assign co = cmid[N];

endmodule
