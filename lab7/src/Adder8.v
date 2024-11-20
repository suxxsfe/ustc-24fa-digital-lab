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
            wire [8:0] out;
            Adder_LookAhead8 adder(
                .a(i*8+7 < WIDTH ? a[i*8+7 : i*8] :
                                   {{(8*i+8-WIDTH){1'b0}}, a[WIDTH-1 : i*8]}),
                .b(i*8+7 < WIDTH ? b[i*8+7 : i*8] :
                                   {{(8*i+8-WIDTH){1'b0}}, b[WIDTH-1 : i*8]}),
                .ci(cmid[i]),
                .s(out),
                .co(out[8])
            );
            if(i*8+7 < WIDTH) begin
                assign s[i*8+7 : i*8] = out[7 : 0];
                assign cmid[i+1] = out[8];
            end
            else begin
                assign s[WIDTH-1 : i*8] = out[WIDTH-8*i-1 : 0];
                assign cmid[i+1] = out[WIDTH-8*i];
            end
        end
    endgenerate

    assign co = cmid[N];

endmodule
