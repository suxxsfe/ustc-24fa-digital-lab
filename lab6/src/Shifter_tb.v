module Shifter_tb();
    
    reg [31:0] src0;
    reg [4:0] src1;
    wire [31:0] res1_1, res2_1, res1_2, res2_2, res1_12, res2_12;
    
    Shifter_1 shifter1(
        .src0(src0),
        .src1(src1),
        .res1(res1_1),
        .res2(res2_1)
    );
    Shifter_2 shifter2(
        .src0(src0),
        .src1(src1),
        .res1(res1_2),
        .res2(res2_2)
    );
    Shifter_12 shifter12(
        .src0(src0),
        .src1(src1),
        .res1(res1_12),
        .res2(res2_12)
    );
    
    initial begin
        src0=32'h1234; src1=5'h00000;
        repeat(32) begin
            #50 src1 = src1 + 1;
        end
        
        src0 = 32'hfedc_ba88; src1 = 5'h0;
        repeat(32) begin
            #50 src1 = src1 + 1;
        end
    end
endmodule
