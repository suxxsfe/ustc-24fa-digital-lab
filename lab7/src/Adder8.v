module Adder8(
    input                   [63 : 0]        a, b,
    input                   [ 0 : 0]        ci,
    output                  [63 : 0]        s,
    output                  [ 0 : 0]        co
);

wire    [6:0] cmid;

Adder_LookAhead8 adder0(
    .a(a[7:0]),
    .b(b[7:0]),
    .ci(ci),
    .s(s[7:0]),
    .co(cmid[0])
);
Adder_LookAhead8 adder1(
    .a(a[15:8]),
    .b(b[15:8]),
    .ci(cmid[0]),
    .s(s[15:8]),
    .co(cmid[1])
);

Adder_LookAhead8 adder2(
    .a(a[23:16]),
    .b(b[23:16]),
    .ci(cmid[1]),
    .s(s[23:16]),
    .co(cmid[2])
);
Adder_LookAhead8 adder3(
    .a(a[31:24]),
    .b(b[31:24]),
    .ci(cmid[2]),
    .s(s[31:24]),
    .co(cmid[3])
);

Adder_LookAhead8 adder4(
    .a(a[39:32]),
    .b(b[39:32]),
    .ci(cmid[3]),
    .s(s[39:32]),
    .co(cmid[4])
);
Adder_LookAhead8 adder5(
    .a(a[47:40]),
    .b(b[47:40]),
    .ci(cmid[4]),
    .s(s[47:40]),
    .co(cmid[5])
);

Adder_LookAhead8 adder6(
    .a(a[55:48]),
    .b(b[55:48]),
    .ci(cmid[5]),
    .s(s[55:48]),
    .co(cmid[6])
);
Adder_LookAhead8 adder7(
    .a(a[63:56]),
    .b(b[63:56]),
    .ci(cmid[6]),
    .s(s[63:56]),
    .co(co)
);

endmodule
