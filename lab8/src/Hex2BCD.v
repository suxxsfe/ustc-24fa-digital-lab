module Hex2BCD(
    input [11: 0] hex,
    output reg [3: 0] bcd1,
    output reg [3: 0] bcd2,
    output reg [3: 0] bcd3
);

    reg [3: 0] i; 
    always @(*) begin
        bcd1 = 0;
        bcd2 = 0;
        bcd3 = 0;
        
        for (i = 11; i >= 0; i = i - 1) begin
            if(bcd1 >= 5)
                bcd1 = bcd1 + 3;
            if(bcd2 >= 5)
                bcd2 = bcd2 + 3;
            if(bcd3 >= 5)
                bcd3 = bcd3 + 3;

            bcd1 = bcd1 << 1;
            bcd1[0] = bcd2[3];
            bcd2 = bcd2 << 1;
            bcd2[0] = bcd3[3];
            bcd3 = bcd3 << 1;

            bcd3[0] = hex[i];
        end
    end

endmodule
