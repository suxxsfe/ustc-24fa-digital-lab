module Hex2BCD(
    input [11:0] hex,
    output reg [11:0] bcd
);

    integer i;
    always @(*) begin
        bcd = 12'd0;
        for (i = 11; i >= 0; i = i - 1) begin
            if (bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 4'd3;
            if (bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 4'd3;
            if (bcd[11:8] > 4) bcd[11:8] = bcd[11:8] + 4'd3;
            bcd = {bcd[10:0], hex[i]};
        end
    end
    
endmodule
