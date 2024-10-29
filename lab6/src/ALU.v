module ALU(
    input                   [31 : 0]        src0, src1,
    input                   [11 : 0]        sel,
    output                  [31 : 0]        res
);

    wire [31:0] adder_out, sub_out;
    wire [0 :0] slt_out, sltu_out, sltu;
    wire [31:0] and_out, or_out, nor_out, xor_out;
    wire [31:0] sll_out, srl_out, sra_out;
    wire [31:0] src1_out;

    //add sub
    Adder8 adder(
        .a(src0),
        .b(src1),
        .ci(0),
        .s(adder_out)
    );
    Adder8 sub(
        .a(src0),
        .b(~src1),
        .ci(1),
        .s(sub_out),
        .co(sltu)
    );

    //slt sltu
    assign slt_out = (src0[31] == src1[31]) ? sub_out[31] : src0[31];
    assign sltu_out = ~sltu;
    
    //and or nor xor
    assign and_out = src0 & src1;
    assign or_out = src0 | src1;
    assign nor_out = ~or_out;
    assign xor_out = src0 ^ src1;
    
    //sll srl sra
    assign sll_out = src0 << src1[4:0];
    assign srl_out = src0 >> src1[4:0];
    assign sra_out = src0 >>> src1[4:0];
    
    //src1
    assign src1_out = src1;
    
    //res
    assign res = ({32{sel[0]}} & adder_out) | ({32{sel[1]}} & sub_out) |
                 ({32{sel[2]}} & slt_out) | ({32{sel[3]}} & sltu_out) |
                 ({32{sel[4]}} & and_out) | ({32{sel[5]}} & or_out) |
                 ({32{sel[6]}} & nor_out) | ({32{sel[7]}} & xor_out) |
                 ({32{sel[8]}} & sll_out) | ({32{sel[9]}} & srl_out) |
                 ({32{sel[10]}} & sra_out) | ({32{sel[11]}} & src1_out);

endmodule
