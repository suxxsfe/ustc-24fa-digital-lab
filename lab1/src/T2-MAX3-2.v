module MAX3(
    input   [7:0]         num1, num2, num3,
    output  [7:0]         max
);

wire [7:0] max1;
MAX2 max1(.num1(num1), .num2(num2), .max(max1));
MAX2 max2(.num1(max1), .num2(num3), .max(max));

endmodule
